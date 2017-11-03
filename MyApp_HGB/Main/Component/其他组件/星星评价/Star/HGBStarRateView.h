//
//  HGBStarRateView.h
//  CTTX
//
//  Created by huangguangbao on 16/9/23.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 星星评级代理
 */

@class HGBStarRateView;
/**
 星星评级代理
 */
@protocol HGBStarRateViewDelegate <NSObject>
@optional
/**
 变化
 */
- (void)starRateView:(HGBStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent;
@end


/**
 星星评级
 */
@interface HGBStarRateView : UIView

/**
 得分值，范围为0--1，默认为1
 */
@property (nonatomic, assign) CGFloat scorePercent;
/**
 选中星星图片
 */
@property(strong,nonatomic)UIImage *selectStarImage;
/**
 普通星星图片
 */
@property(strong,nonatomic)UIImage *normalStarImage;
/**
 是否允许动画，默认为NO
 */
@property (nonatomic, assign) BOOL hasAnimation;
/**
 评分时是否允许不是整星，默认为NO
 */
@property (nonatomic, assign) BOOL allowScrapStar;

/**
 是否允许选择
 */
@property (nonatomic, assign) BOOL allowSelector;

@property (nonatomic, weak) id<HGBStarRateViewDelegate>delegate;

/**
 初始化
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars;


@end
