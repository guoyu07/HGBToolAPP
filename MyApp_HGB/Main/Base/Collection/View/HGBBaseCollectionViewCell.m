//
//  HGBBaseCollectionViewCell.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/27.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBaseCollectionViewCell.h"


@interface HGBBaseCollectionViewCell()
/**
 左分割线
 */
@property(strong,nonatomic)UIImageView *leftLine;//
/**
 右分割线
 */
@property(strong,nonatomic)UIImageView *rightLine;//
/**
 顶部分割线
 */
@property(strong,nonatomic)UIImageView *topLine;//
/**
 底部分割线
 */
@property(strong,nonatomic)UIImageView *bottomLine;//
@end

@implementation HGBBaseCollectionViewCell
#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewSetUp];
       
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
    self.leftLine=[[UIImageView alloc]initWithFrame: CGRectMake(0*wScale,0,0.5,self.contentView.frame.size.height)];
    self.leftLine.backgroundColor=[UIColor lightGrayColor];

    self.leftLine.hidden=NO;
    [self addSubview:self.leftLine];

    self.rightLine=[[UIImageView alloc]initWithFrame: CGRectMake(self.contentView.frame.size.width-0.5,0,0.5,self.contentView.frame.size.height)];
    self.rightLine.backgroundColor=[UIColor lightGrayColor];

    self.rightLine.hidden=NO;
    [self addSubview:self.leftLine];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.topLine.frame=CGRectMake(0,-0.5,self.frame.size.width,0.5);
    self.bottomLine.frame=CGRectMake(0,CGRectGetMaxY(self.contentView.frame),self.frame.size.width,0.5);
    self.leftLine.frame=CGRectMake(0*wScale,0,0.5,self.contentView.frame.size.height);
    self.rightLine.frame=CGRectMake(self.contentView.frame.size.width-0.5,0,0.5,self.contentView.frame.size.height);
    self.bottomLine.hidden=_bottomHiden;
    self.topLine.hidden=_topHiden;
    self.leftLine.hidden=_leftHiden;
     self.rightLine.hidden=_rightHiden;
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
-(void)setLeftHiden:(BOOL)leftHiden
{
    _leftHiden=leftHiden;
    self.leftLine.hidden=leftHiden;
}
-(void)setRightHiden:(BOOL)rightHiden
{
    _rightHiden=rightHiden;
    self.rightLine.hidden=rightHiden;
}
#pragma mark get
-(NSIndexPath *)indexPath{
    if(_indexPath==nil){
        _indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _indexPath;
}
@end
