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
    self.timer = [NSTimer timerWithTimeInterval:interval repeats:repeats block:^(NSTimer * _Nonnull timer) {
        dispatch_async(queue, ^{
            block();
        });
    }];
    return self;
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

- (BOOL)getResumeState {
    return _isResume;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}


@end
