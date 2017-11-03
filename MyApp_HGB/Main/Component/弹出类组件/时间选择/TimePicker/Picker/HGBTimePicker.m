//
//  HGBTimePicker.m
//  测试
//
//  Created by huangguangbao on 2017/7/16.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBTimePicker.h"
#import <objc/message.h>
#import "HGBTimePickerHeader.h"

@interface HGBTimePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger _firstIndex;//时坐标
    NSInteger _secondIndex;//分坐标
    NSInteger _threadIndex;//秒坐标
}

/**
 第一列数组-时
 */
@property (nonatomic,strong)NSArray *firstTypesArr;
/**
 第二列数组-分
 */
@property (nonatomic,strong)NSArray *secondTypesArr;
/**
 第三列数组-秒
 */
@property (nonatomic,strong)NSArray *threeTypesArr;
/**
 当前时间
 */
@property(strong,nonatomic)NSArray *currentTimeArr;

/**
 代理
 */
@property(assign,nonatomic)id<HGBTimePickerDelegate>delegate;
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
 确认按钮
 */
@property(strong,nonatomic) UIButton *confirmButton;
/**
 取消按钮
 */
@property(strong,nonatomic) UIButton *cancelButton;


/**
 时间格式器
 */
@property(strong,nonatomic)NSDateFormatter *f;
/**
 时间
 */
@property(strong,nonatomic)NSDate *time;
/**
 事件选择
 */
@property(strong,nonatomic)UIPickerView *picker;
@end

@implementation HGBTimePicker

