//
//  HGBBottomBaseTableViewCell.m
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBottomBaseTableViewCell.h"
#import "HGBBottomPopHeader.h"


@interface HGBBottomBaseTableViewCell()
/**
 短底部分割线
 */
@property(strong,nonatomic)UIImageView *line;//
/**
 顶部分割线
 */
@property(strong,nonatomic)UIImageView *topLine;//
/**
 底部分割线
 */
@property(strong,nonatomic)UIImageView *bottomLine;//
@end

@implementation HGBBottomBaseTableViewCell
#pragma mark init
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle=UITableViewCellSeparatorStyleNone;
        [self drawWithHeight:96*hScale];
    }
    return self;
}
#pragma mark 添加分割线
- (void)drawWithHeight:(float)height
{
    //上分割线
    self.topLine=[[UIImageView alloc]initWithFrame: CGRectMake(0,-0.5,kWidth,0.5)];
    self.topLine.backgroundColor=[UIColor lightGrayColor];
    self.topLine.hidden=YES;
    [self addSubview:self.topLine];

    //下分割线
    self.bottomLine=[[UIImageView alloc]initWithFrame: CGRectMake(0,height,kWidth,0.5)];
    self.bottomLine.backgroundColor=[UIColor lightGrayColor];
    self.bottomLine.hidden=YES;
    [self addSubview:self.bottomLine];

    //短分割线
    self.line=[[UIImageView alloc]initWithFrame: CGRectMake(30*wScale,height-0.5,kWidth-30*wScale,0.5)];
    self.line.backgroundColor=[UIColor lightGrayColor];

    self.line.hidden=NO;
    [self addSubview:self.line];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.topLine.frame=CGRectMake(0,-0.5,kWidth,0.5);
    self.bottomLine.frame=CGRectMake(0,CGRectGetMaxY(self.contentView.frame),kWidth,0.5);
    self.line.frame=CGRectMake(30*wScale,CGRectGetMaxY(self.contentView.frame)-0.5,kWidth-30*wScale,0.5);
}
#pragma mark 添加按钮
-(void)addBackButton{
    self.backButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.backButton.frame=self.frame;
    [self.backButton addTarget:self action:@selector(buttonActionHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.backButton addTarget:self action:@selector(buttonRemoveBlurredHandle:) forControlEvents:(UIControlEventTouchUpOutside)];
    [self.backButton addTarget:self action:@selector(buttonRemoveBlurredHandle:) forControlEvents:(UIControlEventTouchCancel)];
    [self.backButton addTarget:self action:@selector(buttonBlurredHandle:) forControlEvents:(UIControlEventTouchDown)];
    [self addSubview:self.backButton];

}

#pragma mark 按钮功能
-(void)buttonActionHandle:(UIButton *)_b{
    _b.backgroundColor=[UIColor clearColor];
    if(self.backGroundDelegate&&[self.backGroundDelegate respondsToSelector:@selector(bottomBaseCellBackGroundButtonActionWithIndexPath:)]){
        [self.backGroundDelegate bottomBaseCellBackGroundButtonActionWithIndexPath:self.indexPath];
    }
}
-(void)buttonBlurredHandle:(UIButton *)_b{
    _b.backgroundColor=[UIColor whiteColor];
    _b.alpha=0.387;
}
-(void)buttonRemoveBlurredHandle:(UIButton *)_b{
    _b.backgroundColor=[UIColor clearColor];
}
#pragma mark set
-(void)setBottomHiden:(BOOL)bottomHiden
{
    self.bottomLine.hidden=bottomHiden;
}
-(void)setTopHiden:(BOOL)topHiden
{
    self.topLine.hidden=topHiden;
}
-(void)setShortHiden:(BOOL)shortHiden
{
    self.line.hidden=shortHiden;
}
#pragma mark get
-(NSIndexPath *)indexPath{
    if(_indexPath==nil){
        _indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _indexPath;
}

@end
