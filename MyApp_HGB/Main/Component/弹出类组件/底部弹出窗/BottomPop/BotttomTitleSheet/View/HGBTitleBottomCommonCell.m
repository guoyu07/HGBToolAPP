//
//  HGBTitleBottomCommonCell.m
//  CTTX
//
//  Created by huangguangbao on 17/1/4.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBTitleBottomCommonCell.h"
#import "HGBBottomPopHeader.h"

@implementation HGBTitleBottomCommonCell
#pragma mark init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self viewsetup];
    }
    return self;
}
#pragma mark view
-(void)viewsetup
{
    self.contentView.backgroundColor=[UIColor whiteColor];
    self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale,32*hScale,300*wScale,32*hScale)];
    self.titleLab.text=@"title";
    self.titleLab.textColor=[UIColor colorWithRed:166.0/256 green:166.0/256 blue:166.0/256 alpha:1];
    self.titleLab.font=[UIFont systemFontOfSize:32*hScale];
    
    self.titleLab.alpha=1;
    [self.contentView addSubview:self.titleLab];
    
    self.detailLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-450*wScale,10*hScale,420*wScale,76*hScale)];
    self.detailLab.text=@"subtitle";
    self.detailLab.textAlignment=NSTextAlignmentRight;
    self.detailLab.font=[UIFont systemFontOfSize:32*hScale];
    self.detailLab.textColor=[UIColor colorWithRed:51.0/256 green:51.0/256 blue:51.0/256 alpha:1];
    self.detailLab.alpha=1;
    [self.contentView addSubview:self.detailLab];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w=[HGBBottomPopTool widthForString:self.titleLab.text fontSize:32*hScale andheight:32*hScale];
    self.titleLab.frame=CGRectMake(30*wScale,32*hScale,w,32*hScale);
    self.detailLab.frame=CGRectMake(60*wScale+w,10*hScale,kWidth-90*wScale-w,76*hScale);
}

@end
