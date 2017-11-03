//
//  HTableViewCell.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HTableViewCell.h"

@implementation HTableViewCell
-(void)viewSetUp{
    self.label=[[UILabel alloc]initWithFrame:self.frame];
    self.label.backgroundColor=[UIColor lightGrayColor];
    self.label.textColor=[UIColor blueColor];
    self.label.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.label];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.label.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
@end
