//
//  HGBCalenderPicker.m
//  测试
//
//  Created by huangguangbao on 2017/10/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCalenderPicker.h"
#import "HGBCalenderPickerHeader.h"

#import "HGBCalenderView.h"

@interface HGBCalenderPicker ()<HGBCalenderViewDelegate>
/**
 代理
 */
@property(assign,nonatomic)id<HGBCalenderPickerDelegate>delegate;
/**
 父控制器
 */
@property(strong,nonatomic)UIViewController *parent;

/**
 根视图控制器
 */
@property(strong,nonatomic)UIWindow *window;

/**
 提示
 */
@property(strong,nonatomic)UILabel *promptLab;
/**
 灰层
 */
@property(strong,nonatomic)UIButton *grayHeaderView;

/**
 取消按钮
 */
@property(strong,nonatomic) UIButton *cancelButton;

/**
 日期
 */
@property(strong,nonatomic)NSDate *date;
/**
 日期格式器
 */
@property(strong,nonatomic)NSDateFormatter *f;
@end

@implementation HGBCalenderPicker

static HGBCalenderPicker *obj=nil;
#pragma mark init
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBCalenderPickerDelegate>)delegate{
    return [[[self class]alloc]initWithParent:parent andWithDelegate:delegate];
}
-(instancetype)initWithParent:(UIViewController *)parent andWithDelegate:(id<HGBCalenderPickerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate=delegate;
        self.parent=parent;
        [self viewSetUp];

    }
    return self;
}

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    //大小位置


}
#pragma mark view
-(void)viewSetUp{
    self.view.backgroundColor=[UIColor whiteColor];
    self.view.frame=CGRectMake(0, 0,kWidth,600*hScale);

    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 70*kHeight)];
    [self.view addSubview:v];
    v.backgroundColor=[UIColor whiteColor];
    v.layer.masksToBounds=YES;
    v.layer.borderColor=[[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3] CGColor];
    v.layer.borderWidth=2;


    //取消修改按钮
    self.cancelButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.cancelButton.titleLabel.font=[UIFont systemFontOfSize:32*hScale];
    self.cancelButton.backgroundColor=[UIColor whiteColor];
    self.cancelButton.frame=CGRectMake(0*wScale,0,120*wScale,70*hScale);
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:self.cancelButton];


    self.promptLab=[[UILabel alloc]initWithFrame:CGRectMake(120*wScale, 0, kWidth-240*wScale, 70*hScale)];
    self.promptLab.text=@"日历选择器";
    self.promptLab.font=[UIFont systemFontOfSize:32*hScale];
    self.promptLab.textColor=[UIColor blackColor];
    self.promptLab.textAlignment=NSTextAlignmentCenter;
    self.promptLab.backgroundColor=[UIColor clearColor];

    HGBCalenderView *calenderView=[[HGBCalenderView alloc]initWithFrame:CGRectMake(10,70*hScale,kWidth-20, kWidth-20)];

    calenderView.delegate=self;

    [self.view addSubview:calenderView];
}
#pragma mark 弹出
//弹出视图
-(void)popInParentView
{
    if(obj){
        [obj popViewRemoved];
    }

    if(self.titleStr&&self.titleStr.length!=0){

        if(![self.promptLab superview]){
            self.promptLab.text=self.titleStr;
            [self.view addSubview:self.promptLab];
        }
    }else{
        if([self.promptLab superview]){
            [self.promptLab removeFromSuperview];
        }
    }

    self.grayHeaderView=[UIButton buttonWithType:UIButtonTypeSystem];
    self.grayHeaderView.frame=[UIScreen mainScreen].bounds;
    self.grayHeaderView.tag=10;
    self.grayHeaderView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.grayHeaderView addTarget:self action:@selector(cancelButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.window addSubview:self.grayHeaderView];
    self.view.frame=CGRectMake(0,kHeight+30,kWidth,366*hScale);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=CGRectMake(0,kHeight-70*hScale-kWidth, kWidth, 70*hScale+kWidth);
    }];

    [self.grayHeaderView addSubview:self.view];
    [self.parent addChildViewController:self];

    obj=self;
}
#pragma mark 视图消失
-(void)popViewDisappearWithSucessBlock:(void (^)(void))successBlock
{
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.view.transform=CGAffineTransformTranslate(self.view.transform,0,1000*hScale);
    } completion:^(BOOL finished) {
        successBlock();
        [self popViewRemoved];
    }];
}

