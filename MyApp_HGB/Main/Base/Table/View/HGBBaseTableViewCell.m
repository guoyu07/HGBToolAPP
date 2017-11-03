//
//  HGBBaseTableViewCell.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBaseTableViewCell.h"


#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0


@interface HGBBaseTableViewCell()
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

@implementation HGBBaseTableViewCell
#pragma mark init
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self viewSetUp];
        self.selectionStyle=UITableViewCellSeparatorStyleNone;
        [self drawLine];
    }
    return self;
}
#pragma mark view
-(void)viewSetUp{

}
#pragma mark 添加分割线
- (void)drawLine
{
    //上分割线
    self.topLine=[[UIImageView alloc]initWithFrame: CGRectMake(0,-0.5,self.frame.size.width,0.5)];
    self.topLine.backgroundColor=[UIColor lightGrayColor];
    self.topLine.hidden=YES;
    [self addSubview:self.topLine];

    //下分割线
    self.bottomLine=[[UIImageView alloc]initWithFrame: CGRectMake(0,CGRectGetMaxY(self.contentView.frame),self.frame.size.width,0.5)];
    self.bottomLine.backgroundColor=[UIColor lightGrayColor];
    self.bottomLine.hidden=YES;
    [self addSubview:self.bottomLine];

    //短分割线
    self.line=[[UIImageView alloc]initWithFrame: CGRectMake(30*wScale,CGRectGetMaxY(self.contentView.frame)-0.5,self.frame.size.width-30*wScale,0.5)];
    self.line.backgroundColor=[UIColor lightGrayColor];

    self.line.hidden=NO;
    [self addSubview:self.line];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.topLine.frame=CGRectMake(0,-0.5,self.frame.size.width,0.5);
    self.bottomLine.frame=CGRectMake(0,CGRectGetMaxY(self.contentView.frame),self.frame.size.width,0.5);
    self.line.frame=CGRectMake(30*wScale,CGRectGetMaxY(self.contentView.frame)-0.5,self.frame.size.width-30*wScale,0.5);
    self.bottomLine.hidden=_bottomHiden;
    self.topLine.hidden=_topHiden;
  self.line.hidden=_shortHiden;
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
    if(self.backGroundDelegate&&[self.backGroundDelegate respondsToSelector:@selector(baseTableCellBackButtonClickedWithIndexPath:)]){
        [self.backGroundDelegate baseTableCellBackButtonClickedWithIndexPath:self.indexPath];
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
    _bottomHiden=bottomHiden;
    self.bottomLine.hidden=bottomHiden;
}
-(void)setTopHiden:(BOOL)topHiden
{
    _topHiden=topHiden;
    self.topLine.hidden=topHiden;
}
-(void)setShortHiden:(BOOL)shortHiden
{
    _shortHiden=shortHiden;
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


