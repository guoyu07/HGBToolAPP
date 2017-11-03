//
//  HGBBadgeButton.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/27.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBadgeButton.h"

@implementation HGBBadgeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        [self setBackgroundImage:[UIImage imageNamed:@"HGBTabBar.bundle/main_badge"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    //    _badgeValue = badgeValue;
    _badgeValue = [badgeValue copy];

    if (badgeValue) {
        self.hidden = NO;
        // 设置文字
        [self setTitle:badgeValue forState:UIControlStateNormal];

        // 设置frame
        CGRect frame = self.frame;
        CGFloat badgeH = self.currentBackgroundImage.size.height;
        CGFloat badgeW = self.currentBackgroundImage.size.width;
        if (badgeValue.length > 1) {
            // 文字的尺寸
            NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:badgeValue attributes:@ {NSFontAttributeName: self.titleLabel.font}];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.titleLabel.frame.size.width, CGFLOAT_MAX}options:NSStringDrawingUsesLineFragmentOrigin context:nil];
             CGSize badgeSize = rect.size;
            
//             [badgeValue sizeWithFont:self.titleLabel.font];
            badgeW = badgeSize.width + 10;
        }
        frame.size.width = badgeW;
        frame.size.height = badgeH;
        self.frame = frame;
    } else {
        self.hidden = YES;
    }
}
@end
