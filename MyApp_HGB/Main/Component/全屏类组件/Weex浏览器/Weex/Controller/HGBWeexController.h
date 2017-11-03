//
//  HGBWeexController.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 按钮拖动类型
 */
typedef enum HGBWeexCloseButtonDragType
{
    HGBWeexCloseButtonDragTypeNO,//无拖拽
    HGBWeexCloseButtonDragTypeNOLimit,//无限制
    HGBWeexCloseButtonDragTypeBorder//贴边

}HGBWeexCloseButtonDragType;

/**
 按钮初始位置
 */
typedef enum HGBWeexCloseButtonPositionType
{
    HGBWeexCloseButtonPositionTypeTopLeft,//左上角
    HGBWeexCloseButtonPositionTypeTopRight,//右上角
    HGBWeexCloseButtonPositionTypeBottomLeft,//左下角
    HGBWeexCloseButtonPositionTypeBottomRight//右下角

}HGBWeexCloseButtonPositionType;
@interface HGBWeexController : UIViewController
@property(strong,nonatomic)NSString *url;


/**
 是否显示返回按钮
 */
@property(assign,nonatomic)BOOL isShowReturnButton;
/**
 返回按钮拖拽类型
 */
@property(assign,nonatomic)HGBWeexCloseButtonDragType   returnButtonDragType;

/**
 返回按钮初始位置
 */
@property(assign,nonatomic)HGBWeexCloseButtonPositionType returnButtonPositionType;
@end

