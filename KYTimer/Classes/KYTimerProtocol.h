//
//  KYTimerProtocol.h
//  定时器
//
//  Created by 康鹏鹏 on 2019/10/30.
//  Copyright © 2019年 kangpp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KYTimerActionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@protocol KYTimerProtocol <NSObject>
@property (nonatomic, assign)BOOL isResume;

/**
 创建一个timer
 @param interval        定时器任务时间间隔
 @param repeats         是否循环调用
 @param block           定时器任务
 */
- (id<KYTimerProtocol>)createTimerWithTimerInterval:(NSTimeInterval)interval
                                            repeats:(BOOL)repeats
                                              block:(KYTimerActionBlock)block;

/**
 启动一个timer
 @param interval        定时器任务时间间隔
 @param repeats         是否循环调用
 @param queue           定时器任务执行队列
 @param block           定时器任务
 */
- (id<KYTimerProtocol>)createTimerWithTimerInterval:(NSTimeInterval)interval
                                            repeats:(BOOL)repeats
                                              queue:(dispatch_queue_t)queue
                                              block:(KYTimerActionBlock)block;

/** 启动定时器任务 */
- (void)resume;
/** 挂起定时器任务 */
- (void)suspend;
/** 销毁定时器任务 */
- (void)cancel;

/** 获取定时器状态 */
//- (BOOL)getResumeState;

@end

NS_ASSUME_NONNULL_END
