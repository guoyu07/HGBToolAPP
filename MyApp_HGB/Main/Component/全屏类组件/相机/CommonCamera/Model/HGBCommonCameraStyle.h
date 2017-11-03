//
//  HGBCommonCameraStyle.h
//  CTTX
//
//  Created by huangguangbao on 2017/3/21.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 拍照样式
 */
@interface HGBCommonCameraStyle : NSObject
/**
 是否编辑
 */
@property(assign,nonatomic)BOOL isEdit;
/**
 @brief  是否需要绘制扫码矩形框，默认YES
 */
//@property (nonatomic, assign) BOOL isNeedShowRetangle;


/**
 图片编辑区域
 */
@property(assign,nonatomic)CGSize cropSize;

/**
 图片
 */
@property(strong,nonatomic)UIColor *cropRectColor;
@end
