//
//  HGBPointShowMessageView.h
//  测试
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBBrokenLineValue.h"

/// 提示内容
@interface HGBPointShowMessageView : UIView

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, assign) BOOL showMessage;

- (instancetype)initWithUserInfo:(HGBBrokenLineValue *)userInfo superView:(UIView *)superView;

- (void)setShowPoint:(CGPoint)showPoint circleRadius:(CGFloat)circleRadius;

@end
