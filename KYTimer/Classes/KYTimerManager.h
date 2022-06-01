//
//  KYTimerManager.h
//  定时器
//
//  Created by 康鹏鹏 on 2019/10/30.
//  Copyright © 2019年 kangpp. All rights reserved.
//
/*
 当使用 KYTimerTypeDsLink 时，由于屏幕刷新率问题，interval 取值范围 0.016 < interval <= 1
 否则与屏幕刷新同步，每秒钟执行 60 次
 interval 取值范围从 0.016（1/60） 到 1，
 */
#import <Foundation/Foundation.h>
#import "KYTimerProtocol.h"

/** timer 实现方式的枚举类型 */
typedef enum : NSUInteger {
    KYTimerTypeNSTimer,
    KYTimerTypeGCD,
    KYTimerTypeDsLink,
} KYTimerType;

NS_ASSUME_NONNULL_BEGIN

@interface KYTimerManager : NSObject


#pragma mark: - 管理类单例
/** Timer 管理单例 默认使用GCD实现 */
+ (instancetype)shared;

#pragma mark: - 创建定时器并自动启动
/**
 创建并启动一个timer (默认精度为0.1s，全局队列)
 @param timerName       timer 名称（唯一标识）
 @param timerType       定时器实现方式
 @param interval        定时器任务时间间隔
 @param repeats         是否循环调用
 @param block           定时器任务
 */
- (void)scheduleTimerWithTimerName:(NSString *)timerName
                         timerType:(KYTimerType)timerType
                          interval:(NSTimeInterval)interval
                           repeats:(BOOL)repeats
                             block:(KYTimerActionBlock)block;

/**
 创建并启动一个timer (默认精度为0.1s)
 @param timerName       timer 名称（唯一标识）
 @param timerType       定时器实现方式
 @param queue           任务执行队列
 @param interval        定时器任务时间间隔
 @param repeats         是否循环调用
 @param block           定时器任务
 */
- (void)scheduleTimerWithName:(NSString *)timerName
                    timerType:(KYTimerType)timerType
                        queue:(dispatch_queue_t)queue
                     interval:(NSTimeInterval)interval
                      repeats:(BOOL)repeats
                        block:(KYTimerActionBlock)block;

/**
 创建并启动一个timer (默认精度为0.1s，全局队列)
 @param timerName       timer 名称（唯一标识）
 @param interval        定时器任务时间间隔
 @param repeats         是否循环调用
 @param block           定时器任务
 */
- (void)scheduleTimerWithName:(NSString *)timerName
                     interval:(NSTimeInterval)interval
                      repeats:(BOOL)repeats
                        block:(KYTimerActionBlock)block;

/**
 创建并启动一个timer (默认精度为0.1s)
 @param timerName       timer 名称（唯一标识）
 @param queue           任务执行队列
 @param interval        定时器任务时间间隔
 @param repeats         是否循环调用
 @param block           定时器任务
 */
- (void)scheduleTimerWithName:(NSString *)timerName
                        queue:(dispatch_queue_t)queue
                     interval:(NSTimeInterval)interval
                      repeats:(BOOL)repeats
                        block:(KYTimerActionBlock)block;



#pragma mark: - 创建定时器手动启动
/**
 创建一个timer，需要手动调用 resumeTimerWithName: 启动 (默认精度为0.1s)
 @param timerName       timer 名称（唯一标识）
 @param interval        定时器任务时间间隔
 @param repeats         是否循环调用
 @param block           定时器任务
 */
- (void)timerWithName:(NSString *)timerName
             interval:(NSTimeInterval)interval
              repeats:(BOOL)repeats
                block:(KYTimerActionBlock)block;

/**
 创建一个timer，需要手动调用 resumeTimerWithName: 启动 (默认精度为0.1s)
 @param timerName       timer 名称（唯一标识）
 @param timerType       定时器实现方式
 @param interval        定时器任务时间间隔
 @param repeats         是否循环调用
 @param block           定时器任务
 */
- (void)timerWithName:(NSString *)timerName
            timerType:(KYTimerType)timerType
             interval:(NSTimeInterval)interval
              repeats:(BOOL)repeats
                block:(KYTimerActionBlock)block;

/**
 创建一个timer，需要手动调用 resumeTimerWithName: 启动 (默认精度为0.1s)
 @param timerName       timer 名称（唯一标识）
 @param interval        定时器任务时间间隔
 @param repeats         是否循环调用
 @param queue           任务执行队列
 @param block           定时器任务
 */
- (void)timerWithName:(NSString *)timerName
                queue:(dispatch_queue_t)queue
             interval:(NSTimeInterval)interval
              repeats:(BOOL)repeats
                block:(KYTimerActionBlock)block;

/**
 创建一个timer，需要手动调用 resumeTimerWithName: 启动 (默认精度为0.1s)
 @param timerName       timer 名称（唯一标识）
 @param timerType       定时器实现方式
 @param queue           任务执行队列
 @param interval        定时器任务时间间隔
 @param repeats         是否循环调用
 @param block           定时器任务
 */
- (void)timerWithName:(NSString *)timerName
            timerType:(KYTimerType)timerType
                queue:(dispatch_queue_t)queue
             interval:(NSTimeInterval)interval
              repeats:(BOOL)repeats
                block:(KYTimerActionBlock)block;





/**
 启动定时器任务
 @param timerName       timer 名称（唯一标识）
 */
- (void)resumeTimerWithName:(NSString *)timerName;

/**
 暂停定时器任务
 @param timerName       timer 名称（唯一标识）
 */
- (void)suspendTimerWithName:(NSString *)timerName;

/**
 取消定时器任务
 @param timerName       timer 名称（唯一标识）
 */
- (void)cancelTimerWithName:(NSString *)timerName;

@end

NS_ASSUME_NONNULL_END
