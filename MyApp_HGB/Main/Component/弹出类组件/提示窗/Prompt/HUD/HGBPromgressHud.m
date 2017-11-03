//
//  HGBPromgressHud.m
//  CTTX
//
//  Created by huangguangbao on 16/6/23.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import "HGBPromgressHud.h"
#import "HGBProgressHUD.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0

@interface HGBPromgressHud()
@property(strong,nonatomic)UIView *backView;
/**
 提示
 */
@property(strong,nonatomic)HGBProgressHUD *hud;

/**
 提示语
 */
/**
 提示字符串
 */
@property(strong,nonatomic)NSString *promptTitle;
/**
 显示时间
 */
@property(assign,nonatomic)NSInteger duration;
@end
@implementation HGBPromgressHud

static HGBPromgressHud *instance=nil;
#pragma mark init
+(instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBPromgressHud alloc]init];
    }
    return instance;
}
/**
 设置显示时间
 
 @param dureation 时间
 */
+(void)setShowDuration:(NSInteger )dureation{
    [HGBPromgressHud shareInstance];
    instance.duration=dureation;
}
/**
 设置显示标题
 
 @param title 标题
 */
+(void)setShowTitle:(NSString *)title{
    [HGBPromgressHud shareInstance];
    instance.promptTitle=title;
}
#pragma mark 保存
/**
 *  保存
 *
 *  @param view 显示界面
 */
+(void)showHUDSaveToView:(UIView *)view{
    [[HGBPromgressHud shareInstance] showHUDSaveToView:view];
}
/**
 *  保存
 *
 *  @param view 显示界面
 */
-(void)showHUDSaveToView:(UIView *)view
{
    if([self.backView superview]){
        [self.backView removeFromSuperview];
    }
    if([self.hud superview]){
        [self.hud hide:YES];
    }
    self.backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.backView.backgroundColor=[UIColor clearColor];
    [view addSubview:self.backView];
    self.hud=[HGBProgressHUD showHUDAddedTo:view animated:YES];
    self.hud.dimBackground=NO;
    self.hud.mode = HGBProgressHUDModeIndeterminate;
    
}

/**
 *  隐藏保存
 */
+(void)hideSave{
    [[HGBPromgressHud shareInstance]hideSave];
}
/**
 *  隐藏保存
 */
-(void)hideSave
{
    [self.backView removeFromSuperview];
    [self.hud hide:YES];
}
/**
 * //显示结果
 *
 *  @param view 显示界面
 */
+(void)showHUDResult:(NSString *)result ToView:(UIView *)view{
    [[HGBPromgressHud shareInstance]showHUDResult:result ToView:view];
}
/**
 * //显示结果
 *
 *  @param view 显示界面
 */
-(void)showHUDResult:(NSString *)result ToView:(UIView *)view{
    if([self.backView superview]){
        [self.backView removeFromSuperview];
    }
    if([self.hud superview]){
        [self.hud hide:YES];
    }
    self.hud = [HGBProgressHUD showHUDAddedTo:view animated:YES];
    self.hud.mode = HGBProgressHUDModeText;
    self.hud.dimBackground=NO;
    if(self.promptTitle){
        self.hud.labelText=self.promptTitle;
    }else{
        self.hud.labelText = @"温馨提示";
    }
    self.hud.detailsLabelText=result;
    if(self.duration==0){
        [self.hud hide:YES afterDelay:2];
    }else{
        [self.hud hide:YES afterDelay:self.duration];
    }
}
/**
 * 显示结果-无遮挡
 *
 *  @param view 显示界面
 */
+(void)showHUDResult:(NSString *)result WithoutBackToView:(UIView *)view{
    [[HGBPromgressHud shareInstance]showHUDResult:result WithoutBackToView:view];
}
/**
 * 显示结果-无遮挡
 *
 *  @param view 显示界面
 */
-(void)showHUDResult:(NSString *)result WithoutBackToView:(UIView *)view{
    if([self.backView superview]){
        [self.backView removeFromSuperview];
    }
    if([self.hud superview]){
        [self.hud hide:YES];
    }
    self.hud = [HGBProgressHUD showHUDAddedTo:view animated:YES];
    self.hud.mode = HGBProgressHUDModeText;
//    self.promptHud.labelText = @"温馨提示";
    self.hud.dimBackground=NO;
    self.hud.userInteractionEnabled=NO;
//    CGFloat margin = 92 ;  //距离底部和顶部的距离
//    CGFloat offSetY = view.bounds.size.height / 2 - margin;
    CGFloat offSetY=(kHeight-64-10)*0.5*0.7;
    self.hud.yOffset = offSetY;
    self.hud.backgroundColor=[UIColor clearColor];
    self.hud.detailsLabelText=result;
    [self.hud hide:YES afterDelay:2];
}
@end
