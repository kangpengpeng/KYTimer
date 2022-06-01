//
//  KYTimerManager.m
//  定时器
//
//  Created by 康鹏鹏 on 2019/10/30.
//  Copyright © 2019年 kangpp. All rights reserved.
//

#import "KYTimerManager.h"
#import "KYGCDTimer.h"
#import "KYNSTimer.h"
#import "KYDsLinkTimer.h"

static KYTimerManager *_timerManager;

@interface KYTimerManager()
/** 保存定时器(<KYTimerProtocol>)字典 */
@property (nonatomic, strong)NSMutableDictionary<KYTimerProtocol> *timerDict;
/** 初始化 Timer 的类型 */
@property (nonatomic, assign)KYTimerType timerType;
/** 字典保存时用到的锁，防止多线程读写崩溃 */
@property (nonatomic, strong) NSRecursiveLock *lock;
@end

@implementation KYTimerManager

#pragma mark -: KYTimerManager 单例
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _timerManager = [[KYTimerManager alloc] init];
        _timerManager.timerType = KYTimerTypeGCD;
        _timerManager.lock = [[NSRecursiveLock alloc] init];
    });
    return _timerManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _timerManager = [super allocWithZone:zone];
    });
    return _timerManager;
}

- (id)copyWithZone:(NSZone *)zone {
    return _timerManager;
}

#pragma mark -: 创建定时器，自动启动
/** 创建并启动一个定时器 */
- (void)scheduleTimerWithName:(NSString *)timerName interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(KYTimerActionBlock)block {
    dispatch_queue_t queue = [self getDefaultQueue];
    [self timerWithName:timerName timerType:_timerType queue:queue interval:interval repeats:repeats block:block];
    [self resumeTimerWithName:timerName];
}
/** 创建并启动一个定时器 */
- (void)scheduleTimerWithTimerName:(NSString *)timerName timerType:(KYTimerType)timerType interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(KYTimerActionBlock)block {
    dispatch_queue_t queue = [self getDefaultQueue];
    [self timerWithName:timerName timerType:timerType queue:queue interval:interval repeats:repeats block:block];
    [self resumeTimerWithName:timerName];
    
}

/** 创建并启动一个定时器 */
- (void)scheduleTimerWithName:(NSString *)timerName queue:(dispatch_queue_t)queue interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(KYTimerActionBlock)block {
    [self timerWithName:timerName timerType:_timerType queue:queue interval:interval repeats:repeats block:block];
    [self resumeTimerWithName:timerName];
}
/** 创建并启动一个定时器 */
- (void)scheduleTimerWithName:(NSString *)timerName timerType:(KYTimerType)timerType queue:(dispatch_queue_t)queue interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(KYTimerActionBlock)block {
    [self timerWithName:timerName timerType:timerType queue:queue interval:interval repeats:repeats block:block];
    [self resumeTimerWithName:timerName];
}


#pragma mark -: 创建定时器，手动启动
/** 创建一个定时器（需要手动启动）*/
- (void)timerWithName:(NSString *)timerName interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(KYTimerActionBlock)block {
    dispatch_queue_t queue = [self getDefaultQueue];
    [self timerWithName:timerName timerType:_timerType queue:queue interval:interval repeats:repeats block:block];
}

- (void)timerWithName:(NSString *)timerName timerType:(KYTimerType)timerType interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(KYTimerActionBlock)block {
    dispatch_queue_t queue = [self getDefaultQueue];
    [self timerWithName:timerName timerType:timerType queue:queue interval:interval repeats:repeats block:block];
}

/** 创建一个定时器（需要手动启动）*/
- (void)timerWithName:(NSString *)timerName queue:(dispatch_queue_t)queue interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(KYTimerActionBlock)block {
    [self timerWithName:timerName timerType:_timerType queue:queue interval:interval repeats:repeats block:block];
}

/** 创建一个定时器（需要手动启动）*/
- (void)timerWithName:(NSString *)timerName timerType:(KYTimerType)timerType queue:(dispatch_queue_t)queue interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(KYTimerActionBlock)block {
    if ([timerName isKindOfClass:[NSNull class]] || timerName == nil || [timerName length] < 1) {
        return;
    }
    [_lock lock];
    id<KYTimerProtocol> timerPro = [self.timerDict objectForKey:timerName];
    if (timerPro == nil) {
        // 待优化初始化方案
        switch (timerType) {
            case KYTimerTypeGCD:
                timerPro = [[KYGCDTimer alloc] init];
                break;
            case KYTimerTypeNSTimer:
                timerPro = [[KYNSTimer alloc] init];
                break;
            case KYTimerTypeDsLink:
                NSAssert(NO, @"KYTimerTypeDsLink 该方式已不准确，因为120HZ的高刷机存在");
                timerPro = [[KYDsLinkTimer alloc] init];
                break;
            default:
                timerPro = [[KYGCDTimer alloc] init];
                break;
        }
    } else {
        NSLog(@"该定时器已存在 ===> %@", timerName);
        return;
    }
    timerPro = [timerPro createTimerWithTimerInterval:interval repeats:repeats queue:queue block:block];
    [_timerDict setObject:timerPro forKey:timerName];
    [_lock unlock];
}


/** 激活定时器 */
- (void)resumeTimerWithName:(NSString *)timerName {
    id<KYTimerProtocol> timer = [self.timerDict objectForKey:timerName];
    if (timer) {
        [timer resume];
    } else {
        NSLog(@"resumeTimerWithName: 未找到定时器（已被释放）");
    }
}

/** 挂起定时器任务 */
- (void)suspendTimerWithName:(NSString *)timerName {
    id<KYTimerProtocol> timer = [self.timerDict objectForKey:timerName];
    if (timer) {
        [timer suspend];
    } else {
        NSLog(@"suspendTimerWithName: 未找到定时器（已被释放）");
    }
}

/** 取消定时器（释放）*/
- (void)cancelTimerWithName:(NSString *)timerName {
    id<KYTimerProtocol> timer = [self.timerDict objectForKey:timerName];
    [timer cancel];
    [self.timerDict removeObjectForKey:timerName];
}


#pragma mark: - getter & setter
- (NSMutableDictionary *)timerDict {
    if (!_timerDict) {
        _timerDict = [[NSMutableDictionary<KYTimerProtocol> alloc] init];
    }
    return _timerDict;
}

#pragma mark: - 私有方法
/** 获取默认执行队列 */
- (dispatch_queue_t)getDefaultQueue {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
