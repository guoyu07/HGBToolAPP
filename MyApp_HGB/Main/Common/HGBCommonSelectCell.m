//
//  HGBCommonSelectCell.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCommonSelectCell.h"

@implementation HGBCommonSelectCell
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
    self.title=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale,0,kWidth-60*wScale,61.8)];
    self.title.text=@"标题";
    self.title.textAlignment=NSTextAlignmentLeft;
    self.title.backgroundColor=[UIColor whiteColor];
    self.title.font=[UIFont systemFontOfSize:17.7];
    self.title.textColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    [self.contentView addSubview:self.title];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.title.frame=CGRectMake(30*wScale,0,kWidth-60*wScale,self.contentView.frame.size.height);
}
@end
