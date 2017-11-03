//
//  HGBTitleCell.m
//  CTTX
//
//  Created by huangguangbao on 2017/4/25.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBTitleCell.h"

@implementation HGBTitleCell
#pragma mark init
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self viewSetup];
    }
    return self;
}
#pragma mark view
-(void)viewSetup
{
    self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale,17.7, kWidth-90*wScale, 17.7)];
    self.titleLab.text=@"title";
    self.titleLab.font=[UIFont  systemFontOfSize:17.7];
    self.titleLab.textColor=[UIColor blackColor];
    [self.contentView addSubview:self.titleLab];
}
@end
