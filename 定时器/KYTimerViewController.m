//
//  KYSecondVC.m
//  定时器
//
//  Created by 康鹏鹏 on 2019/10/29.
//  Copyright © 2019年 kangpp. All rights reserved.
//

//解决block循环引用
#ifndef    weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef    strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif

#import "KYTimerViewController.h"
#import "KYTimerManager.h"

@interface KYTimerViewController ()
@property (nonatomic, strong)NSTimer *myTimer;
@property (nonatomic, strong)dispatch_source_t gcdTimer;
@property (nonatomic, strong)CADisplayLink *dspLink;
@property (nonatomic, strong)NSString *testString;
@end

@implementation KYTimerViewController

- (void)setupSubviews {
    UITextView *tv = [[UITextView alloc] init];
    tv.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.00Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.00Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.00";
    tv.frame = CGRectMake(100, 200, 200, 400);
    [self.view addSubview:tv];
    
    UIButton *resumeBtn = [[UIButton alloc] init];
    resumeBtn.frame = CGRectMake(50, 100, 80, 40);
    resumeBtn.backgroundColor = [UIColor blueColor];
    [resumeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resumeBtn setTitle:@"启动" forState:UIControlStateNormal];
    [resumeBtn addTarget:self action:@selector(resumeTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resumeBtn];
    
    UIButton *suspendBtn = [[UIButton alloc] init];
    suspendBtn.frame = CGRectMake(230, 100, 80, 40);
    suspendBtn.backgroundColor = [UIColor blueColor];
    [suspendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [suspendBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [suspendBtn addTarget:self action:@selector(suspendTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:suspendBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(50, 200, 280, 40);
    cancelBtn.backgroundColor = [UIColor blueColor];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"销毁" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

- (void)resumeTimer {
    [[KYTimerManager shared] resumeTimerWithName:@"com.kpp.mytimer3"];
}

- (void)suspendTimer {
    [[KYTimerManager shared] suspendTimerWithName:@"com.kpp.mytimer3"];
}

- (void)cancelTimer {
    [[KYTimerManager shared] cancelTimerWithName:@"com.kpp.mytimer3"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self setupSubviews];
    
    static int i = 0;
    
    
//    [[KYTimerManager shared] scheduleTimerWithName:@"com.kpp.mytimer3" timerType:KYTimerTypeNSTimer queue:dispatch_queue_create("com.kpp.myqueue", 0) interval:1 repeats:YES block:^{
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            i++;
//            NSLog(@"===> %d %@", i, [NSThread currentThread]);
//        });
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            i++;
//            NSLog(@"定时器任务 ===> %d %@", i, [NSThread currentThread]);
//        });
//    }];
    
    __weak typeof(self) weakSelf = self;
    [[KYTimerManager shared] timerWithName:@"com.kpp.mytimer3" timerType:KYTimerTypeGCD queue:dispatch_queue_create("com.kpp.myqueue", 0) interval:0.02 repeats:YES block:^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.testString = @".........";
        i++;
        NSLog(@"定时器任务 ===> %d %@", i, [NSThread currentThread]);
    }];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[KYTimerManager shared] cancelTimerWithName:@"com.kpp.mytimer3"];
}





/** NSTimer */
- (void)test_1 {
    static int i = 0;
    
    __weak typeof(self) weakSelf = self;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.testString = @".........";
        i++;
        NSLog(@"定时器任务1 ===> %d", i);
    }];
    
    
//    __weak typeof(self) weakSelf = self;
//    self.myTimer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        __strong typeof(self) strongSelf = weakSelf;
//        strongSelf.testString = @".........";
//        i++;
//        NSLog(@"定时器任务 ===> %d", i);
//    }];
//    [self.myTimer fire];
//    [[NSRunLoop currentRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
    
    // 当 timer 对 self 也持有引用的时候，不能在 delloc 中释放（不会走delloc），需要先打破这种循环引用
//    self.myTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [self.myTimer fire];
//    [[NSRunLoop currentRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
    
}

- (void)timerAction {
    static int i = 0;
    i++;
    NSLog(@"定时器任务 ===> %d", i);
    NSLog(@"%@", [NSThread currentThread]);
}

/** GCD 定时器 */
- (void)test_2 {
    // 1 创建一个队列
    dispatch_queue_t queue = dispatch_queue_create(0, 0);
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
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1*NSEC_PER_SEC, 0);
    // 4 timer 处理事件 block
    dispatch_source_set_event_handler(timer, ^{
        static int i = 0;
        i++;
        NSLog(@"定时器任务 ===> %d", i);
    });
    // 激活
    dispatch_resume(timer);
    self.gcdTimer = timer;
}

/** CADisplayLink */
- (void)test_3 {
    // 不能在 delloc 中销毁该对象，因为self对它有一个强引用，不会走delloc，需要 pop 界面前暂停并销毁。
    self.dspLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAction)];
    self.dspLink.preferredFramesPerSecond = 1;
    // 必须添加到runloop中才能执行
    [self.dspLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)displayAction {
    static int i = 0;
    i++;
    NSLog(@"定时器任务 ===> %d", i);
    if (i%10 == 0) {
        i = 0;
        self.dspLink.paused = YES;
        [self.dspLink invalidate];
    }
}

