//
//  HGBFileOutAppOpenFileTool.h
//  测试
//
//  Created by huangguangbao on 2017/8/16.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^CompleteBlock)(NSInteger status);

@interface HGBFileOutAppOpenFileTool : NSObject
/**
 使用外部app打开文件

 @param url 路径
 @param parent 父控制器
 @param completeBlock 结果 0失败 1成功 2取消
 */
+(void)openFileWithExetenAppWithUrl:(NSString *)url inParent:(UIViewController *)parent andWithCompleteBlock:(CompleteBlock )completeBlock;

/**
 使用外部app打开文件

 @param path 路径
 @param parent 父控制器
 @param completeBlock 结果 0失败 1成功 2取消
 */
+(void)openFileWithExetenAppWithPath:(NSString *)path inParent:(UIViewController *)parent andWithCompleteBlock:(CompleteBlock )completeBlock;
@end
