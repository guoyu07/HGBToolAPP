//
//  HGBMapBottomCell.m
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBMapBottomCell.h"
#import "HGBMapBottomPopHeader.h"


@implementation HGBMapBottomCell
#pragma mark init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_ViewSetUp];
    }
    return self;
}
#pragma mark view
-(void)p_ViewSetUp
{
    self.contentView.backgroundColor=[UIColor whiteColor];
    self.alpha=1;
    self.title=[[UILabel alloc]initWithFrame:CGRectMake(0*wScale,0,kWidth-0*wScale,61.8)];
    self.title.text=@"标题";
    self.title.textAlignment=NSTextAlignmentCenter;
    self.title.textColor=[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1];
    self.title.backgroundColor=[UIColor whiteColor];
    self.title.font=[UIFont systemFontOfSize:17.7];
    [self.contentView addSubview:self.title];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.title.frame=CGRectMake(0*wScale,0,kWidth-0*wScale,self.contentView.frame.size.height);
}
@end
