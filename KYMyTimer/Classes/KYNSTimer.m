//
//  KYNSTimer.m
//  定时器
//
//  Created by 康鹏鹏 on 2019/10/31.
//  Copyright © 2019年 kangpp. All rights reserved.
//

#import "KYNSTimer.h"

@interface KYNSTimer()
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, copy)KYTimerActionBlock timerBlock;
@end

@implementation KYNSTimer {
    BOOL _isResume;
}
@synthesize isResume = _isResume;

- (instancetype)init {
    self = [super init];
    if (self) {
        _isResume = NO;
    }
    return self;
}

- (nonnull id<KYTimerProtocol>)createTimerWithTimerInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(nonnull KYTimerActionBlock)block {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    return [self createTimerWithTimerInterval:interval repeats:repeats queue:queue block:block];
}

- (nonnull id<KYTimerProtocol>)createTimerWithTimerInterval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(nonnull dispatch_queue_t)queue block:(nonnull KYTimerActionBlock)block {
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(queue, ^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        strongSelf.timer = [NSTimer timerWithTimeInterval:interval repeats:repeats block:^(NSTimer * _Nonnull timer) {
//            block();
//        }];
//    });
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer timerWithTimeInterval:interval repeats:repeats block:^(NSTimer * _Nonnull timer) {
            dispatch_async(queue, ^{
                block();
            });
        }];
    } else {
        self.timerBlock = block;
        self.timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(timerTask) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)timerTask {
    if (self.timerBlock) {
        self.timerBlock();
    }
}

- (void)cancel {
    [_timer invalidate];
    _timer = nil;
}

- (void)resume {
    if (_isResume) {
        return;
    }
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer setFireDate:[NSDate date]];
    _isResume = YES;
}

- (void)suspend {
    if (_isResume == NO) {
        return;
    }
    [_timer setFireDate:[NSDate distantFuture]];
    _isResume = NO;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}


@end
