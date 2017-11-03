//
//  HGBCalenderTextField.m
//  测试
//
//  Created by huangguangbao on 2017/10/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCalenderTextField.h"
#import "HGBCalenderView.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0


@interface HGBCalenderTextField()<HGBCalenderViewDelegate>
/**
 文本
 */
@property(strong,nonatomic)UILabel *text;
/**
 图片
 */
@property(strong,nonatomic)UIImageView *imageView;
/**
 图片按钮
 */
@property(strong,nonatomic)UIButton *backButton;
/**
 界面大小
 */
@property(assign,nonatomic)CGRect frameRect;
/**
 日历
 */
@property(strong,nonatomic)HGBCalenderView *calenderView;
/**
 根视图控制器
 */
@property(strong,nonatomic)UIWindow *window;
@end
@implementation HGBCalenderTextField
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self viewSetUp];
    }
    return self;
}
-(void)viewSetUp{
    self.text=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, @(self.frame.size.width-20).stringValue.integerValue, self.frame.size.height)];
    self.text.backgroundColor=[UIColor clearColor];
    self.text.layer.masksToBounds=self.layer.masksToBounds;
    self.text.layer.borderColor=self.layer.borderColor;
    self.text.layer.borderWidth=self.layer.borderWidth;
    self.text.layer.cornerRadius=self.layer.cornerRadius;
    self.text.textColor=self.textColor;
    self.text.textAlignment=NSTextAlignmentCenter;
    self.text.text=self.placeholder;
    [self addSubview:self.text];

    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(@(self.frame.size.width-20).stringValue.integerValue, @((self.frame.size.height-14)*0.5).stringValue.integerValue, 14, 14)];
    self.imageView.image=[UIImage imageNamed:@"HGBCalenderBundle.bundle/rili.png"];
    [self addSubview:self.imageView];
    self.backButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.backButton.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.backButton addTarget:self action:@selector(calenderHandle) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.backButton];

}
-(void)calenderHandle{
    self.calenderView.superview.userInteractionEnabled=YES;
    self.superview.userInteractionEnabled=YES;
    if([self.calenderView superview]){
        [self.calenderView removeFromSuperview];
    }else{
        if((kHeight-self.frame.size.height-self.frame.origin.y)<self.frame.size.width){
            self.calenderView=[[HGBCalenderView alloc]initWithFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y -self.frame.size.width, self.frame.size.width,self.frame.size.width)];
            self.calenderView.delegate=self;
            [self.superview addSubview:self.calenderView];


        }else{
            self.calenderView=[[HGBCalenderView alloc]initWithFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+self.frame.size.height, self.frame.size.width,self.frame.size.width)];
            self.calenderView.delegate=self;
            [self.superview addSubview:self.calenderView];

        }

    }



}
#pragma mark calenderViewdelegate
-(void)calenderView:(HGBCalenderView *)calender didFinishWithYear:(NSInteger)year andWithMonth:(NSInteger)month andWithDay:(NSInteger)day andWithWeek:(NSInteger)week{
    NSLog(@"%ld-%ld-%ld-%ld",year,month,day,week);

}
-(void)calenderView:(HGBCalenderView *)calender didFinishWithDate:(NSDate *)date{
    NSLog(@"%@",date);
    self.date=date;
    if(self.date){
        NSDateFormatter *f=[[NSDateFormatter alloc]init];
        f.dateFormat=@"yyyy-MM-dd";
        self.text.text=[f stringFromDate:self.date];
    }else{
        self.text.text=self.placeholder;
    }
     [self.calenderView removeFromSuperview];
}
-(void)layoutSubviews{
    self.text.frame=CGRectMake(0, 0, @(self.frame.size.width-20).stringValue.integerValue, self.frame.size.height);
    self.imageView.frame=CGRectMake(@(self.frame.size.width-20).stringValue.integerValue, @((self.frame.size.height-14)*0.5).stringValue.integerValue, 14, 14);
    self.backButton.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(self.rightimage){
        self.imageView.image=self.rightimage;
    }
    self.text.layer.masksToBounds=self.layer.masksToBounds;
    self.text.layer.borderColor=self.layer.borderColor;
    self.text.layer.borderWidth=self.layer.borderWidth;
    self.text.layer.cornerRadius=self.layer.cornerRadius;
    self.text.textColor=self.textColor;
    self.text.text=self.placeholder;
    if(self.date){
        NSDateFormatter *f=[[NSDateFormatter alloc]init];
        f.dateFormat=@"yyyy-MM-dd";
        self.text.text=[f stringFromDate:self.date];
    }else{
        self.text.text=self.placeholder;
    }

}
/**
 进入响应模式
 */
-(void)becomeFirstResponder{
    [self calenderHandle];
}
/**
 退出响应模式
 */
-(void)resignFirstResponder{
    [self.calenderView removeFromSuperview];

}
#pragma mark get
-(UIWindow *)window
{
    if(_window==nil){
        _window=[[UIApplication sharedApplication] keyWindow];
    }
    return _window;
}
@end
