//
//  HGBCommonScanViewStyle.h
//  
//
//  Created by huangguangbao on 17/1/9.
//
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 扫码区域动画效果
 */
typedef enum HGBCommonScanViewAnimationStyle
{
    HGBCommonScanViewAnimationStyle_LineMove,   //线条上下移动
    HGBCommonScanViewAnimationStyle_NetGrid,//网格
    HGBCommonScanViewAnimationStyle_LineStill,//线条停止在扫码区域中央
    HGBCommonScanViewAnimationStyle_None    //无动画
    
}HGBCommonScanViewAnimationStyle;


/**
 扫码区域4个角位置类型
 */
typedef enum HGBCommonScanViewPhotoframeAngleStyle
{
    HGBCommonScanViewPhotoframeAngleStyle_Inner,//内嵌，一般不显示矩形框情况下
    HGBCommonScanViewPhotoframeAngleStyle_Outer,//外嵌,包围在矩形框的4个角
    HGBCommonScanViewPhotoframeAngleStyle_On   //在矩形框的4个角上，覆盖
}HGBCommonScanViewPhotoframeAngleStyle;


/**
 扫描样式
 */
@interface HGBCommonScanViewStyle : NSObject
#pragma mark -中心位置矩形框
/**
 @brief  是否需要绘制扫码矩形框，默认YES
 */
@property (nonatomic, assign) BOOL isNeedShowRetangle;


/**
 *  默认扫码区域为正方形，如果扫码区域不是正方形，设置宽高比
 */
@property (nonatomic, assign) CGFloat whRatio;


/**
 @brief  矩形框(视频显示透明区)域向上移动偏移量，0表示扫码透明区域在当前视图中心位置，如果负值表示扫码区域下移
 */
@property (nonatomic, assign) CGFloat centerUpOffset;

/**
 *  矩形框(视频显示透明区)域离界面左边及右边距离，默认60
 */
@property (nonatomic, assign) CGFloat xScanRetangleOffset;

/**
 @brief  矩形框线条颜色
 */
@property (nonatomic, strong) UIColor *colorRetangleLine;



#pragma mark -矩形框(扫码区域)周围4个角
/**
 @brief  扫码区域的4个角类型
 */
@property (nonatomic, assign) HGBCommonScanViewPhotoframeAngleStyle photoframeAngleStyle;
//扫码方向
@property (nonatomic, assign) BOOL HorizontalScan;

//4个角的颜色
@property (nonatomic, strong) UIColor* colorAngle;

//扫码区域4个角的宽度和高度
@property (nonatomic, assign) CGFloat photoframeAngleW;
@property (nonatomic, assign) CGFloat photoframeAngleH;
/**
 @brief  扫码区域4个角的线条宽度,默认6，建议8到4之间
 */
@property (nonatomic, assign) CGFloat photoframeLineW;


#pragma mark --动画效果
/**
 @brief  扫码动画效果:线条或网格
 */
@property (nonatomic, assign) HGBCommonScanViewAnimationStyle anmiationStyle;

/**
 *  动画效果的图像，如线条或网格的图像
 */
@property (nonatomic,strong) UIImage *animationImage;
/**
 *  提醒图片
 */

@property (nonatomic,strong) UIImage *promptImage;
#pragma mark -非识别区域颜色,默认 RGBA (0,0,0,0.5)，范围（0--1）
@property (nonatomic, assign) CGFloat red_notRecoginitonArea;
@property (nonatomic, assign) CGFloat green_notRecoginitonArea;
@property (nonatomic, assign) CGFloat blue_notRecoginitonArea;
@property (nonatomic, assign) CGFloat alpa_notRecoginitonArea;

@end