- (void)dealloc {
    [[KYTimerManager shared] cancelTimerWithName:@"com.kpp.mytimer"];
    
    [self.myTimer invalidate];
    self.myTimer = nil;
    
    if (self.gcdTimer) {
        dispatch_source_cancel(self.gcdTimer);
    }
    
    [self.dspLink invalidate];
    NSLog(@"%s", __func__);
}




/*
 dispatch_suspend 状态下无法释放
 如果调用 dispatch_suspend 后 timer 是无法被释放的。一般情况下会发生崩溃并报“EXC_BAD_INSTRUCTION”错误，看下 GCD 源码dispatch source release 的时候判断了当前是否是在暂停状态。
 所以，dispatch_suspend 状态下直接释放当前控制器或者释放定时器，会导致定时器崩溃。
 并且初始状态(未调用dispatch_resume)、挂起状态，都不能直接调用dispatch_source_cancel(timer)，调用就会导致app闪退。
 建议一：尽量不使用dispatch_suspend，在dealloc方法中，在dispatch_resume状态下直接使用dispatch_source_cancel来取消定时器。
 建议二：使用懒加载创建定时器，并且记录当timer 处于dispatch_suspend的状态。这些时候，只要在 调用dealloc 时判断下，已经调用过 dispatch_suspend 则再调用下 dispatch_resume后再cancel，然后再释放timer。
 
 停止 Timer
 停止 Dispatch Timer 有两种方法，一种是使用 dispatch_suspend，另外一种是使用 dispatch_source_cancel。
 dispatch_suspend 严格上只是把 Timer 暂时挂起，它和 dispatch_resume 是一个平衡调用，两者分别会减少和增加 dispatch 对象的挂起计数。当这个计数大于 0 的时候，Timer 就会执行。在挂起期间，产生的事件会积累起来，等到 resume 的时候会融合为一个事件发送。
 dispatch_source_cancel 则是真正意义上的取消 Timer。被取消之后如果想再次执行 Timer，只能重新创建新的 Timer。这个过程类似于对 NSTimer 执行 invalidate。
 关于取消 Timer，另外一个很重要的注意事项，dispatch_suspend 之后的 Timer，是不能被释放的！下面的代码会引起崩溃：
 - (void)dealloc
 {
 dispatch_suspend(_timer);
 _timer = nil; // EXC_BAD_INSTRUCTION 崩溃
 }
 因此使用 dispatch_suspend 时，Timer 本身的实例需要一直保持。使用 dispatch_source_cancel 则没有这个限制：
 - (void)dealloc
 {
 dispatch_source_cancel(_timer);
 _timer = nil; // OK
 }
 
 总结：
 Dispatch Source使用最多的就是用来实现定时器，source创建后默认是暂停状态，需要手动调用dispatch_resume启动定时器。
 Dispatch Source定时器使用时也有一些需要注意的地方，不然很可能会引起crash：
 1、循环引用：因为dispatch_source_set_event_handler回调是个block，在添加到source的链表上时会执行copy并被source强引用，如果block里持有了self，self又持有了source的话，就会引起循环引用。正确的方法是使用weak+strong或者提前调用dispatch_source_cancel取消timer。
 2、dispatch_resume和dispatch_suspend调用次数需要平衡，如果重复调用dispatch_resume则会崩溃,因为重复调用会让dispatch_resume代码里if分支不成立，从而执行了DISPATCH_CLIENT_CRASH("Over-resume of an object")导致崩溃。
 3、source在suspend状态下，如果直接设置source = nil或者重新创建source都会造成crash。正确的方式是在resume状态下调用dispatch_source_cancel(source)释放当前的source。
 */

@end

