//
//  HGBImageView.h
//  测试
//
//  Created by huangguangbao on 2017/7/15.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 类型
 */
typedef enum HGBImageViewType
{
    HGBImageViewTypeNO,//基础
    HGBImageViewTypeNOLimit,//无限制
    HGBImageViewTypeOnlyTool,//功能栏
    HGBImageViewTypeOnlyAction,//只有点击事件
    HGBImageViewTypeOnlyCopyTool,//只能复制
    
    
}HGBImageViewType;

@interface HGBImageView : UIImageView
/**
 类型
 */
@property(assign,nonatomic)HGBImageViewType type;

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
