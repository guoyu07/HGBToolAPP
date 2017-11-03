

//
//  HGBCalenderDayView.m
//  测试
//
//  Created by huangguangbao on 2017/10/19.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCalenderDayView.h"

@implementation HGBCalenderDayView
#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewSetUp];
    }
    return self;
}
-(void)viewSetUp{
    self.backgroundColor=[UIColor whiteColor];
    self.dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, @(self.frame.size.width).stringValue.integerValue,@(self.frame.size.height*0.6).stringValue.integerValue)];
    self.dayLabel.backgroundColor=[UIColor clearColor];
    self.dayLabel.font=[UIFont systemFontOfSize:@(self.frame.size.height*0.7).stringValue.integerValue];
    self.dayLabel.textAlignment=NSTextAlignmentCenter;
    self.dayLabel.textColor=[UIColor grayColor];
    [self addSubview:self.dayLabel];

    self.promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,@(self.frame.size.height*0.6).stringValue.integerValue, @(self.frame.size.width).stringValue.integerValue, @(self.frame.size.height*0.4).stringValue.integerValue)];
    self.promptLabel.backgroundColor=[UIColor clearColor];
    self.promptLabel.font=[UIFont systemFontOfSize:@(self.frame.size.height*0.2).stringValue.integerValue];
    self.promptLabel.textAlignment=NSTextAlignmentCenter;
    self.promptLabel.textColor=[UIColor grayColor];
    [self addSubview:self.promptLabel];




    self.backButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.backButton.frame=CGRectMake(0, 0, @(self.frame.size.width).stringValue.integerValue, @(self.frame.size.height).stringValue.integerValue);
    [self addSubview:self.backButton];
};
-(void)layoutSubviews{
    if(self.promptLabel.hidden){
         self.dayLabel.frame=CGRectMake(0, 0, @(self.frame.size.width).stringValue.integerValue, @(self.frame.size.height).stringValue.integerValue);
        self.dayLabel.font=[UIFont systemFontOfSize:@(self.frame.size.height*0.6).stringValue.integerValue];
    }else{
        self.dayLabel.frame=CGRectMake(0, 0, @(self.frame.size.width).stringValue.integerValue, @(self.frame.size.height*0.6).stringValue.integerValue);
        self.promptLabel.frame=CGRectMake(0,@(self.frame.size.height*0.6).stringValue.integerValue,@(self.frame.size.width).stringValue.integerValue, @(self.frame.size.height*0.4).stringValue.integerValue);

        self.dayLabel.font=[UIFont systemFontOfSize:@(self.frame.size.height*0.4).stringValue.integerValue];
        self.promptLabel.font=[UIFont systemFontOfSize:@(self.frame.size.height*0.2).stringValue.integerValue];
    }
     self.backButton.frame=CGRectMake(0, 0, @(self.frame.size.width).stringValue.integerValue, @(self.frame.size.height).stringValue.integerValue);
}

@end
