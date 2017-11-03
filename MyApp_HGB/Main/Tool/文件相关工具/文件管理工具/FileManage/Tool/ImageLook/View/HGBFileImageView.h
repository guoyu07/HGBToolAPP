//
//  HGBFileImageView.h
//  测试
//
//  Created by huangguangbao on 2017/8/17.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 类型
 */
typedef enum HGBFileImageViewType
{
    HGBFileImageViewTypeNO,//基础
    HGBFileImageViewTypeNOLimit,//无限制
    HGBFileImageViewTypeOnlyTool,//功能栏
    HGBFileImageViewTypeOnlyAction,//只有点击事件
    HGBFileImageViewTypeOnlyCopyTool,//只能复制


}HGBFileImageViewType;

@interface HGBFileImageView : UIImageView
/**
 类型
 */
@property(assign,nonatomic)HGBFileImageViewType type;

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
