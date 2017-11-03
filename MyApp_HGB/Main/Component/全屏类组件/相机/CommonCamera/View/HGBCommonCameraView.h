//
//  HGBCommonCameraView.h
//  CTTX
//
//  Created by huangguangbao on 2017/3/20.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBCommonCameraStyle.h"


/**
 拍照
 */
@protocol HGBCommonCameraViewDelegate <NSObject>
/**
 返回扫描到的图片
 
 @param idx 标示
 */
-(void)commonCameraViewButtonDidClickWithIndex:(NSInteger)idx;
@end
@interface HGBCommonCameraView : UIView
@property(strong,nonatomic)id<HGBCommonCameraViewDelegate>delegate;
/**
 样式
 */
@property(strong,nonatomic)HGBCommonCameraStyle *style;
/**
 显示view
 */
@property(strong,nonatomic)UIView *showView;
/**
 编辑view
 */
@property(strong,nonatomic)UIView *editView;
/**
 选择区域view
 */
@property(strong,nonatomic)UIView *editCropView;

/**
 编辑图片view
 */
@property(strong,nonatomic)UIImageView *editImageView;
/**
 原始图片
 */
@property(strong,nonatomic)UIImage *origeImage;

/**
 重拍
 */
-(void)retakePhoto;
/**
 拍照
 */
-(void)takePhotoSucess;
@end
