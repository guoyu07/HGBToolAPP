//
//  HGBEndPointButton.h
//  测试
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBBrokenLineValue.h"
#import "HGBPointShowMessageView.h"

@class HGBEndPointButton;

/// 折线端点点击协议
@protocol HGBEndPointButtonDelegate <NSObject>

- (void)endPointButtonDidClicked:(HGBEndPointButton *)button;

@end



/// 折线端点
@interface HGBEndPointButton : UIButton

@property (nonatomic, weak)   id delegate;
@property (nonatomic, strong) id userInfo;

@property (nonatomic, strong) HGBPointShowMessageView *message;

@property (nonatomic, strong) UIColor *circleColor;

+ (HGBEndPointButton *)defaultRadius:(CGFloat)radius center:(CGPoint)center userInfo:(id)userInfo delegate:(id)delegate;

@end

