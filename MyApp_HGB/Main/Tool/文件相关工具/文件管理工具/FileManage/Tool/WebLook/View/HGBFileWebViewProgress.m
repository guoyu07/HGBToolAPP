
//
//  HGBFileWebViewProgress.m
//  测试
//
//  Created by huangguangbao on 2017/8/17.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBFileWebViewProgress.h"
#import "HGBFileManageHeader.h"
@implementation HGBFileWebViewProgress

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.backgroundColor = lineColor;
}

-(void)startLoadingAnimation{
    self.hidden = NO;
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, 0.0, self.frame.size.height);

    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, kWidth * 0.6, self.frame.size.height);
    } completion:^(BOOL finished) {

        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, kWidth * 0.8, self.frame.size.height);
        }];
    }];


}

-(void)endLoadingAnimation{
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, kWidth, self.frame.size.height);
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}
@end
