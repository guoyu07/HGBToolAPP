//
//  HGBEndPointButton.m
//  测试
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBEndPointButton.h"


@interface HGBEndPointButton ()

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint pointCenter;

@end

@implementation HGBEndPointButton

+ (HGBEndPointButton *)defaultRadius:(CGFloat)radius center:(CGPoint)center userInfo:(id)userInfo delegate:(id)delegate {
    HGBEndPointButton *button = [HGBEndPointButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, radius * 6, radius * 6);
    button.center = center;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:button action:@selector(buttonHandle:) forControlEvents:UIControlEventTouchUpInside];
    button.userInfo = userInfo;
    button.delegate = delegate;
    button.radius = radius;
    [button setNeedsDisplay];

    button.message = [[HGBPointShowMessageView alloc] initWithUserInfo:userInfo superView:delegate];
    [button.message setShowPoint:center circleRadius:radius];
    return button;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.radius);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextSetStrokeColorWithColor(context, self.circleColor.CGColor);

    CGContextAddArc(context, self.pointCenter.x, self.pointCenter.y, self.radius / 2, 0, M_PI * 2, NO);
    CGContextStrokePath(context);
}

- (void)buttonHandle:(HGBEndPointButton *)button {

    button.message.showMessage = !button.message.showMessage;

    if ([button.delegate respondsToSelector:@selector(endPointButtonDidClicked:)]) {
        [button.delegate endPointButtonDidClicked:button];
    }
}

- (UIColor *)circleColor {
    return _circleColor ? _circleColor : [UIColor redColor];
}

- (CGPoint)pointCenter {
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    return center;
}

@end

