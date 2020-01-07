//
//  ViewController.m
//  定时器
//
//  Created by 康鹏鹏 on 2019/10/29.
//  Copyright © 2019年 kangpp. All rights reserved.
//

#import "ViewController.h"
#import "KYTimerViewController.h"
#import "KYTimer/KYTimerManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    static int i = 60;
    self.timeLb.text = [NSString stringWithFormat:@"%d", i];

    __weak typeof(self) weakSelf = self;
    [[KYTimerManager shared] scheduleTimerWithName:@"com.kpp.bgtimer" interval:1 repeats:YES block:^{
        __strong typeof(self) strongSelf = weakSelf;
        i -= 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.timeLb.text = [NSString stringWithFormat:@"%d", i];
        });
        NSLog(@"后台任务 %d", i);
        if (i==0) {
            [[KYTimerManager shared] cancelTimerWithName:@"com.kpp.bgtimer"];
        }
    }];
    
//    UIApplication *app = [UIApplication sharedApplication];
//    __block UIBackgroundTaskIdentifier bgTask;
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (bgTask != UIBackgroundTaskInvalid) {
//                NSLog(@"销毁");
//                bgTask = UIBackgroundTaskInvalid;
//            }
//        });
//    }];
    

    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    KYTimerViewController *timerVC = [[KYTimerViewController alloc] init];
    [self.navigationController pushViewController:timerVC animated:YES];
}

@end
