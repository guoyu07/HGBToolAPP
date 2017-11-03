//
//  HGBPointShowMessageView.m
//  测试
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBPointShowMessageView.h"

#define FONT(x) [UIFont systemFontOfSize:x]


@implementation HGBPointShowMessageView

- (instancetype)initWithUserInfo:(HGBBrokenLineValue *)userInfo superView:(UIView *)superView {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        HGBBrokenLineValue *value = (HGBBrokenLineValue *)userInfo;

        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.text = [NSString stringWithFormat:@"  x:%.2f  \n  y:%.2f  ", value.x, value.y];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        self.messageLabel.font = FONT(9);
        self.messageLabel.textColor = [UIColor darkTextColor];
        [self.messageLabel sizeToFit];
        self.messageLabel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
        self.messageLabel.clipsToBounds = YES;
        self.messageLabel.layer.cornerRadius = 5;
        [self addSubview:self.messageLabel];

        [superView addSubview:self];

        self.alpha = 0;
        self.showMessage = NO;

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture {
    self.showMessage = !self.showMessage;
}

- (void)setShowPoint:(CGPoint)showPoint circleRadius:(CGFloat)circleRadius {

    CGSize labelSize = self.messageLabel.frame.size;
    labelSize.width += 10;
    labelSize.height += 10;
    CGFloat arrowHeight = 4;

    self.frame = CGRectMake(showPoint.x - labelSize.width / 2, showPoint.y - labelSize.height - arrowHeight - circleRadius, labelSize.width, labelSize.height + arrowHeight + circleRadius);
    self.messageLabel.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);

    [self setNeedsDisplay];
}

- (void)setShowMessage:(BOOL)showMessage {
    _showMessage = showMessage;
    if (_showMessage) {
        self.hidden = NO;
        [UIView animateWithDuration:0.2f animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {

        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

- (void)drawRect:(CGRect)rect {
    CGSize labelSize = self.messageLabel.frame.size;
    CGFloat arrowWidth = 3 * 2;
    CGFloat arrowHeight = 4;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, self.messageLabel.backgroundColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.messageLabel.backgroundColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapButt);

    CGContextMoveToPoint(context, labelSize.width / 2 - arrowWidth / 2, labelSize.height);
    CGContextAddLineToPoint(context, labelSize.width / 2, labelSize.height + arrowHeight);
    CGContextAddLineToPoint(context, labelSize.width / 2 + arrowWidth / 2, labelSize.height);
    CGContextAddLineToPoint(context, labelSize.width / 2 - arrowWidth / 2, labelSize.height);

    CGContextFillPath(context);
}

@end
