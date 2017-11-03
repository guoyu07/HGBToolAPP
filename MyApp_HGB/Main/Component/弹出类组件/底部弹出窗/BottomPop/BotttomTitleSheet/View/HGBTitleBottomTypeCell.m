//
//  HGBTitleBottomTypeCell.m
//  CTTX
//
//  Created by huangguangbao on 17/1/4.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBTitleBottomTypeCell.h"
#import "HGBBottomPopHeader.h"
@implementation HGBTitleBottomTypeCell
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
    
    self.detailLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-44*hScale-450*wScale,32*hScale,420*wScale,32*hScale)];
    self.detailLab.text=@"subtitle";
    self.detailLab.textAlignment=NSTextAlignmentRight;
    self.detailLab.font=[UIFont systemFontOfSize:32*hScale];
    self.detailLab.textColor=[UIColor colorWithRed:51.0/256 green:51.0/256 blue:51.0/256 alpha:1];
    self.detailLab.alpha=1;
    
    [self.contentView addSubview:self.detailLab];
    
    UIImageView *tapImgV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-44*wScale,36*hScale,15*wScale,24*hScale)];
    self.tapImgV=tapImgV;
    tapImgV.alpha=1;
    tapImgV.image=[UIImage imageNamed:@"HGBBottomPopBundle.bundle/icon_arrow_select.png"];
    [self.contentView addSubview:tapImgV];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w=[HGBBottomPopTool widthForString:self.titleLab.text fontSize:32*hScale andheight:32*hScale];
    self.titleLab.frame=CGRectMake(30*wScale,32*hScale,w,32*hScale);
    self.detailLab.frame=CGRectMake(60*wScale+w,10*hScale,kWidth-90*wScale-w-54*wScale,76*hScale);
    
    
//    CGFloat width=[ widthForString:self.titleLab.text fontSize:32*hScale andheight:32*hScale];
//    self.backButton.frame=CGRectMake(width+30*wScale,0,kWidth-width-30*wScale,self.contentView.frame.size.height);
}

@end
