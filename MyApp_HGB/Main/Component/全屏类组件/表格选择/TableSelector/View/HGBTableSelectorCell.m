//
//  HGBTableSelectorCell.m
//  CTTX
//
//  Created by huangguangbao on 16/11/21.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import "HGBTableSelectorCell.h"
#import "HGBaTableSelectorHeader.h"

@implementation HGBTableSelectorCell
#pragma mark init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self viewSetUp];
    }
    return self;
}
#pragma mark view
-(void)viewSetUp{
    self.contentView.backgroundColor=[UIColor whiteColor];
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30 * wScale, 0, kWidth-80*wScale, 53)];
    self.titleLab.backgroundColor = [UIColor clearColor];
    self.titleLab.textColor = [UIColor colorWithRed:51.0/256 green:51.0/256 blue:51.0/256 alpha:1];
    [self.contentView addSubview:self.titleLab];
    
    
    self.selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth - 30-24-5, 18.5, 16, 16)];
    self.selectImageView.image = [UIImage imageNamed:@"HGBTableSelectorBundle.bundle/select.png"];
    self.selectImageView.backgroundColor = [UIColor clearColor];
    self.selectImageView.hidden=YES;
    [self.contentView addSubview:self.selectImageView];
}
@end
