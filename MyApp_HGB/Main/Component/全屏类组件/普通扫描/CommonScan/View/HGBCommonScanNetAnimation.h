//
//  HGBCommonScanNetAnimation.h
//  CTTX
//
//  Created by huangguangbao on 17/1/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 扫描动画
 */
@interface HGBCommonScanNetAnimation : UIImageView
/**
 *  开始扫码网格效果
 *
 *  @param animationRect 显示在parentView中得区域
 *  @param parentView    动画显示在UIView
 *  @param image     扫码线的图像
 */
- (void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView*)parentView Image:(UIImage*)image andWithDirection:(NSInteger)direction;

/**
 *  停止动画
 */
- (void)stopAnimating;
@end
