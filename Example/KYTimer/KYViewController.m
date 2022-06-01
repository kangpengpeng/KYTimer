//
//  KYViewController.m
//  KYTimer
//
//  Created by 搁浅de烟花 on 06/01/2022.
//  Copyright (c) 2022 搁浅de烟花. All rights reserved.
//

#import "KYViewController.h"
#import <KYTimerManager.h>

@interface KYViewController ()

@end

@implementation KYViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //[self timerTest_01];
    [self timerTest_02];
}

- (void)timerTest_02 {
    // 第二种定时器调用方式，自动启动
    static int i = 0;
    [[KYTimerManager shared] scheduleTimerWithName:@"com.kpp.timerExample" interval:1 repeats:YES block:^{
        i++;
        NSLog(@"定时器任务 %d", i);
        if (i > 10) {
            NSLog(@"定时器销毁");
            [[KYTimerManager shared] cancelTimerWithName:@"com.kpp.timerExample"];
        }
    }];
}

- (void)timerTest_01 {
    // 第一种定时器调用方式，需要调用者手动启动
    static int i = 0;
    [[KYTimerManager shared] timerWithName:@"com.kpp.timerExample" interval:1 repeats:YES block:^{
        i++;
        NSLog(@"定时器任务 %d", i);
        if (i > 10) {
            NSLog(@"定时器销毁");
            [[KYTimerManager shared] cancelTimerWithName:@"com.kpp.timerExample"];
        }
    }];
    [[KYTimerManager shared] resumeTimerWithName:@"com.kpp.timerExample"];
}

@end