#pragma mark 弹出视图移除
-(void)popViewRemoved
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self.grayHeaderView removeFromSuperview];
    obj=nil;
}
#pragma mark calenderdelegate
-(void)calenderView:(HGBCalenderView *)calender didFinishWithYear:(NSInteger)year andWithMonth:(NSInteger)month andWithDay:(NSInteger)day andWithWeek:(NSInteger)week{
    NSLog(@"%ld-%ld-%ld-%ld",year,month,day,week);
    if(self.delegate&&[self.delegate respondsToSelector:@selector(calender:didFinishWithYear:andWithMonth:andWithDay:andWithWeek:)]){
        [self.delegate calender:self didFinishWithYear:year andWithMonth:month andWithDay:day andWithWeek:week];
    }
    [self popViewDisappearWithSucessBlock:^{

    }];
}

-(void)calenderView:(HGBCalenderView *)calender didFinishWithDate:(NSDate *)date{
    NSLog(@"%@",date);
    if(self.delegate&&[self.delegate respondsToSelector:@selector(calender:didFinishWithDate:)]){
        [self.delegate calender:self didFinishWithDate:date];
    }
    [self popViewDisappearWithSucessBlock:^{

    }];
}
#pragma mark buttonHandler
//确认
-(void)confirmButtonHandler:(UIButton *)_b
{

}
//取消
-(void)cancelButtonHandler:(UIButton *)_b
{
    if (self.delegate && ([self.delegate respondsToSelector:@selector(calenderDidCanceled:)])) {
        [self.delegate calenderDidCanceled:self];
    }
    [self popViewDisappearWithSucessBlock:^{

    }];
}

#pragma mark set
-(void)setSelectedDateString:(NSString *)selectedDateString{
    selectedDateString=[self getNumberStringFromString:selectedDateString];
    if(selectedDateString.length==8){
        self.f.dateFormat=@"yyyyMMdd";
        self.selectedDate=[self.f dateFromString:selectedDateString];
    }else if(selectedDateString.length==6){
        self.f.dateFormat=@"yyyyMM";
        self.selectedDate=[self.f dateFromString:selectedDateString];
    }else if(selectedDateString.length==4){
        self.f.dateFormat=@"MMdd";
        self.selectedDate=[self.f dateFromString:selectedDateString];
    }

}
#pragma mark func
/**
 *  获取数字字符串
 *
 *  @param string 原str
 *
 *  @return 字符串中的数字字符串
 */
-(NSString *)getNumberStringFromString:(NSString *)string{
    NSString *numStr=string;
    NSArray *numArr=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSRange r;
    for(int i=0;i<string.length;i++){
        r.length=1;
        r.location=i;
        NSString *sub=[string substringWithRange:r];
        if(![numArr containsObject:sub]){
            numStr=[numStr stringByReplacingCharactersInRange:r withString:@"-"];
        }
    }
    while ([numStr containsString:@"-"]) {
        numStr=[numStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }

    return numStr;
}
#pragma mark get
-(NSDateFormatter *)f{
    if(_f==nil){
        _f=[[NSDateFormatter alloc]init];
    }
    return _f;
}
-(UIWindow *)window
{
    if(_window==nil){
        _window=[[UIApplication sharedApplication] keyWindow];
    }
    return _window;
}

-(NSDate *)selectedDate{
    if(_selectedDate==nil){
        _selectedDate=[NSDate date];
    }
    return _selectedDate;
}


@end
