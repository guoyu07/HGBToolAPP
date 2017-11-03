//
//  HGBDatePicker.m
//  测试
//
//  Created by huangguangbao on 2017/7/15.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBDatePicker.h"
#import <objc/message.h>
#import "HGBDatePickerHeader.h"
@interface HGBDatePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger _firstIndex;//年坐标
    NSInteger _secondIndex;//月坐标
    NSInteger _threadIndex;//日坐标
}

/**
 第一列数组-年
 */
@property (nonatomic,strong)NSArray *firstTypesArr;
/**
 第二列数组-月
 */
@property (nonatomic,strong)NSArray *secondTypesArr;
/**
 第三列数组-日
 */
@property (nonatomic,strong)NSArray *threeTypesArr;
/**
 当前日期
 */
@property(strong,nonatomic)NSArray *currentDateArr;

/**
 代理
 */
@property(assign,nonatomic)id<HGBDatePickerDelegate>delegate;
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
 事件选择
 */
@property(strong,nonatomic)UIPickerView *picker;

/**
 日期格式器
 */
@property(strong,nonatomic)NSDateFormatter *f;
/**
 日期
 */
@property(strong,nonatomic)NSDate *date;

@end

@implementation HGBDatePicker

static HGBDatePicker *obj=nil;
#pragma mark init
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBDatePickerDelegate>)delegate{
    return [[[self class]alloc]initWithParent:parent andWithDelegate:delegate];
}
-(instancetype)initWithParent:(UIViewController *)parent andWithDelegate:(id<HGBDatePickerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate=delegate;
        self.parent=parent;
        self.numberOfYears=0;
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
    
    if(self.type==HGBDatePickerTypeNO){
        [self.picker reloadComponent:0];
        [self.picker reloadComponent:1];
        [self.picker reloadComponent:2];
    }else{
        [self.picker reloadComponent:0];
         [self.picker reloadComponent:1];
    }
    
   
    
    if(self.type==HGBDatePickerTypeNO){
        [self.picker selectRow:_firstIndex inComponent:0 animated:YES];
        [self.picker selectRow:_secondIndex inComponent:1 animated:YES];
         [self.picker selectRow:_threadIndex inComponent:2 animated:YES];
    }else if (self.type==HGBDatePickerTypeOnlyYearMonth){
        [self.picker selectRow:_firstIndex inComponent:0 animated:YES];
        [self.picker selectRow:_secondIndex inComponent:1 animated:YES];
    }else if (self.type==HGBDatePickerTypeOnlyMonthDay){
        [self.picker selectRow:_secondIndex inComponent:0 animated:YES];
        [self.picker selectRow:_threadIndex inComponent:1 animated:YES];
        
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
    NSArray *dateArr=[self transDateToYearMonDayArr:self.selectedDate];
    NSString *year=dateArr[0];
    NSString *mon=dateArr[1];
    NSString *day=dateArr[2];
    
    NSString *currentYear=self.currentDateArr[0];
    NSString *curentMon=self.currentDateArr[1];
    NSString *curentDay=self.currentDateArr[2];
   
    self.f.dateFormat=@"yyyyMMdd";
    if(self.type==HGBDatePickerTypeNO){
        if((!self.startDate)&&(!self.stopDate)){
           if(self.numberOfYears>0){
                self.startDate=[NSDate date];
                self.stopDate=[self.f dateFromString:[NSString stringWithFormat:@"%ld%@%@",(long)(currentYear.integerValue+self.numberOfYears),curentMon,curentDay]];
            }else if(self.numberOfYears<0){
                self.stopDate=[NSDate date];
                self.startDate=[self.f dateFromString:[NSString stringWithFormat:@"%ld%@%@",(long)(currentYear.integerValue+self.numberOfYears),curentMon,curentDay]];
            }
        }
        if(!self.startDate){
            self.startDate=[self.f dateFromString:@"00010101"];
        }
        if(!self.stopDate){
            self.stopDate=[self.f dateFromString:@"99991231"];
        }
    }else if(self.type==HGBDatePickerTypeOnlyYearMonth){
        if((!self.startDate)&&(!self.stopDate)){
            if(self.numberOfYears>0){
                self.startDate=[NSDate date];
                self.stopDate=[self.f dateFromString:[NSString stringWithFormat:@"%ld%@%@",(long)(currentYear.integerValue+self.numberOfYears),curentMon,curentDay]];
            }else if(self.numberOfYears<0){
                self.stopDate=[NSDate date];
                self.startDate=[self.f dateFromString:[NSString stringWithFormat:@"%ld%@%@",(long)(currentYear.integerValue+self.numberOfYears),curentMon,curentDay]];
            }
        }
        if(!self.startDate){
            self.startDate=[self.f dateFromString:@"00010101"];
        }
        if(!self.stopDate){
            self.stopDate=[self.f dateFromString:@"99991231"];
        }
    }else if(self.type==HGBDatePickerTypeOnlyMonthDay){
        if(!self.startDate){
             self.startDate=[self.f dateFromString:[NSString stringWithFormat:@"%@0101",currentYear]];
        }else{
            self.f.dateFormat=@"MMdd";
            NSString *dateString=[self.f stringFromDate:self.startDate];
            self.f.dateFormat=@"yyyyMMdd";
             self.startDate=[self.f dateFromString:[NSString stringWithFormat:@"%@%@",currentYear,dateString]];
        }
        if(!self.stopDate){
            self.stopDate=[self.f dateFromString:[NSString stringWithFormat:@"%@1231",currentYear]];
        }else{
            self.f.dateFormat=@"MMdd";
            NSString *dateString=[self.f stringFromDate:self.stopDate];
            self.f.dateFormat=@"yyyyMMdd";
            self.stopDate=[self.f dateFromString:[NSString stringWithFormat:@"%@%@",currentYear,dateString]];
        }
    }
    if(self.startDate&&self.stopDate){
        if([[self.f stringFromDate:self.startDate] compare:[self.f stringFromDate:self.startDate]]>0){
            self.startDate=nil;
            self.stopDate=nil;
        }
    }
    if(!self.startDate){
        self.startDate=[NSDate date];
    }
    if(!self.stopDate){
        self.stopDate=[NSDate date];
    }
    NSArray *startArr=[self transDateToYearMonDayArr:self.startDate];
    NSString *startYear=startArr[0];
    NSString *startMon=startArr[1];
    NSString *startDay=startArr[2];
    
    //年
    _firstTypesArr=[self getYearArr];
    _firstTypesArr=[_firstTypesArr sortedArrayUsingSelector:@selector(compare:)];
    if((year.integerValue-startYear.integerValue)<_firstTypesArr.count){
        _firstIndex=year.integerValue-startYear.integerValue;
    }else{
        _firstIndex=_firstTypesArr.count-1;
    }
    //月
    _secondTypesArr=[self getMonthArrWithYear:[NSString stringWithFormat:@"%@",_firstTypesArr[_firstIndex]]];
    _secondTypesArr=[_secondTypesArr sortedArrayUsingSelector:@selector(compare:)];
    if(startYear.integerValue==year.integerValue){
        if((mon.integerValue-startMon.integerValue)<_secondTypesArr.count){
            _secondIndex=mon.integerValue-startMon.integerValue;
            
        }else{
            _secondIndex=_secondTypesArr.count-1;
        }
    }else{
        if(mon.integerValue<=_secondTypesArr.count){
            _secondIndex=mon.integerValue-1;
        }else{
            _secondIndex=_secondTypesArr.count-1;
        }
    }
    
    
    //日
    _threeTypesArr=[self getDayArrWithYear:[NSString stringWithFormat:@"%@",_firstTypesArr[_firstIndex]] andWithMon:[NSString stringWithFormat:@"%@",self.secondTypesArr[_secondIndex]]];
    
    _threeTypesArr=[_threeTypesArr sortedArrayUsingSelector:@selector(compare:)];
    if(year.integerValue==startYear.integerValue&&mon.integerValue==startMon.integerValue){
        if((day.integerValue-startDay.integerValue)<_threeTypesArr.count){
            _threadIndex=day.integerValue-startDay.integerValue;
        }else{
            _threadIndex=_threeTypesArr.count-1;
        }
    }else{
        if(day.integerValue<=_threeTypesArr.count){
            _threadIndex=day.integerValue-1;
        }else{
            
            _threadIndex=_threeTypesArr.count-1;
        }
    }
}
#pragma mark buttonHandler
//确认
-(void)confirmButtonHandler:(UIButton *)_b
{
    self.f.dateFormat=@"yyyy-MM-dd";
    NSString *dateStr;
    NSNumber *year;
    NSNumber *month;
    NSNumber *day;
    year=_firstTypesArr[_firstIndex];
    month=_secondTypesArr[_secondIndex];
    day=_threeTypesArr[_threadIndex];
    dateStr=[NSString stringWithFormat:@"%02d-%02d-%02d",year.intValue,month.intValue,day.intValue];
    if(self.type==HGBDatePickerTypeNO){
        self.f.dateFormat=@"yyyy-MM-dd";
        dateStr=[NSString stringWithFormat:@"%02d-%02d-%02d",year.intValue,month.intValue,day.intValue];
    }else if(self.type==HGBDatePickerTypeOnlyYearMonth){
        self.f.dateFormat=@"yyyy-MM";
        dateStr=[NSString stringWithFormat:@"%02d-%02d",year.intValue,month.intValue];
    }else if(self.type==HGBDatePickerTypeOnlyMonthDay){
        self.f.dateFormat=@"MM-dd";
        dateStr=[NSString stringWithFormat:@"%02d-%02d",month.intValue,day.intValue];
    }
    
    self.date=[self.f dateFromString:dateStr];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(datePicker: didSelectedDate:)]){
        [self.delegate datePicker:self didSelectedDate:self.date];
      
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(datePicker: didSelectedDateToFormatDateString:)]){
        while ([dateStr containsString:@"-"]) {
            dateStr=[dateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        [self.delegate datePicker:self didSelectedDateToFormatDateString:dateStr];
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(datePicker: didSelectedDateToYear:Month:Day:)]){
        if(self.type==HGBDatePickerTypeNO){
            self.f.dateFormat=@"yyyy-MM-dd";
           [self.delegate datePicker:self didSelectedDateToYear:[NSString stringWithFormat:@"%02ld",(long)year.integerValue] Month:[NSString stringWithFormat:@"%02ld",(long)month.integerValue] Day:[NSString stringWithFormat:@"%02ld",(long)day.integerValue]];
        }else if(self.type==HGBDatePickerTypeOnlyYearMonth){
            self.f.dateFormat=@"yyyy-MM";
            [self.delegate datePicker:self didSelectedDateToYear:[NSString stringWithFormat:@"%02ld",(long)year.integerValue] Month:[NSString stringWithFormat:@"%02ld",(long)month.integerValue] Day:@""];
        }else if(self.type==HGBDatePickerTypeOnlyMonthDay){
            self.f.dateFormat=@"MM-dd";
            [self.delegate datePicker:self didSelectedDateToYear:@"" Month:[NSString stringWithFormat:@"%02ld",(long)month.integerValue] Day:[NSString stringWithFormat:@"%02ld",(long)day.integerValue]];
        }
        
    }
    [self popViewDisappearWithSucessBlock:^{
        
    }];
}
//取消
-(void)cancelButtonHandler:(UIButton *)_b
{
    if (self.delegate && ([self.delegate respondsToSelector:@selector(datePickerDidCanceled:)])) {
        [self.delegate datePickerDidCanceled:self];
    }
    [self popViewDisappearWithSucessBlock:^{
        
    }];
}

