//
//  HGBCollectionViewCell.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCollectionViewCell.h"
#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0



@implementation HGBCollectionViewCell
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
    self.imageV=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.25,0.1*self.frame.size.height, self.frame.size.width*0.5, self.frame.size.height*0.5)];
    [self addSubview:self.imageV];
    self.promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.1,0.7*self.frame.size.height, self.frame.size.width*0.8, self.frame.size.height*0.2)];
    self.promptLabel.backgroundColor=[UIColor whiteColor];
    self.promptLabel.font=[UIFont systemFontOfSize:self.frame.size.height*0.15];
    self.promptLabel.textAlignment=NSTextAlignmentCenter;
    self.promptLabel.textColor=[UIColor grayColor];
    [self addSubview:self.promptLabel];

    
}
-(void)layoutSubviews{
    self.imageV.frame=CGRectMake(self.frame.size.width*0.25,0.1*self.frame.size.height, self.frame.size.width*0.5, self.frame.size.height*0.5);
    self.promptLabel.frame=CGRectMake(self.frame.size.width*0.1,0.7*self.frame.size.height, self.frame.size.width*0.8, self.frame.size.height*0.2);
    self.promptLabel.font=[UIFont systemFontOfSize:self.frame.size.height*0.15];
}
@end
