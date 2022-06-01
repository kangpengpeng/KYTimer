//
//  KYGCDTimer.m
//  定时器
//
//  Created by 康鹏鹏 on 2019/10/30.
//  Copyright © 2019年 kangpp. All rights reserved.
//

#import "KYGCDTimer.h"
#import "KYTimerProtocol.h"


@implementation KYGCDTimer {
    dispatch_source_t _timer;
    dispatch_queue_t _queue;
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

- (id<KYTimerProtocol>)createTimerWithTimerInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(KYTimerActionBlock)block {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    return [self createTimerWithTimerInterval:interval repeats:repeats queue:queue block:block];
}

- (id<KYTimerProtocol>)createTimerWithTimerInterval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(dispatch_queue_t)queue block:(KYTimerActionBlock)block {
    if (nil == queue) {
        // 创建一个队列
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    // 2 创建一个 timer 类型事件源
    // 参数一：事件源类型
    // 参数二：预留参数，写 0 即可
    // 参数三：精度参数，使用 DISPATCH_TIMER_STRICT 耗电加剧
    // 参数四：timer 任务队列
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, DISPATCH_TIMER_STRICT, queue);
    // 3 设置 timer 任务属性
    // 参数一：
    // 参数二：延迟时间 单位也是纳秒
    // 参数三：时间间隔 单位是纳秒
    // 参数四：允许误差
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval*NSEC_PER_SEC, 0.1);
    // 4 timer 处理事件 block
    dispatch_source_set_event_handler(timer, block);
    _timer = timer;
    _queue = queue;
    return self;
}

- (void)resume {
    if (_isResume) {
        return;
    }
    // 激活
    dispatch_resume(_timer);
    _isResume = YES;
}

- (void)suspend {
    if (_isResume && _timer) {
        dispatch_suspend(_timer);
        _isResume = NO;
    }
}

- (void)cancel {
    if (_isResume == NO) {
        [self resume];
    }
    // 取消
    dispatch_source_cancel(_timer);
    _timer = nil;
    _isResume = NO;
}






- (void)dealloc {
    // Manager中已有cancel操作，保存定时器的数组，remove时也会走到delloc，导致两次cancel，结果崩溃
//    [self cancel];
    NSLog(@"%s", __func__);
}


@end
