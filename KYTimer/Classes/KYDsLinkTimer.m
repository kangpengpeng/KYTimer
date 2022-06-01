//
//  KYDsLinkTimer.m
//  定时器
//
//  Created by 康鹏鹏 on 2019/11/1.
//  Copyright © 2019年 kangpp. All rights reserved.
//

#import "KYDsLinkTimer.h"

@interface KYDsLinkTimer()
@property (nonatomic, strong) CADisplayLink *dsLink;
@property (nonatomic, copy) KYTimerActionBlock timerBlock;
@end

@implementation KYDsLinkTimer {
    dispatch_queue_t _queue;
    BOOL _isResume;
}
@synthesize isResume;

- (instancetype)init {
    self = [super init];
    if (self) {
        _isResume = NO;
    }
    return self;
}

- (nonnull id<KYTimerProtocol>)createTimerWithTimerInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(nonnull KYTimerActionBlock)block {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    return [self createTimerWithTimerInterval:interval repeats:repeats queue:queue block:block];
}

- (nonnull id<KYTimerProtocol>)createTimerWithTimerInterval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(nonnull dispatch_queue_t)queue block:(nonnull KYTimerActionBlock)block {
    _queue = queue;
    _timerBlock = block;
    self.dsLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAction)];
    // interval 取值范围从 0.016（1/60） 到 1，
    if (@available(iOS 10.0, *)) {
        // preferredFramesPerSecond 定义此显示所需的回调速率(以帧/秒为单位)
        self.dsLink.preferredFramesPerSecond = 1 / interval;
    } else {
        // 每隔多少帧触发一次
        self.dsLink.frameInterval = 60 * (interval / 1);
    }
    return self;
}

- (void)displayAction {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.timerBlock();
    });
}

- (void)resume {
    if (_isResume) {
        return;
    }
    // 必须添加到runloop中才能执行
    [self.dsLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _isResume = YES;
}

- (void)suspend {
    if (_isResume == NO) {
        return;
    }
    [self.dsLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _isResume = NO;
}

- (void)cancel {
    [self.dsLink invalidate];
    // 取消定时器时，打破 self 对 dsLink 的引用，否则无法释放
    self.dsLink = nil;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
