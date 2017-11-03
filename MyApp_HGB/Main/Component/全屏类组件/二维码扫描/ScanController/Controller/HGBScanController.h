//
//  HGBScanController.h
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/8.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBScanViewStyle.h"
#import "HGBScanView.h"

#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AudioToolbox/AudioToolbox.h>

/**
 错误类型
 */
typedef enum HGBScanErrorType
{
    HGBScanErrorTypeAuthority//权限受限

}HGBScanErrorType;

@class HGBScanController;
/**
 扫描条形码二维码
 */
@protocol HGBScanControllerDelegate <NSObject>
/**
 返回扫描到的结果
 
 @param result 扫描二维码结果返回
 */
-(void)scan:(HGBScanController *)scan didFinishWithResult:(NSString *)result;
@optional
/**
 取消扫描
 */
-(void)scanDidCanceled:(HGBScanController *)scan;
/**
 扫描失败
 */
-(void)scan:(HGBScanController *)scan didFailedWithError:(NSDictionary *)errorInfo;
@end


@interface HGBScanController : UIViewController
@property(strong,nonatomic)id<HGBScanControllerDelegate>delegate;
/**
 @brief 是否需要扫码图像
 */
@property (nonatomic, assign) BOOL isNeedScanImage;
#pragma mark - 扫码界面效果及提示等
/**
 @brief  扫码区域视图,二维码一般都是框
 */
@property (nonatomic,strong)HGBScanView* scanView;
/**
 *  界面效果参数
 */
@property (nonatomic, strong) HGBScanViewStyle *style;



#pragma mark - 扫码界面效果及提示等
/**
 开始扫描
 */
-(void)startScan;
/**
 停止扫描
 */
-(void)stopScan;
@end
