//
//  HGBThreadTool.m
//  测试
//
//  Created by huangguangbao on 2017/8/10.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBThreadTool.h"
#import <UIKit/UIKit.h>
@interface HGBThreadTool()
@property(strong,nonatomic)NSMutableDictionary *queen;
@end
@implementation HGBThreadTool
#pragma mark 线程执行
/**
 主线程

 @param block 块
 */
+(void)performActionOnMainThread:(HGBThreadBlock)block{
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}
/**
 全局线程

 @param block 块
 */
+(void)performActionOnGlobalThread:(HGBThreadBlock)block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        block();
    });
}
/**
 新开线程

 @param block 块
 @param threadFlag 队列标记
 */
+(void)performAction:(HGBThreadBlock)block onThreadWithThreadFlag:(NSString *)threadFlag{
    if(threadFlag==nil||threadFlag.length==0){
        threadFlag=@"queue";
    }
    dispatch_queue_t queue=dispatch_queue_create([threadFlag UTF8String], DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        block();
    });
}
#pragma mark 仅执行一次
/**
 仅执行一次

 @param block 块
 */
+(void)performActionOnlyOnce:(HGBThreadBlock)block{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        block();
    });
}
#pragma mark 延时执行

/**
 主线程延时执行

 @param block 块
 @param second 延时秒数
 */
+(void)performActionOnMainThread:(HGBThreadBlock)block afterSecond:(NSInteger)second{
    if(second<0){
        second=0;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });

}
/**
 全局程延时执行

 @param block 块
 @param second 延时秒数
 */
+(void)performActionOnGlobalThread:(HGBThreadBlock)block afterSecond:(NSInteger)second{
    if(second<0){
        second=0;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)),dispatch_get_global_queue(0, 0), ^{
        block();
    });
}
/**
 线程延时执行

 @param block 块
 @param second 延时秒数
 @param thread 线程队列-为空时主线程
 */
+(void)performAction:(HGBThreadBlock)block afterSecond:(NSInteger)second OnThread:(dispatch_queue_t)thread{
    if(thread==nil){
        thread=[HGBThreadTool getMainThread];
    }
    if(second<0){
        second=0;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)),thread, ^{
        block();
    });
}
#pragma mark 顺序执行
/**
 主线程循序执行

 @param blocks 块集合
 */
+(void)performActionsInOrderOnMainThread:(NSArray <HGBThreadBlock>*)blocks{
    dispatch_queue_t queue=dispatch_get_main_queue();
    for(HGBThreadBlock block in blocks){
        dispatch_async(queue, ^{
            block();
        });
        dispatch_barrier_async(queue, ^{
            NSLog(@"barries");
        });
    }
}
/**
 全局程循序执行

 @param blocks 块集合
 */
+(void)performActionsInOrderOnGlobalThread:(NSArray <HGBThreadBlock>*)blocks{
    dispatch_queue_t queue=dispatch_get_global_queue(0, 0);
    for(HGBThreadBlock block in blocks){
        dispatch_async(queue, ^{
            block();
        });
        dispatch_barrier_async(queue, ^{
            NSLog(@"barries");
        });
    }
}
/**
 线程循序执行

 @param blocks 块集合
 @param thread 线程队列-为空时主线程
 */
+(void)performActionsInOrder:(NSArray <HGBThreadBlock>*)blocks OnThread:(dispatch_queue_t)thread{
    dispatch_queue_t queue=thread;
    if(queue==nil){
        queue=[HGBThreadTool getMainThread];
    }
    for(HGBThreadBlock block in blocks){
        dispatch_async(queue, ^{
            block();
        });
        dispatch_barrier_async(queue, ^{
            NSLog(@"barries");
        });
    }
}
#pragma mark 不常用
/**
 异步并发

 @param blocks 块集合
 @param threadFlag 队列标记
 */
+(void)performActionsConCurrentAsync:(NSArray <HGBThreadBlock>*)blocks onThreadWithThreadFlag:(NSString *)threadFlag{
    if(threadFlag==nil||threadFlag.length==0){
        threadFlag=@"queue";
    }
    dispatch_queue_t queue=dispatch_queue_create([threadFlag UTF8String], DISPATCH_QUEUE_CONCURRENT);
    for(HGBThreadBlock block in blocks){
        dispatch_async(queue, ^{
            block();
        });
    }
}
/**
 同步并发

 @param blocks 块集合
 @param threadFlag 队列标记
 */
+(void)performActionsConCurrentSync:(NSArray <HGBThreadBlock>*)blocks onThreadWithThreadFlag:(NSString *)threadFlag{
    if(threadFlag==nil||threadFlag.length==0){
        threadFlag=@"queue";
    }
    dispatch_queue_t queue=dispatch_queue_create([threadFlag UTF8String], DISPATCH_QUEUE_CONCURRENT);
    for(HGBThreadBlock block in blocks){
        dispatch_sync(queue, ^{
            block();
        });
    }
}
/**
 异步串行

 @param blocks 块集合
 @param threadFlag 队列标记
 */
+(void)performActionsSerialAsync:(NSArray <HGBThreadBlock>*)blocks onThreadWithThreadFlag:(NSString *)threadFlag{
    if(threadFlag==nil||threadFlag.length==0){
        threadFlag=@"queue";
    }
    dispatch_queue_t queue=dispatch_queue_create([threadFlag UTF8String], DISPATCH_QUEUE_SERIAL);
    for(HGBThreadBlock block in blocks){
        dispatch_async(queue, ^{
            block();
        });
    }
}
/**
 同步串行

 @param blocks 块集合
 @param threadFlag 队列标记
 */
+(void)performActionsSerialSync:(NSArray <HGBThreadBlock>*)blocks onThreadWithThreadFlag:(NSString *)threadFlag{
    if(threadFlag==nil||threadFlag.length==0){
        threadFlag=@"queue";
    }
    dispatch_queue_t queue=dispatch_queue_create([threadFlag UTF8String], DISPATCH_QUEUE_SERIAL);
    for(HGBThreadBlock block in blocks){
        dispatch_sync(queue, ^{
            block();
        });
    }
}
#pragma mark 获取线程
/**
 获取主线程

 @return 主线程
 */
+(dispatch_queue_t)getMainThread{
    return dispatch_get_main_queue();
}
/**
 获取全局线程

 @return 全局线程
 */
+(dispatch_queue_t)getGlobalThread{
    return dispatch_get_global_queue(0, 0);
}

/**
 获取新线程

 @param threadFlag 新线程标志
 @return 新线程
 */
+(dispatch_queue_t)getNewThreadWithThreadFlag:(NSString *)threadFlag{
    if(threadFlag==nil||threadFlag.length==0){
        threadFlag=@"queue";
    }
    dispatch_queue_t queue=dispatch_queue_create([threadFlag UTF8String], DISPATCH_QUEUE_SERIAL);
    return queue;
}
@end
