//
//  HGBNumberScrollAnimatedView.h
//  测试
//
//  Created by huangguangbao on 2017/6/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 滚动数字
 */
@interface HGBNumberScrollAnimatedView : UIView
// 内容相关
@property (nonatomic, strong) NSNumber *number;
// 样式相关
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSUInteger density;               // 滚动数字的密度
@property (nonatomic, assign) NSUInteger minLength;             // 最小显示长度，不够补零
// 动画相关
@property (nonatomic, assign) NSTimeInterval duration;          // 动画总持续时间
@property (nonatomic, assign) NSTimeInterval durationOffset;    // 相邻两个数字动画持续时间间隔
@property (nonatomic, assign) BOOL isAscending;                 // 方向，默认为NO，向下

- (void)reloadView;
- (void)startAnimation;
- (void)stopAnimation;

@end
