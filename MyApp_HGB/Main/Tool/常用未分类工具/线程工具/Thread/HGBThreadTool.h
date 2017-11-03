//
//  HGBThreadTool.h
//  测试
//
//  Created by huangguangbao on 2017/8/10.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^HGBThreadBlock)(void);

@interface HGBThreadTool : NSObject

#pragma mark 线程执行
/**
 主线程

 @param block 块
 */
+(void)performActionOnMainThread:(HGBThreadBlock)block;
/**
 全局线程

 @param block 块
 */
+(void)performActionOnGlobalThread:(HGBThreadBlock)block;
/**
 新开线程

 @param block 块
 @param threadFlag 队列标记
 */
+(void)performAction:(HGBThreadBlock)block onThreadWithThreadFlag:(NSString *)threadFlag;

#pragma  mark 仅执行一次
/**
 仅执行一次

 @param block 块
 */
+(void)performActionOnlyOnce:(HGBThreadBlock)block;
#pragma mark 延时执行
/**
 主线程延时执行

 @param block 块
 @param second 延时秒数
 */
+(void)performActionOnMainThread:(HGBThreadBlock)block afterSecond:(NSInteger)second;
/**
 全局程延时执行

 @param block 块
 @param second 延时秒数
 */
+(void)performActionOnGlobalThread:(HGBThreadBlock)block afterSecond:(NSInteger)second;
/**
 线程延时执行

 @param block 块
 @param second 延时秒数
 @param thread 线程队列-为空时主线程
 */
+(void)performAction:(HGBThreadBlock)block afterSecond:(NSInteger)second OnThread:(dispatch_queue_t)thread;
#pragma mark 顺序执行
/**
 主线程循序执行

 @param blocks 块集合
 */
+(void)performActionsInOrderOnMainThread:(NSArray <HGBThreadBlock>*)blocks;
/**
 全局程循序执行

 @param blocks 块集合
 */
+(void)performActionsInOrderOnGlobalThread:(NSArray <HGBThreadBlock>*)blocks;
/**
 线程循序执行

 @param blocks 块集合
 @param thread 线程队列-为空时主线程
 */
+(void)performActionsInOrder:(NSArray <HGBThreadBlock>*)blocks OnThread:(dispatch_queue_t)thread;
#pragma mark 非常用线程
/**
 异步并发

 @param blocks 块集合
 @param threadFlag 队列标记
 */
+(void)performActionsConCurrentAsync:(NSArray <HGBThreadBlock>*)blocks onThreadWithThreadFlag:(NSString *)threadFlag;
/**
 同步并发

 @param blocks 块集合
 @param threadFlag 队列标记
 */
+(void)performActionsConCurrentSync:(NSArray <HGBThreadBlock>*)blocks onThreadWithThreadFlag:(NSString *)threadFlag;
/**
 异步串行

 @param blocks 块集合
 @param threadFlag 队列标记
 */
+(void)performActionsSerialAsync:(NSArray <HGBThreadBlock>*)blocks onThreadWithThreadFlag:(NSString *)threadFlag;
/**
 同步串行

 @param blocks 块集合
 @param threadFlag 队列标记
 */
+(void)performActionsSerialSync:(NSArray <HGBThreadBlock>*)blocks onThreadWithThreadFlag:(NSString *)threadFlag;

#pragma mark 获取线程
/**
 获取主线程

 @return 主线程
 */
+(dispatch_queue_t)getMainThread;
/**
 获取全局线程

 @return 全局线程
 */
+(dispatch_queue_t)getGlobalThread;

/**
 获取新线程

 @param threadFlag 新线程标志
 @return 新线程
 */
+(dispatch_queue_t)getNewThreadWithThreadFlag:(NSString *)threadFlag;


@end