static  HGBTimePicker *obj=nil;
#pragma mark init
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBTimePickerDelegate>)delegate{
    return [[[self class]alloc]initWithParent:parent andWithDelegate:delegate];
}
-(instancetype)initWithParent:(UIViewController *)parent andWithDelegate:(id<HGBTimePickerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate=delegate;
        self.parent=parent;
        self.numberOfHours=0;
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
    
    //确认修改按钮
    self.confirmButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.confirmButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.confirmButton.titleLabel.font=[UIFont systemFontOfSize:32*hScale];
    self.confirmButton.backgroundColor=[UIColor whiteColor];
    self.confirmButton.frame=CGRectMake(kWidth-120*wScale,0,120*wScale,70*hScale);
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:self.confirmButton];
    
    
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
    self.promptLab.text=@"时间选择器";
    self.promptLab.font=[UIFont systemFontOfSize:32*hScale];
    self.promptLab.textColor=[UIColor blackColor];
    self.promptLab.textAlignment=NSTextAlignmentCenter;
    self.promptLab.backgroundColor=[UIColor clearColor];
    
    self.picker=[[UIPickerView alloc]init];
    self.picker.frame=CGRectMake(0,70*hScale,kWidth,530*hScale);
    self.picker.backgroundColor=[UIColor whiteColor];
    self.picker.delegate=self;
    [self.view addSubview:self.picker];
}
#pragma mark 弹出
//弹出视图
-(void)popInParentView
{
    if(obj){
        [obj popViewRemoved];
    }
    [self setDateSelector];
    if(self.type==HGBTimePickerTypeNO){
        [self.picker reloadComponent:1];
        [self.picker reloadComponent:2];
        
        [self.picker selectRow:_firstIndex inComponent:0 animated:YES];
        [self.picker selectRow:_secondIndex inComponent:1 animated:YES];
        [self.picker selectRow:_threadIndex inComponent:2 animated:YES];
    }else if (self.type==HGBTimePickerTypeOnlyHourMinute){
        [self.picker reloadComponent:1];
        [self.picker selectRow:_firstIndex inComponent:0 animated:YES];
        [self.picker selectRow:_secondIndex inComponent:1 animated:YES];
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
        self.view.frame=CGRectMake(0,kHeight-630*hScale, kWidth, 570*hScale);
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
#pragma mark set时间选择
-(void)setDateSelector{
    
    NSArray *timeArr=[self transTimeToHourMinuteSecondArr:self.selectedTime];
    NSString *hour=timeArr[0];
    NSString *min=timeArr[1];
    NSString *second=timeArr[2];
    
    NSString *currentHour=self.currentTimeArr[0];
    
    NSString *curentMin=self.currentTimeArr[1];
    NSString *curentSecond=self.currentTimeArr[2];
    
    self.f.dateFormat=@"HHmmss";
    
   
    
   
    
    
    
    if(self.type==HGBTimePickerTypeNO)
    {
        if((!self.startTime)&&(!self.stopTime)){
            if(self.numberOfHours<0){
                self.stopTime=[NSDate date];
                self.startTime=[self.f dateFromString:[NSString stringWithFormat:@"%ld%@%@",currentHour.integerValue+self.numberOfHours,curentMin,curentSecond]];
            }else if(self.numberOfHours>0){
                self.startTime=[NSDate date];
                self.stopTime=[self.f dateFromString:[NSString stringWithFormat:@"%ld%@%@",currentHour.integerValue+self.numberOfHours,curentMin,curentSecond]];
                
            }
        }
        if(!self.startTime){
            self.startTime=[self.f dateFromString:@"000000"];
        }
        if(!self.stopTime){
            self.stopTime=[self.f dateFromString:[NSString stringWithFormat:@"235959"]];
        }
       
    }else if(self.type==HGBTimePickerTypeOnlyHourMinute){
        if((!self.startTime)&&(!self.stopTime)){
            if(self.numberOfHours<0){
                self.stopTime=[NSDate date];
                self.startTime=[self.f dateFromString:[NSString stringWithFormat:@"%ld%@%@",currentHour.integerValue+self.numberOfHours,curentMin,curentSecond]];
            }else if(self.numberOfHours>0){
                self.startTime=[NSDate date];
                self.stopTime=[self.f dateFromString:[NSString stringWithFormat:@"%ld%@%@",currentHour.integerValue+self.numberOfHours,curentMin,curentSecond]];
                
            }
        }
        if(!self.startTime){
            self.startTime=[self.f dateFromString:@"000000"];
        }
        if(!self.stopTime){
            self.stopTime=[self.f dateFromString:[NSString stringWithFormat:@"235959"]];
        }
    }
    
    if(self.startTime&&self.stopTime){
        if([[self.f stringFromDate:self.startTime]compare:[self.f stringFromDate:self.stopTime]]>0){
            self.startTime=nil;
            self.stopTime=nil;
        }
    }
    
    if(!self.startTime){
        
        self.startTime=[NSDate date];
    }
    if(!self.stopTime){
        self.stopTime=[NSDate date];
    }
    NSLog(@"huang:%@-%@",[self.f stringFromDate:self.startTime],[self.f stringFromDate:self.stopTime]);
    NSArray *startArr=[self transTimeToHourMinuteSecondArr:self.startTime];
    NSString *startHour=startArr[0];
    NSString *startMin=startArr[1];
    NSString *startSecond=startArr[2];
    
    //时
    _firstTypesArr=[self getHourArr];
    _firstTypesArr=[_firstTypesArr sortedArrayUsingSelector:@selector(compare:)];
    if((hour.integerValue-startHour.integerValue)<_firstTypesArr.count){
        _firstIndex=hour.integerValue-startHour.integerValue;
    }else{
        _firstIndex=_firstTypesArr.count-1;
    }
    
    //分
    _secondTypesArr=[self getMinuteArrWithHour:[NSString stringWithFormat:@"%@",_firstTypesArr[_firstIndex]]];
    _secondTypesArr=[_secondTypesArr sortedArrayUsingSelector:@selector(compare:)];
    if(startHour.integerValue==hour.integerValue){
        if((min.integerValue-startMin.integerValue)<_secondTypesArr.count){
            _secondIndex=min.integerValue-startMin.integerValue;
            
        }else{
            _secondIndex=_secondTypesArr.count-1;
        }
    }else{
        if(min.integerValue<_secondTypesArr.count){
            _secondIndex=min.integerValue;
        }else{
            _secondIndex=_secondTypesArr.count-1;
        }
    }
    
    
    //秒
    _threeTypesArr=[self getSecondArrWithHour:[NSString stringWithFormat:@"%@",_firstTypesArr[_firstIndex]] andWithMinute:[NSString stringWithFormat:@"%@",self.secondTypesArr[_secondIndex]]];
    
    _threeTypesArr=[_threeTypesArr sortedArrayUsingSelector:@selector(compare:)];
    if(hour.integerValue==startHour.integerValue&&min.integerValue==startMin.integerValue){
        if((second.integerValue-startSecond.integerValue)<_threeTypesArr.count){
            _threadIndex=second.integerValue-startSecond.integerValue;
        }else{
            _threadIndex=_threeTypesArr.count-1;
        }
    }else{
        if(second.integerValue<_threeTypesArr.count){
            _threadIndex=second.integerValue;
        }else{
            _threadIndex=_threeTypesArr.count-1;
        }
    }
}
#pragma mark buttonHandler
//确认
-(void)confirmButtonHandler:(UIButton *)_b
{
    self.f.dateFormat=@"HH-mm-ss";
    NSString *timeStr;
    NSNumber *hour;
    NSNumber *min;
    NSNumber *second;
    hour=_firstTypesArr[_firstIndex];
    min=_secondTypesArr[_secondIndex];
    second=_threeTypesArr[_threadIndex];
    timeStr=[NSString stringWithFormat:@"%02d-%02d-%02d",hour.intValue,min.intValue,second.intValue];
    if(self.type==HGBTimePickerTypeNO){
        self.f.dateFormat=@"HH-mm-ss";
         timeStr=[NSString stringWithFormat:@"%02d-%02d-%02d",hour.intValue,min.intValue,second.intValue];
    }else if (self.type==HGBTimePickerTypeOnlyHourMinute){
        self.f.dateFormat=@"HH-mm";
        timeStr=[NSString stringWithFormat:@"%02d-%02d",hour.intValue,min.intValue];
    }
   
    
    
    self.time=[self.f dateFromString:timeStr];
    
     if(self.delegate&&[self.delegate respondsToSelector:@selector(timePicker: didSelectedTime:)]){
        [self.delegate timePicker:self didSelectedTime:self.time];
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(timePicker: didSelectedTimeToFormatTimeString:)]){
        while ([timeStr containsString:@"-"]) {
            timeStr=[timeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        [self.delegate timePicker:self didSelectedTimeToFormatTimeString:timeStr];
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(timePicker: didSelectedTimeToHour:Minute:Second:)]){
        if(self.type==HGBTimePickerTypeNO){
            [self.delegate timePicker:self didSelectedTimeToHour:[NSString stringWithFormat:@"%02ld",(long)hour.integerValue] Minute:[NSString stringWithFormat:@"%02ld",(long)min.integerValue] Second:[NSString stringWithFormat:@"%02ld",(long)second.integerValue]];
        }else{
             [self.delegate timePicker:self didSelectedTimeToHour:[NSString stringWithFormat:@"%02ld",(long)hour.integerValue] Minute:[NSString stringWithFormat:@"%02ld",(long)min.integerValue] Second:@""];
        }
    }
    [self popViewDisappearWithSucessBlock:^{
        
    }];
}
//取消
-(void)cancelButtonHandler:(UIButton *)_b
{
    if (self.delegate && ([self.delegate respondsToSelector:@selector(timePickerDidCanceled:)])) {
        [self.delegate timePickerDidCanceled:self];
    }
    [self popViewDisappearWithSucessBlock:^{
        
    }];
}

#pragma mark pickDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(self.type==HGBTimePickerTypeNO){
        return 3;
    }else{
        return 2;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(self.type==HGBTimePickerTypeNO){
        if(component==0){
            return _firstTypesArr.count;
        }else if (component==1){
            return  _secondTypesArr.count;
        }else{
            return _threeTypesArr.count;
        }
    }else{
        if(component==0){
            return _firstTypesArr.count;
        }else{
            return  _secondTypesArr.count;
        }
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(self.type==HGBTimePickerTypeNO){
        if(component==0){
            return [NSString stringWithFormat:@"%@时",_firstTypesArr[row]];
        }else if (component==1){
            return [NSString stringWithFormat:@"%@分",_secondTypesArr[row]];
        }else {
            return [NSString stringWithFormat:@"%@秒",_threeTypesArr[row]];
        }
    }else{
        if(component==0){
            return [NSString stringWithFormat:@"%@时",_firstTypesArr[row]];
        }else{
            return [NSString stringWithFormat:@"%@分",_secondTypesArr[row]];
        }
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        if(self.fontSize!=0){
            [pickerLabel setFont:[UIFont boldSystemFontOfSize:self.fontSize]];
        }else{
            [pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
        }
        if(self.textColor){
            pickerLabel.textColor=self.textColor;
        }else{
            pickerLabel.textColor=[UIColor blackColor];
        }
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(self.type==HGBTimePickerTypeNO){
        if(component==0){
            _firstIndex=row;
            if(_firstIndex>=self.firstTypesArr.count){
                _firstIndex=self.firstTypesArr.count-1;
            }
            _secondTypesArr=[self getMinuteArrWithHour:[NSString stringWithFormat:@"%@",_firstTypesArr[_firstIndex]]];
            _secondTypesArr=[_secondTypesArr sortedArrayUsingSelector:@selector(compare:)];
            if(_secondIndex>=_secondTypesArr.count){
                _secondIndex=_secondTypesArr.count-1;
            }
            _threeTypesArr=[self getSecondArrWithHour:[NSString stringWithFormat:@"%@",_firstTypesArr[_firstIndex]] andWithMinute:[NSString stringWithFormat:@"%@",self.secondTypesArr[_secondIndex]]];
            _threeTypesArr=[_threeTypesArr sortedArrayUsingSelector:@selector(compare:)];
            if(_threadIndex>=_threeTypesArr.count){
                _threadIndex=_threeTypesArr.count-1;
            }
            [self.picker reloadComponent:1];
            [self.picker reloadComponent:2];
            [self.picker selectRow:_secondIndex inComponent:1 animated:YES];
            [self.picker selectRow:_threadIndex inComponent:2 animated:YES];
        }else if (component==1){
            _secondIndex=row;
            if(_secondIndex>=_secondTypesArr.count){
                _secondIndex=_secondTypesArr.count-1;
            }
            _threeTypesArr=[self getSecondArrWithHour:[NSString stringWithFormat:@"%@",_firstTypesArr[_firstIndex]] andWithMinute:[NSString stringWithFormat:@"%@",self.secondTypesArr[_secondIndex]]];
            _threeTypesArr=[_threeTypesArr sortedArrayUsingSelector:@selector(compare:)];
            if(_threadIndex>=_threeTypesArr.count){
                _threadIndex=_threeTypesArr.count-1;
                
            }
            [self.picker reloadComponent:2];
            [self.picker selectRow:_threadIndex inComponent:2 animated:YES];
        }else if (component==2){
            _threadIndex=row;
            if(_threadIndex>=_threeTypesArr.count){
                _threadIndex=_threeTypesArr.count-1;
                
            }
        }
    }else if(self.type==HGBTimePickerTypeOnlyHourMinute){
        if(component==0){
            _firstIndex=row;
            if(_firstIndex>=self.firstTypesArr.count){
                _firstIndex=self.firstTypesArr.count-1;
            }
            _secondTypesArr=[self getMinuteArrWithHour:[NSString stringWithFormat:@"%@",_firstTypesArr[_firstIndex]]];
            _secondTypesArr=[_secondTypesArr sortedArrayUsingSelector:@selector(compare:)];
            if(_secondIndex>=_secondTypesArr.count){
                _secondIndex=_secondTypesArr.count-1;
            }
            [self.picker reloadComponent:1];
            [self.picker selectRow:_secondIndex inComponent:1 animated:YES];
        }else{
            _secondIndex=row;
            if(_secondIndex>=_secondTypesArr.count){
                _secondIndex=_secondTypesArr.count-1;
            }
        }
    }
}

#pragma mark 获取时-分-秒数组
//时
-(NSArray *)getHourArr{
    NSMutableArray *hourArr=[NSMutableArray array];
    NSArray *startArr=[self transTimeToHourMinuteSecondArr:self.startTime];
    NSString *startHour=startArr[0];
    
    NSArray *stopArr=[self transTimeToHourMinuteSecondArr:self.stopTime];
    NSString *stopHour=stopArr[0];
    for(int i=(int)startHour.integerValue;i<=stopHour.integerValue;i++){
        [hourArr addObject:[NSNumber numberWithInt:i]];
    }
    return hourArr;
}
//分
-(NSArray *)getMinuteArrWithHour:(NSString *)hour{
    
    NSMutableArray *minuteArr=[NSMutableArray array];
    int m=0,n=59;
    NSArray *startArr=[self transTimeToHourMinuteSecondArr:self.startTime];
    NSString *startHour=startArr[0];
    NSString *startMin=startArr[1];
    
    NSArray *stopArr=[self transTimeToHourMinuteSecondArr:self.stopTime];
    NSString *stopHour=stopArr[0];
    NSString *stopMin=stopArr[1];
    if(hour.integerValue==startHour.integerValue){
        m=(int)startMin.integerValue;
    }
    if(hour.integerValue==stopHour.integerValue){
        n=(int)stopMin.integerValue;
    }
    for(int i=m;i<=n;i++){
        [minuteArr addObject:[NSNumber numberWithInt:i]];
    }
    return minuteArr;
}
//秒
-(NSArray *)getSecondArrWithHour:(NSString *)hour andWithMinute:(NSString *)min{
    
    NSMutableArray *secondArr=[NSMutableArray array];
    NSArray *startArr=[self transTimeToHourMinuteSecondArr:self.startTime];
    NSString *startHour=startArr[0];
    NSString *startMin=startArr[1];
    NSString *startSecond=startArr[2];
    
    NSArray *stopArr=[self transTimeToHourMinuteSecondArr:self.stopTime];
    NSString *stopHour=stopArr[0];
    NSString *stopMin=stopArr[1];
    NSString *stopSecond=stopArr[2];
    NSInteger n=59;
    int m=0;
    
    if(hour.integerValue==startHour.integerValue&&min.integerValue==startMin.integerValue){
        m=(int)startSecond.integerValue;
    }
    if(hour.integerValue==stopHour.integerValue&&min.integerValue==stopMin.integerValue){
        n=(int)stopSecond.integerValue;
    }
    for(int i=m;i<=n;i++){
        [secondArr addObject:[NSNumber numberWithInt:i]];
    }
    return secondArr;
    
}

#pragma mark 将日期转化为时分秒
-(NSArray *)transTimeToHourMinuteSecondArr:(NSDate *)date{
    if(date){
        NSDateFormatter *f0=[[NSDateFormatter alloc]init];
        f0.dateFormat=@"HH";
        NSDateFormatter *f1=[[NSDateFormatter alloc]init];
        f1.dateFormat=@"mm";
        NSDateFormatter *f2=[[NSDateFormatter alloc]init];
        f2.dateFormat=@"ss";
        
        NSString *hour=[f0 stringFromDate:date];
        NSString *min=[f1 stringFromDate:date];
        NSString *second=[f2 stringFromDate:date];
        return @[hour,min,second];
    }
    return nil;
}
#pragma mark set
-(void)setSelectedTimeString:(NSString *)selectedTimeString{
    selectedTimeString=[self getNumberStringFromString:selectedTimeString];
    if(selectedTimeString.length==6){
        self.f.dateFormat=@"HHmmss";
        self.selectedTime=[self.f dateFromString:selectedTimeString];
    }else if(selectedTimeString.length==4){
        self.f.dateFormat=@"HHmm";
        self.selectedTime=[self.f dateFromString:selectedTimeString];
    }
    
}
-(void)setStartTimeString:(NSString *)startTimeString{
    startTimeString=[self getNumberStringFromString:startTimeString];
    if(startTimeString.length==6){
        self.f.dateFormat=@"HHmmss";
        self.startTime=[self.f dateFromString:startTimeString];
    }else if(startTimeString.length==4){
        self.f.dateFormat=@"HHmm";
        self.startTime=[self.f dateFromString:startTimeString];
    }
}
-(void)setStopTimeString:(NSString *)stopTimeString{
    stopTimeString=[self getNumberStringFromString:stopTimeString];
    if(stopTimeString.length==6){
        self.f.dateFormat=@"HHmmss";
        self.stopTime=[self.f dateFromString:stopTimeString];
    }else if(stopTimeString.length==4){
        self.f.dateFormat=@"HHmm";
        self.stopTime=[self.f dateFromString:stopTimeString];
    }

}

#pragma mark get
-(UIWindow *)window
{
    if(_window==nil){
        _window=[[UIApplication sharedApplication] keyWindow];
    }
    return _window;
}
-(NSArray *)currentTimeArr{
    _currentTimeArr=[self transTimeToHourMinuteSecondArr:[NSDate date]];
    return _currentTimeArr;
}
-(NSDate *)selectedTime{
    if(_selectedTime==nil){
        _selectedTime=[NSDate date];
    }
    return _selectedTime;
}

-(NSDateFormatter *)f{
    if(_f==nil){
        _f=[[NSDateFormatter alloc]init];
    }
    return _f;
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
@end

