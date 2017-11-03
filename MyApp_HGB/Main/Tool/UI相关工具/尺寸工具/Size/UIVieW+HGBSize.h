//
//  UIVieW+HGBSize.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/29.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIView (HGBSize)

/**
 左
 */
@property (nonatomic) CGFloat left;
/**
 上
 */
@property (nonatomic) CGFloat top;
/**
 右
 */
@property (nonatomic) CGFloat right;
/**
 下
 */
@property (nonatomic) CGFloat bottom;
/**
 中心x
 */
@property (nonatomic) CGFloat centerX;
/**
 中心y
 */
@property (nonatomic) CGFloat centerY;

/**
 宽
 */
@property (nonatomic) CGFloat width;
/**
 高
 */
@property (nonatomic) CGFloat height;


/**
 起始位置
 */
@property (nonatomic) CGPoint origin;
/**
 大小
 */
@property (nonatomic) CGSize size;
@end
