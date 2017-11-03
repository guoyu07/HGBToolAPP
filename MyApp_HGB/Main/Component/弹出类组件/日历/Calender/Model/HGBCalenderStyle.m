//
//  HGBCalenderStyle.m
//  测试
//
//  Created by huangguangbao on 2017/10/18.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCalenderStyle.h"

@implementation HGBCalenderStyle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.calenderType=HGBCalenderTypeGregorian;
        self.isWeekHead=YES;
        self.isShowPrompt=YES;

        self.titleStyle=HGBCalenderTitleStyleTrans;
        self.titleColor=[UIColor blackColor];
        self.titleBackColor=[UIColor whiteColor];
        self.yearColor=[UIColor blackColor];
        self.monthColor=[UIColor blackColor];
        self.yearBackColor=[UIColor whiteColor];
        self.monthBackColor=[UIColor whiteColor];
        
        self.leftImage=[UIImage imageNamed:@"HGBCalenderBundle.bundle/left.png"];
         self.rightImage=[UIImage imageNamed:@"HGBCalenderBundle.bundle/right.png"];


        self.isShowOver=YES;
        self.overColor=[UIColor lightGrayColor];
        self.overBackColor=[UIColor whiteColor];


        self.dayTitleBordorColor=[UIColor clearColor];
        self.dayTitleColor=[UIColor blackColor];
        self.weekDayTitleColor=[UIColor orangeColor];
        self.dayTitleBackColor=[UIColor whiteColor];
        self.weekDayTitleBackColor=[UIColor whiteColor];

        self.dayBordorColor=[UIColor clearColor];
        self.normalDayBackColor=[UIColor whiteColor];
        self.normalDayColor=[UIColor darkGrayColor];
        self.selectDayColor=[UIColor whiteColor];
        self.selectBackColor=[UIColor blueColor];
        self.weekDayColor=[UIColor orangeColor];
        self.weekDayBackColor=[UIColor whiteColor];
        self.normalPromptTextColor=[UIColor lightGrayColor];
        self.selectPromptTextColor=[UIColor whiteColor];
        self.currnetDayColor=[UIColor redColor];
       self.currnetBackColor=[UIColor greenColor];
        self.currnetPromptTextColor=[UIColor redColor];



    }
    return self;
}

@end
