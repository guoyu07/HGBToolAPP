//
//  HGBFileTableCell.m
//  测试
//
//  Created by huangguangbao on 2017/8/15.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBFileTableCell.h"
#import "HGBFileManageHeader.h"

@interface HGBFileTableCell()
/**
 底层
 */
@property(strong,nonatomic)UIView *functionView;

/**
 顶层view
 */
@property(strong,nonatomic)UIButton *headView;
@end
@implementation HGBFileTableCell
#pragma mark init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self viewSetUp];
        [self drawWithHeight:120*hScale];
        self.bottomHiden=NO;
        self.topHiden=NO;
        self.shortHiden=YES;
    }
    return self;
}
-(void)viewSetUp
{
    self.backgroundColor=[UIColor whiteColor];
    self.iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(30*wScale,20*hScale,80*hScale,80*hScale)];
    [self.contentView addSubview:self.iconImageView];

    self.fileNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(45*wScale+80*hScale,25*hScale,kWidth-(105*wScale+80*hScale), 32*hScale)];
    self.fileNameLabel.text=@"文件名";

    self.fileNameLabel.font=[UIFont  systemFontOfSize:32*hScale];
    self.fileNameLabel.textColor=[UIColor blackColor];
    self.fileNameLabel.textAlignment=NSTextAlignmentLeft;
    [self addSubview:self.fileNameLabel];



    self.fileInfoLable=[[UILabel alloc]initWithFrame:CGRectMake(45*wScale+80*hScale,69*hScale,kWidth-(105*wScale+80*hScale), 24*hScale)];
    self.fileInfoLable.text=@"文件信息";

    self.fileInfoLable.font=[UIFont  systemFontOfSize:24*hScale];
    self.fileInfoLable.textColor=[UIColor blackColor];
    self.fileInfoLable.textAlignment=NSTextAlignmentLeft;
    [self addSubview:self.fileInfoLable];


    self.tapImageView=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-(35*wScale),40*hScale,20*wScale,40*hScale)];
    self.tapImageView.image=[UIImage imageNamed:@"HGBFileManageToolBundle.bundle/icon_next.png"];
    [self.contentView addSubview:self.tapImageView];


    self.headView=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.headView.frame=CGRectMake(0, 0, kWidth, 120*hScale);

//    [self.contentView addSubview:self.headView];

    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressHandler:)];
    //要求点击保持最短时间
    longPress.minimumPressDuration=1;
    [self.contentView addGestureRecognizer:longPress];
}
#pragma mark action
-(void)longPressHandler:(UILongPressGestureRecognizer *)_p{
    if(self.backGroundDelegate&&[self.backGroundDelegate respondsToSelector:@selector(fileBaseTableCellBackGroundButtonActionWithIndexPath:)]){
        [self.backGroundDelegate fileBaseTableCellBackGroundButtonActionWithIndexPath:self.indexPath];
    }
}
@end
