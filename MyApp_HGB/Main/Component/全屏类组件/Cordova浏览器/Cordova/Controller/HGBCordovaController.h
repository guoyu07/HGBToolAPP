//
//  HGBCordovaController.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Cordova/CDVViewController.h>
#import <Cordova/CDVCommandDelegateImpl.h>
#import <Cordova/CDVCommandQueue.h>


/**
 按钮拖动类型
 */
typedef enum HGBCordovaCloseButtonDragType
{
    HGBCordovaCloseButtonDragTypeNO,//无拖拽
    HGBCordovaCloseButtonDragTypeNOLimit,//无限制
    HGBCordovaCloseButtonDragTypeBorder//贴边

}HGBCordovaCloseButtonDragType;

/**
 按钮初始位置
 */
typedef enum HGBCordovaCloseButtonPositionType
{
    HGBCordovaCloseButtonPositionTypeTopLeft,//左上角
    HGBCordovaCloseButtonPositionTypeTopRight,//右上角
    HGBCordovaCloseButtonPositionTypeBottomLeft,//左下角
    HGBCordovaCloseButtonPositionTypeBottomRight//右下角

}HGBCordovaCloseButtonPositionType;


@interface HGBCordovaController : CDVViewController
/**
 是否显示返回按钮
 */
@property(assign,nonatomic)BOOL isShowReturnButton;
/**
 返回按钮拖拽类型
 */
@property(assign,nonatomic)HGBCordovaCloseButtonDragType   returnButtonDragType;

/**
 返回按钮初始位置
 */
@property(assign,nonatomic)HGBCordovaCloseButtonPositionType returnButtonPositionType;

@end

@interface HGBCordovaCommandDelegate : CDVCommandDelegateImpl
@end

@interface HGBCordovaCommandQueue : CDVCommandQueue
@end

