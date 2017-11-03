//
//  HGBCommonCameraController.h
//  CTTX
//
//  Created by huangguangbao on 2017/3/20.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBCommonCameraStyle.h"




/**
 错误类型
 */
typedef enum HGBCommonCameraErrorType
{
    HGBCommonCameraErrorTypeDevice,//设备受限
    HGBCommonCameraErrorTypeAuthority//权限受限

}HGBCommonCameraErrorType;


@class HGBCommonCameraController;
/**
 拍照
 */
@protocol HGBCommonCameraControllerDelegate <NSObject>
/**
 拍照结果返回

 @param commonImage 图片
 @param commonCamera 实例
 */
-(void)commonCamera:(HGBCommonCameraController *)commonCamera didFinishWithImage:(UIImage *)commonImage;

@optional
/**
 拍照
 @param commonCamera 实例
 */
-(void)commonCameraDidTakePhoto:(HGBCommonCameraController *)commonCamera;
/**
 取消拍照
 
 @param commonCamera 实例
 */
-(void)commonCameraDidCanceled:(HGBCommonCameraController *)commonCamera;
/**
 重新拍照
 @param commonCamera 实例
 */
-(void)commonCameraDidRetake:(HGBCommonCameraController *)commonCamera;
/**
 拍照失败

 @param commonCamera 实例
 @param errorInfo 错误
 */
-(void)commonCamera:(HGBCommonCameraController *)commonCamera didFailedWithError:(NSDictionary *)errorInfo;
@end

@interface HGBCommonCameraController : UIViewController
@property(strong,nonatomic)id<HGBCommonCameraControllerDelegate>delegate;
/**
 拍照类型
 */
@property(strong,nonatomic)HGBCommonCameraStyle *style;
/**
 添加提示图

 @param promptView 提示图
 */
-(void)addPromtView:(UIView *)promptView;
/**
 移除提示图
 */
-(void)removePromptView;
@end