#pragma mark pickDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(self.type==HGBDatePickerTypeOnlyYearMonth||self.type==HGBDatePickerTypeOnlyMonthDay){
        return 2;
    }else{
        return 3;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(self.type==HGBDatePickerTypeOnlyYearMonth){
        if(component==0){
            return _firstTypesArr.count;
        }else{
            return  _secondTypesArr.count;
        }
    }else if(self.type==HGBDatePickerTypeOnlyMonthDay){
        if (component==0){
            return  _secondTypesArr.count;
        }else{
            return _threeTypesArr.count;
        }
    }else{
        if(component==0){
            return _firstTypesArr.count;
        }else if (component==1){
            return  _secondTypesArr.count;
        }else{
            return _threeTypesArr.count;
        }
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.type==HGBDatePickerTypeOnlyYearMonth){
        if(component==0){
            return [NSString stringWithFormat:@"%@年",_firstTypesArr[row]];
        }else{
            return [NSString stringWithFormat:@"%@月",_secondTypesArr[row]];
        }
    }else if (self.type==HGBDatePickerTypeOnlyMonthDay){
        if (component==0){
            return [NSString stringWithFormat:@"%@月",_secondTypesArr[row]];
        }else {
            return [NSString stringWithFormat:@"%@日",_threeTypesArr[row]];
        }
    }else{
        if(component==0){
            return [NSString stringWithFormat:@"%@年",_firstTypesArr[row]];
        }else if (component==1){
            return [NSString stringWithFormat:@"%@月",_secondTypesArr[row]];
        }else {
            return [NSString stringWithFormat:@"%@日",_threeTypesArr[row]];
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
    if (self.type==HGBDatePickerTypeOnlyYearMonth){
        if(component==0){
            _firstIndex=row;
            if(_firstIndex>=self.firstTypesArr.count){
                _firstIndex=self.firstTypesArr.count-1;
            }
            _secondTypesArr=[self getMonthArrWithYear:[NSString stringWithFormat:@"%@",_firstTypesArr[_firstIndex]]];
            _secondTypesArr=[_secondTypesArr sortedArrayUsingSelector:@selector(compare:)];
            if(_secondIndex>=_secondTypesArr.count){
                _secondIndex=_secondTypesArr.count-1;
            }
            [self.picker reloadComponent:1];
            [self.picker selectRow:_secondIndex inComponent:1 animated:YES];
           
        }else if (component==1){
            _secondIndex=row;
            if(_secondIndex>=_secondTypesArr.count){
                _secondIndex=_secondTypesArr.count-1;
            }
            
        }
    }else if(self.type==HGBDatePickerTypeOnlyMonthDay){
       if (component==0){
            _secondIndex=row;
            _secondTypesArr=[self getMonthArrWithYear:[NSString stringWithFormat:@"%@",_firstTypesArr[0]]];
            _secondTypesArr=[_secondTypesArr sortedArrayUsingSelector:@selector(compare:)];
            if(_secondIndex>=_secondTypesArr.count){
                _secondIndex=_secondTypesArr.count-1;
            }
            _threeTypesArr=[self getDayArrWithYear:[NSString stringWithFormat:@"%@",_firstTypesArr[_firstIndex]] andWithMon:[NSString stringWithFormat:@"%@",self.secondTypesArr[_secondIndex]]];
            _threeTypesArr=[_threeTypesArr sortedArrayUsingSelector:@selector(compare:)];
            if(_threadIndex>=_threeTypesArr.count){
                _threadIndex=_threeTypesArr.count-1;
                
            }
            [self.picker reloadComponent:1];
            [self.picker selectRow:_threadIndex inComponent:1 animated:YES];
        }else if (component==1){
            _threadIndex=row;
            if(_threadIndex>=_threeTypesArr.count){
                _threadIndex=_threeTypesArr.count-1;
                
            }
        }
    }else{
        if(component==0){
            _firstIndex=row;
            if(_firstIndex>=self.firstTypesArr.count){
                _firstIndex=self.firstTypesArr.count-1;
            }
            _secondTypesArr=[self getMonthArrWithYear:[NSString stringWithFormat:@"%@",_firstTypesArr[_firstIndex]]];
            _secondTypesArr=[_secondTypesArr sortedArrayUsingSelector:@selector(compare:)];
            if(_secondIndex>=_secondTypesArr.count){
                _secondIndex=_secondTypesArr.count-1;
            }
            _threeTypesArr=[self getDayArrWithYear:[NSString stringWithFormat:@"%@",_firstTypesArr[_firstIndex]] andWithMon:[NSString stringWithFormat:@"%@",self.secondTypesArr[_secondIndex]]];
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
            _threeTypesArr=[self getDayArrWithYear:[NSString stringWithFormat:@"%@",_firstTypesArr[_firstIndex]] andWithMon:[NSString stringWithFormat:@"%@",self.secondTypesArr[_secondIndex]]];
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
    }
}

#pragma mark 获取年-月-日数组
//年
-(NSArray *)getYearArr{
    NSMutableArray *yearArr=[NSMutableArray array];
    NSArray *startArr=[self transDateToYearMonDayArr:self.startDate];
    NSString *startYear=startArr[0];
    
    NSArray *stopArr=[self transDateToYearMonDayArr:self.stopDate];
    NSString *stopYear=stopArr[0];
    
    for(int i=(int)startYear.integerValue;i<=stopYear.integerValue;i++){
        [yearArr addObject:[NSNumber numberWithInt:i]];
    }
    return yearArr;
}
//月
-(NSArray *)getMonthArrWithYear:(NSString *)year{
    
    NSMutableArray *monthArr=[NSMutableArray array];
    int m=1,n=12;
    NSArray *startArr=[self transDateToYearMonDayArr:self.startDate];
    NSString *startYear=startArr[0];
    NSString *startMon=startArr[1];
    
    NSArray *stopArr=[self transDateToYearMonDayArr:self.stopDate];
    NSString *stopYear=stopArr[0];
    NSString *stopMon=stopArr[1];
    if(year.integerValue==startYear.integerValue){
        m=(int)startMon.integerValue;
    }
    if(year.integerValue==stopYear.integerValue){
        n=(int)stopMon.integerValue;
    }
    for(int i=m;i<=n;i++){
        [monthArr addObject:[NSNumber numberWithInt:i]];
    }
    return monthArr;
}
//日
-(NSArray *)getDayArrWithYear:(NSString *)year andWithMon:(NSString *)mon{
    
    NSMutableArray *dayArr=[NSMutableArray array];
    NSArray *startArr=[self transDateToYearMonDayArr:self.startDate];
    NSString *startYear=startArr[0];
    NSString *startMon=startArr[1];
    NSString *startDay=startArr[2];
    
    NSArray *stopArr=[self transDateToYearMonDayArr:self.stopDate];
    NSString *stopYear=stopArr[0];
    NSString *stopMon=stopArr[1];
    NSString *stopDay=stopArr[2];
    NSInteger n=[self daysForYear:year.integerValue andWithMonth:mon.integerValue];
    int m=1;
    
    if(year.integerValue==startYear.integerValue&&mon.integerValue==startMon.integerValue){
        m=(int)startDay.integerValue;
    }
    if(year.integerValue==stopYear.integerValue&&mon.integerValue==stopMon.integerValue){
        n=(int)stopDay.integerValue;
    }
    for(int i=m;i<=n;i++){
        [dayArr addObject:[NSNumber numberWithInt:i]];
    }
    return dayArr;
    
}
#pragma mark 判断天数
-(NSInteger)daysForYear:(NSInteger)year andWithMonth:(NSInteger )month{
    NSArray *days=@[@"31",@"28",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31"];
    if((year%4==0)&&(year%400!=0)){
        days=@[@"31",@"29",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31"];;
    }
    
    NSString *daysStr=days[month-1];
    return daysStr.integerValue;
}
#pragma mark 将日期转化为年月日
-(NSArray *)transDateToYearMonDayArr:(NSDate *)date{
    if(date){
        self.f.dateFormat=@"yyyy";
        NSString *year=[self.f stringFromDate:date];
        self.f.dateFormat=@"MM";
        NSString *mon=[self.f stringFromDate:date];
        self.f.dateFormat=@"dd";
        NSString *day=[self.f stringFromDate:date];
        return @[year,mon,day];
    }
    return nil;
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
-(void)setStartDateString:(NSString *)startDateString{
    startDateString=[self getNumberStringFromString:startDateString];
    if(startDateString.length==8){
        self.f.dateFormat=@"yyyyMMdd";
        self.startDate=[self.f dateFromString:startDateString];
    }else if(startDateString.length==6){
        self.f.dateFormat=@"yyyyMM";
        self.startDate=[self.f dateFromString:startDateString];
    }else if(startDateString.length==4){
        self.f.dateFormat=@"MMdd";
        self.startDate=[self.f dateFromString:startDateString];
    }
}
-(void)setStopDateString:(NSString *)stopDateString{
    stopDateString=[self getNumberStringFromString:stopDateString];
    if(stopDateString.length==8){
        self.f.dateFormat=@"yyyyMMdd";
        self.stopDate=[self.f dateFromString:stopDateString];
    }else if(stopDateString.length==6){
        self.f.dateFormat=@"yyyyMM";
        self.stopDate=[self.f dateFromString:stopDateString];
    }else if(stopDateString.length==4){
        self.f.dateFormat=@"MMdd";
        self.stopDate=[self.f dateFromString:stopDateString];
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
-(NSArray *)currentDateArr{
    _currentDateArr=[self transDateToYearMonDayArr:[NSDate date]];
    return _currentDateArr;
}
-(NSDate *)selectedDate{
    if(_selectedDate==nil){
        _selectedDate=[NSDate date];
    }
    return _selectedDate;
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
