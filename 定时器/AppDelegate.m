//
//  AppDelegate.m
//  定时器
//
//  Created by 康鹏鹏 on 2019/10/29.
//  Copyright © 2019年 kangpp. All rights reserved.
//

#import "AppDelegate.h"
#import "KYTimer/KYTimerManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate {
    UIBackgroundTaskIdentifier _backgroundUpdateTask;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self beingBackgroundUpdateTask];
}
- (void)beingBackgroundUpdateTask {
    
    _backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"任务销毁");
        [self endBackgroundUpdateTask];//如果在规定时间内任务没有完成，会调用这个方法。
    }];
}

- (void)endBackgroundUpdateTask {
    NSLog(@"endBackgroundUpdateTask");
    [[UIApplication sharedApplication] endBackgroundTask: _backgroundUpdateTask];
    _backgroundUpdateTask = UIBackgroundTaskInvalid;
}



@end
