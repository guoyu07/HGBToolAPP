
//
//  HGBCalenderWeekView.m
//  测试
//
//  Created by huangguangbao on 2017/10/19.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCalenderWeekView.h"

@implementation HGBCalenderWeekView
#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewSetUp];
    }
    return self;
}
#pragma mark view
-(void)viewSetUp{
    self.backgroundColor=[UIColor whiteColor];
    self.weekLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, @(self.frame.size.width).stringValue.integerValue, @(self.frame.size.height).stringValue.integerValue)];
    self.weekLabel.backgroundColor=[UIColor clearColor];
    self.weekLabel.font=[UIFont systemFontOfSize:@(self.frame.size.height*0.7).stringValue.integerValue];
    self.weekLabel.textAlignment=NSTextAlignmentCenter;
    self.weekLabel.textColor=[UIColor grayColor];
    [self addSubview:self.weekLabel];

    self.backButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.backButton.frame=CGRectMake(0, 0, @(self.frame.size.width).stringValue.integerValue, @(self.frame.size.height).stringValue.integerValue);
    [self addSubview:self.backButton];
}
-(void)layoutSubviews{
    self.weekLabel.frame=CGRectMake(0, 0, @(self.frame.size.width).stringValue.integerValue, @(self.frame.size.height).stringValue.integerValue);
    self.weekLabel.font=[UIFont systemFontOfSize:@(self.frame.size.height*0.4).stringValue.integerValue];
    self.backButton.frame=CGRectMake(0, 0, @(self.frame.size.width).stringValue.integerValue, @(self.frame.size.height).stringValue.integerValue);
}

@end
