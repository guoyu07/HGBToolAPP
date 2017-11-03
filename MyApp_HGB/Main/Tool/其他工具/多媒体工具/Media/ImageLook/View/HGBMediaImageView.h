//
//  HGBMediaImageView.h
//  测试
//
//  Created by huangguangbao on 2017/8/23.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 类型
 */
typedef enum HGBMediaImageViewType
{
    HGBMediaImageViewTypeNO,//基础
    HGBMediaImageViewTypeNOLimit,//无限制
    HGBMediaImageViewTypeOnlyTool,//功能栏
    HGBMediaImageViewTypeOnlyAction,//只有点击事件
    HGBMediaImageViewTypeOnlyCopyTool,//只能复制


}HGBMediaImageViewType;

@interface HGBMediaImageView : UIImageView
/**
 类型
 */
@property(assign,nonatomic)HGBMediaImageViewType type;

/**
 复制字符串标题
 */
@property(strong,nonatomic)NSString *codeTitle;
/**
 复制字符串
 */
@property(strong,nonatomic)NSString *codeString;

/**
 事件

 @param target 目标
 @param action 事件
 */
-(void)addTarget:(id)target action:(SEL)action;
@end
