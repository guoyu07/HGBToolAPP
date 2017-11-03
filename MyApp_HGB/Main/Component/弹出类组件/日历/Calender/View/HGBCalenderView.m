//
//  HGBCalenderView.m
//  测试
//
//  Created by huangguangbao on 2017/10/18.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCalenderView.h"

#import "HGBCalenderDayView.h"
#import "HGBCalenderWeekView.h"

#import "HGBCalenderTool.h"
#import "HGBCalenderStringTool.h"

#ifndef SYSTEM_VERSION
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
#endif

#ifndef KiOS6Later
#define KiOS6Later (SYSTEM_VERSION >= 6)
#endif

#ifndef KiOS7Later
#define KiOS7Later (SYSTEM_VERSION >= 7)
#endif

#ifndef KiOS8Later
#define KiOS8Later (SYSTEM_VERSION >= 8)
#endif

#ifndef KiOS9Later
#define KiOS9Later (SYSTEM_VERSION >= 9)
#endif

#ifndef KiOS10Later
#define KiOS10Later (SYSTEM_VERSION >= 10)
#endif

@interface HGBCalenderView ()
/**
 表格
 */
@property(strong,nonatomic)UICollectionView *collectionView;
/**
 界面大小
 */
@property(assign,nonatomic)CGRect frameRect;
/**
 周数组
 */
@property(strong,nonatomic)NSArray *weekDataArray;
/**
 日数组
 */
@property(strong,nonatomic)NSMutableArray *dayDataArray;
/**
 按钮集合
 */
@property(strong,nonatomic)NSMutableArray *viewArray;
/**
 标题
 */
@property(strong,nonatomic)UIView *headerView;
/**
 左标签
 */
@property(strong,nonatomic)UIView *leftView;
/**
 右标签
 */
@property(strong,nonatomic)UIView *righttView;
/**
 年左按钮
 */
@property(strong,nonatomic)UIButton *left_leftButton;
/**
 年右按钮
 */
@property(strong,nonatomic)UIButton *left_rightButton;
/**
 月左按钮
 */
@property(strong,nonatomic)UIButton *right_leftButton;
/**
 月右按钮
 */
@property(strong,nonatomic)UIButton *right_rightButton;
/**
标题标签
*/
@property(strong,nonatomic)UILabel *titleLabel;
/**
 年标签
 */
@property(strong,nonatomic)UILabel *yearLabel;
/**
 月标签
 */
@property(strong,nonatomic)UILabel *monthLabel;
/**
 显示年
 */
@property(assign,nonatomic)NSInteger year_show;
/**
 显示月
 */
@property(assign,nonatomic)NSInteger month_show;
/**
 显示的日历第一天周几
 */
@property(assign,nonatomic)NSInteger week_show;
/**
 点击日期
 */
@property(assign,nonatomic)NSDate *date;
/**
 日期解析
 */
@property(strong,nonatomic)NSDateFormatter *dateFormatter;
/**
 选中坐标
 */
@property(assign,nonatomic)NSInteger selectIndex;
@end

@implementation HGBCalenderView

#pragma mark init
/**
 初始化

 @param frame frame
 @return 对象
 */
-(instancetype)initWithFrame:(CGRect)frame{
    CGRect rect=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,frame.size.width);
    self=[super initWithFrame:rect];
    if(self){
        self.frameRect=rect;
        [self viewSetUp];
    }
    return self;
}
#pragma mark view
-(void)viewSetUp{
    if(_style==nil){
        _style=[[HGBCalenderStyle alloc]init];
    }

    self.dateFormatter.dateFormat=@"yyyy";
    self.year_show=[self.dateFormatter stringFromDate:self.showDate].integerValue;
    self.dateFormatter.dateFormat=@"MM";
    self.month_show=[self.dateFormatter stringFromDate:self.showDate].integerValue;


    self.backgroundColor=_style.backgroundColor;

    CGFloat itemHeight=@(self.frameRect.size.height/9).stringValue.integerValue;
    CGFloat itemWidth=@(self.frameRect.size.width/9).stringValue.integerValue;
    self.headerView=[[UIView alloc]initWithFrame:CGRectMake(0, @(0.2*itemHeight).stringValue.integerValue, self.frameRect.size.width, itemHeight)];
    self.headerView.backgroundColor=[UIColor clearColor];


    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frameRect.size.width, itemHeight)];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.textColor=_style.titleColor;
    self.titleLabel.backgroundColor=_style.titleBackColor;
    self.titleLabel.font=[UIFont systemFontOfSize:@(itemHeight*0.7).stringValue.integerValue];

    //左
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, -0.2, @(self.frameRect.size.width*0.5).stringValue.integerValue, itemHeight)];
    self.leftView=leftView;
    leftView.backgroundColor=[UIColor clearColor];



    UIButton *leftButton_left=[UIButton buttonWithType:(UIButtonTypeCustom)];
    [leftButton_left setImage:_style.leftImage forState:(UIControlStateNormal)];
    leftButton_left.frame=CGRectMake(0,@(0.2*leftView.frame.size.height).stringValue.integerValue, @(leftView.frame.size.width*0.2).stringValue.integerValue, @(leftView.frame.size.height*0.6).stringValue.integerValue);
    leftButton_left.tag=10;
    [leftButton_left addTarget:self action:@selector(yearMonthButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [leftView addSubview:leftButton_left];



    UIButton *rightButton_left=[UIButton buttonWithType:(UIButtonTypeCustom)];
    rightButton_left.tag=11;
    [rightButton_left setImage:_style.rightImage forState:(UIControlStateNormal)];
    rightButton_left.frame=CGRectMake(@(leftView.frame.size.width*0.8).stringValue.integerValue,@(0.2*leftView.frame.size.height).stringValue.integerValue, @(leftView.frame.size.width*0.2).stringValue.integerValue, @(leftView.frame.size.height*0.6).stringValue.integerValue);
    [rightButton_left addTarget:self action:@selector(yearMonthButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [leftView addSubview:rightButton_left];



    //右
    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(@(self.frameRect.size.width*0.5).stringValue.integerValue,-0.2, @(self.frameRect.size.width*0.5).stringValue.integerValue, itemHeight)];
    self.righttView=rightView;

    rightView.backgroundColor=[UIColor clearColor];


    self.yearLabel=[[UILabel alloc]initWithFrame:CGRectMake(@(leftView.frame.size.width*0.2).stringValue.integerValue,@(0.2*leftView.frame.size.height).stringValue.integerValue, @(leftView.frame.size.width*0.6).stringValue.integerValue,@(leftView.frame.size.height*0.6).stringValue.integerValue)];
    self.yearLabel.textColor=_style.yearColor;

    self.yearLabel.backgroundColor=_style.yearBackColor;
    self.yearLabel.layer.masksToBounds=YES;
    self.yearLabel.layer.borderWidth=0;
    self.yearLabel.layer.borderColor=[self.backgroundColor CGColor];
    self.yearLabel.textAlignment=NSTextAlignmentCenter;
    self.yearLabel.font=[UIFont systemFontOfSize:@(itemHeight*0.6).stringValue.integerValue];

    [leftView addSubview:self.yearLabel];

    UIButton *leftButton_right=[UIButton buttonWithType:(UIButtonTypeCustom)];
    leftButton_right.tag=20;
    [leftButton_right setImage:_style.leftImage forState:(UIControlStateNormal)];
    leftButton_right.frame=CGRectMake(0,@(0.2*rightView.frame.size.height).stringValue.integerValue, @(rightView.frame.size.width*0.2).stringValue.integerValue, @(rightView.frame.size.height*0.6).stringValue.integerValue);
    [leftButton_right addTarget:self action:@selector(yearMonthButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [rightView addSubview:leftButton_right];



    UIButton *rightButton_right=[UIButton buttonWithType:(UIButtonTypeCustom)];
    rightButton_right.tag=21;
    [rightButton_right setImage:_style.rightImage forState:(UIControlStateNormal)];
    rightButton_right.frame=CGRectMake(rightView.frame.size.width*0.8,0.2*rightView.frame.size.height, rightView.frame.size.width*0.2, rightView.frame.size.height*0.6);
    [rightButton_right addTarget:self action:@selector(yearMonthButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [rightView addSubview:rightButton_right];



    self.monthLabel=[[UILabel alloc]initWithFrame:CGRectMake(@(rightView.frame.size.width*0.2).stringValue.integerValue,@(rightView.frame.size.height*0.2).stringValue.integerValue, @(rightView.frame.size.width*0.6).stringValue.integerValue,@(rightView.frame.size.height*0.6).stringValue.integerValue )];
    self.monthLabel.textColor=_style.monthColor;
    self.monthLabel.font=[UIFont systemFontOfSize:@(itemHeight*0.6).stringValue.integerValue];
    self.monthLabel.backgroundColor=_style.monthBackColor;
    self.monthLabel.textAlignment=NSTextAlignmentCenter;
    self.monthLabel.layer.masksToBounds=YES;
    self.monthLabel.layer.borderWidth=0;
    self.monthLabel.layer.borderColor=[self.backgroundColor CGColor];
    [rightView addSubview:self.monthLabel];

    self.left_leftButton=leftButton_left;
    self.left_rightButton=rightButton_left;
    self.right_leftButton=leftButton_right;
    self.right_rightButton=rightButton_right;

    for(int i=0;i<49;i++){
        CGFloat itemX;
        CGFloat itemY;
        if(_style.titleStyle==HGBCalenderTitleStyleNO){
            itemX=itemWidth*1+i%7*itemWidth;
           itemY=itemHeight*1.5+i/7*itemHeight;
        }else{
            itemX=itemWidth*1+i%7*itemWidth;
            itemY=itemHeight*1.5+i/7*itemHeight;
        }

        if(i<7){
            NSString *weekString;
            if(i<self.weekDataArray.count){
                weekString=self.weekDataArray[i];
            }
            HGBCalenderWeekView *weekview=[[HGBCalenderWeekView alloc]initWithFrame:CGRectMake(itemX, itemY, itemWidth, itemHeight)];
            weekview.weekLabel.text=weekString;
            weekview.backButton.tag=i;
            [weekview.backButton addTarget:self action:@selector(weekButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
            if([weekString isEqualToString:@"周六"]||[weekString isEqualToString:@"周日"]){
                weekview.weekLabel.textColor=_style.weekDayTitleColor;
                weekview.weekLabel.backgroundColor=_style.weekDayTitleBackColor;

            }else{
                weekview.weekLabel.textColor=_style.dayTitleColor;
                weekview.weekLabel.backgroundColor=_style.dayTitleBackColor;
            }
            weekview.layer.masksToBounds=YES;
            weekview.layer.borderColor=[_style.dayTitleBordorColor CGColor];
            weekview.layer.borderWidth=@(itemWidth*0.01).stringValue.integerValue;

            [self addSubview:weekview];
        }else{
            HGBCalenderDayView *dayview=[[HGBCalenderDayView alloc]initWithFrame:CGRectMake(itemX, itemY, itemWidth, itemHeight)];
            dayview.backButton.tag=i-7;
            dayview.layer.masksToBounds=YES;
            if(_style.isShowPrompt){
                dayview.promptLabel.hidden=NO;
            }else{
                dayview.promptLabel.hidden=YES;
            }
            dayview.layer.borderColor=[_style.dayBordorColor CGColor];
            dayview.layer.borderWidth=@(itemWidth*0.01).stringValue.integerValue;

            [dayview.backButton addTarget:self action:@selector(dayButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];

            [self addSubview:dayview];
            [self.viewArray addObject:dayview];
        }
    }
    [self updateView];
}
-(void)yearMonthButtonHandle:(UIButton *)_b{
    NSLog(@"year month click:%ld",_b.tag);
    if(_b.tag==10){
        self.year_show--;
    }else if (_b.tag==11){
        self.year_show++;
    }else if (_b.tag==20){
        self.month_show--;
    }else if (_b.tag==21){
        self.month_show++;
    }
    if(self.month_show==0){
        self.month_show=12;
    }
    if(self.month_show==13){
        self.month_show=1;
    }
    [self updateView];
}
-(void)weekButtonHandle:(UIButton *)_b{
      NSLog(@"week click:%ld",_b.tag);
    NSInteger week;
    if(_style.isWeekHead){
        week=_b.tag+1;
    }else{
        week=_b.tag+2;
        if(week==8){
            week=1;
        }
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(calenderView:didClickWeek:)]){
        [self.delegate calenderView:self didClickWeek:week];
    }
}
-(void)dayButtonHandle:(UIButton *)_b{
    NSLog(@"day click:%ld",_b.tag);


    HGBCalenderDayView *dayview=[self.viewArray objectAtIndex:_b.tag];
    NSInteger day=dayview.dayLabel.text.integerValue;

    if(_b.tag<7&&day>7){
        return;
    }
    if(_b.tag>31&&day<7){
        return;
    }

    if(day>0){
        self.dateFormatter.dateFormat=@"yyyyMMdd";
        self.selectDate=[self.dateFormatter dateFromString:[NSString stringWithFormat:@"%0.4ld%0.2ld%0.2ld",self.year_show,self.month_show,day]];
    }
    [self updateView];
    if(day!=0){
         self.selectIndex=_b.tag;
        if(self.delegate&&[self.delegate respondsToSelector:@selector(calenderView:didFinishWithDate:)]){
           self.dateFormatter.dateFormat=@"yyyyMMdd";
            NSString *dateString=[NSString stringWithFormat:@"%0.4ld%0.2ld%0.2ld",self.year_show,self.month_show,day];
            self.date=[self.dateFormatter dateFromString:dateString];
            [self .delegate calenderView:self didFinishWithDate:self.date];
        }
        if(self.delegate&&[self.delegate respondsToSelector:@selector(calenderView:didFinishWithYear:andWithMonth:andWithDay:andWithWeek:)]){
            NSInteger week=[HGBCalenderTool weekForYear:self.year_show andMonth:self.month_show andDay:day];

            [self.delegate calenderView:self didFinishWithYear:self.year_show andWithMonth:self.month_show andWithDay:day andWithWeek:week];
        }
    }
}
#pragma mark 更新
-(void)updateView{
    //头部UI及基础UI
    if(_style==nil){
        _style=[[HGBCalenderStyle alloc]init];
    }
    self.backgroundColor=_style.backgroundColor;
    if(_style.titleStyle!=HGBCalenderTitleStyleNO){

        if(![self.headerView superview]){
            [self addSubview:self.headerView];
        }
        if(_style.titleStyle==HGBCalenderTitleStyleTitle){
            if(![self.titleLabel superview]){
                [self.headerView addSubview:self.titleLabel];
            }
            self.titleLabel.textColor=_style.titleColor;
            self.titleLabel.backgroundColor=_style.titleBackColor;

            if(![self.titleLabel superview]){
                [self addSubview:self.titleLabel];
            }
        }else{
            if(![self.leftView superview]){
                [self.headerView addSubview:self.leftView];
            }
            if(![self.righttView superview]){
                [self.headerView addSubview:self.righttView];
            }
            if(_style.rightImage){
                [self.left_rightButton setImage:_style.rightImage forState:(UIControlStateNormal)];
                [self.right_rightButton setImage:_style.rightImage forState:(UIControlStateNormal)];
            }
            if(_style.leftImage){
                [self.left_leftButton setImage:_style.leftImage forState:(UIControlStateNormal)];
                [self.right_leftButton setImage:_style.leftImage forState:(UIControlStateNormal)];
            }



            self.yearLabel.textColor=_style.yearColor;

            self.yearLabel.backgroundColor=_style.yearBackColor;

             self.monthLabel.textColor=_style.monthColor;
          self.monthLabel.backgroundColor=_style.monthBackColor;
        }
    }


    if(_promptDic==nil){
        _promptDic=[NSMutableDictionary dictionary];
    }



     self.week_show=[HGBCalenderTool weekForFirstDayInYear:self.year_show andMonth:self.month_show];

    //选中日期 当前日期

    NSDate *currentDate=[NSDate date];
    NSString *selectYear=@"0",*currentYear=@"0",*selectMonth=@"0",*currentMonth=@"0",*selectDay=@"0",*currentDay=@"0";

    self.dateFormatter.dateFormat=@"yyyy";
    if(self.selectDate){
         currentYear=[self.dateFormatter stringFromDate:currentDate];
    }
    selectYear=[self.dateFormatter stringFromDate:self.selectDate];

    self.dateFormatter.dateFormat=@"MM";
    if(self.selectDate){
        selectMonth=[self.dateFormatter stringFromDate:self.selectDate];
    }

    currentMonth=[self.dateFormatter stringFromDate:currentDate];
    self.dateFormatter.dateFormat=@"dd";

    if(self.selectDate){
         selectDay=[self.dateFormatter stringFromDate:self.selectDate];
    }

    currentDay=[self.dateFormatter stringFromDate:currentDate];



    //上一月 下一月

    NSInteger days=[HGBCalenderTool daysForYear:self.year_show andWithMonth:self.month_show];



    NSInteger year_before,month_before,days_before,year_next,month_next,days_next;
    year_before=[HGBCalenderTool getYearForBeforeMonthInYear:self.year_show andMonth:self.month_show];
    year_next=[HGBCalenderTool getYearForNextMonthInYear:self.year_show andMonth:self.month_show];
    month_before=[HGBCalenderTool getMonthForBeforeMonthInYear:self.year_show andMonth:self.month_show];
    month_next=[HGBCalenderTool getMonthForNextMonthInYear:self.year_show andMonth:self.month_show];
    days_before=[HGBCalenderTool daysForYear:year_before andWithMonth:month_before];
    days_next=[HGBCalenderTool daysForYear:year_next andWithMonth:month_next];
    

    self.dateFormatter.dateFormat=@"yyyyMMdd";


    //标题
    if(_style.calenderType==HGBCalenderTypeGregorian){
        self.yearLabel.text=[NSString stringWithFormat:@"%0.4ld年",self.year_show];
        self.monthLabel.text=[NSString stringWithFormat:@"%0.2ld月",self.month_show];
    }else{
        self.yearLabel.text=[NSString stringWithFormat:@"%0.4ld年",self.year_show];
        self.monthLabel.text=[NSString stringWithFormat:@"%0.2ld月",self.month_show];
    }

    if(_style.titleStyle==HGBCalenderTitleStyleTitle){
        self.titleLabel.text=[NSString stringWithFormat:@"%0.4ld年%0.2ld月",self.year_show,self.month_show];
    }
    NSInteger index_start=0,index_end=0;
    BOOL overOverFlag=NO;
    for(int i=0;i<self.viewArray.count;i++){
        HGBCalenderDayView *dayview=self.viewArray[i];
        if(_style.isWeekHead){
            index_start=self.week_show-1;
            index_end=self.week_show-1+days-1;


        }else{
            if(self.week_show==1){
                index_start=6;
                index_end=6+days-1;
            }else{
                index_start=self.week_show-2;
                index_end=self.week_show-2+days-1;
            }
        }
        if(((_style.isWeekHead==NO)&&(i%7==5||i%7==6))||((_style.isWeekHead==YES)&&(i%7==0||i%7==6))){
            dayview.backgroundColor=_style.weekDayBackColor;
            dayview.dayLabel.textColor=_style.weekDayColor;
            dayview.promptLabel.textColor=_style.weekDayColor;
        }else{
            dayview.backgroundColor=_style.normalDayBackColor;
            dayview.dayLabel.textColor=_style.normalDayColor;
            dayview.promptLabel.textColor=_style.normalPromptTextColor;
        }

        if(overOverFlag){
            dayview.dayLabel.text=@"";
            dayview.promptLabel.text=@"";
            continue;
        }
        if(i>index_end&&i%7==0){
            overOverFlag=YES;
            dayview.dayLabel.text=@"";
            dayview.promptLabel.text=@"";
            continue;
        }
        if(i>=index_start&&i<=index_end){
            dayview.backgroundColor=_style.normalDayBackColor;
            dayview.dayLabel.text=[NSString stringWithFormat:@"%ld",i-index_start+1];

        }else if(i<index_start){
          dayview.backgroundColor=_style.overBackColor;
            dayview.promptLabel.textColor=_style.overColor;
            dayview.dayLabel.textColor=_style.overColor;
            if(_style.isShowOver){
                dayview.dayLabel.text=[NSString stringWithFormat:@"%ld",days_before+i-index_start];
            }else{
                dayview.dayLabel.text=@"";
            }

            
        }else{
            dayview.backgroundColor=_style.overBackColor;
            dayview.promptLabel.textColor=_style.overColor;
            dayview.dayLabel.textColor=_style.overColor;
            if(_style.isShowOver){
                dayview.dayLabel.text=[NSString stringWithFormat:@"%ld",i-index_end];
            }else{
                dayview.dayLabel.text=@"";
            }




        }

        if(self.year_show==currentYear.integerValue&&(self.month_show==currentMonth.integerValue)&&(dayview.dayLabel.text.integerValue==currentDay.integerValue)){
            dayview.backgroundColor=_style.currnetBackColor;
            dayview.dayLabel.textColor=_style.currnetDayColor;
            dayview.promptLabel.textColor=_style.currnetPromptTextColor;

        }

        if(self.year_show==selectYear.integerValue&&(self.month_show==selectMonth.integerValue)&&(dayview.dayLabel.text.integerValue==selectDay.integerValue)){
            dayview.backgroundColor=_style.selectBackColor;
            dayview.dayLabel.textColor=_style.selectDayColor;
            dayview.promptLabel.textColor=_style.selectPromptTextColor;
            self.selectIndex=i;

        }

        NSInteger day=dayview.dayLabel.text.integerValue;


        NSDictionary *yearPromptDic,*monthPromptDic;
        NSString *dayPrompt;
        if(i>=index_start&&i<=index_end){

            NSString *chineseDay=[HGBCalenderTool chineseDayForYear:self.year_show andMonth:self.month_show andDay:day];
            if([chineseDay isEqualToString:@"初一"]){
                chineseDay=[HGBCalenderTool chineseMonthForYear:self.year_show andMonth:self.month_show andDay:day];
            }

            yearPromptDic=[_promptDic objectForKey:@(self.year_show)];
            if(yearPromptDic==nil){
                yearPromptDic=[_promptDic objectForKey:@(self.year_show).stringValue];
            }
            if(yearPromptDic){

                monthPromptDic=[yearPromptDic objectForKey:@(self.month_show)];
                if(monthPromptDic==nil){
                    monthPromptDic=[yearPromptDic objectForKey:@(self.month_show).stringValue];
                }
                if(monthPromptDic){
                    dayPrompt=[monthPromptDic objectForKey:@(day)];
                    if(dayPrompt==nil){
                        dayPrompt=[monthPromptDic objectForKey:@(day).stringValue];
                    }
                }

            }

            if(_style.isShowPrompt){
                if(dayPrompt==nil){
                    dayview.promptLabel.text=chineseDay;
                }else{
                    dayview.promptLabel.text=dayPrompt;
                }
            }else{
                dayview.promptLabel.text=@"";
            }


        }else if(i<index_start){
            if(_style.isShowOver){
                NSString *chineseDay=[HGBCalenderTool chineseDayForYear:year_before andMonth:month_before andDay:day];
                if([chineseDay isEqualToString:@"初一"]){
                    chineseDay=[HGBCalenderTool chineseMonthForYear:self.year_show andMonth:self.month_show andDay:day];
                }
                yearPromptDic=[_promptDic objectForKey:@(year_before)];
                if(yearPromptDic==nil){
                    yearPromptDic=[_promptDic objectForKey:@(year_before).stringValue];
                }
                if(yearPromptDic){

                    monthPromptDic=[yearPromptDic objectForKey:@(month_before)];
                    if(monthPromptDic==nil){
                        monthPromptDic=[yearPromptDic objectForKey:@(month_before).stringValue];
                    }
                    if(monthPromptDic){
                        dayPrompt=[monthPromptDic objectForKey:@(dayview.dayLabel.text.integerValue)];
                        if(dayPrompt==nil){
                            dayPrompt=[monthPromptDic objectForKey:@(dayview.dayLabel.text.integerValue).stringValue];
                        }
                    }

                }
                if(dayPrompt==nil){
                    dayview.promptLabel.text=chineseDay;
                }else{
                    dayview.promptLabel.text=dayPrompt;
                }

            }else{
                 dayview.promptLabel.text=@"";
            }

        }else if (i>index_end){
            if(_style.isShowOver){
                NSString *chineseDay=[HGBCalenderTool chineseDayForYear:year_next andMonth:month_next andDay:day];
                if([chineseDay isEqualToString:@"初一"]){
                    chineseDay=[HGBCalenderTool chineseMonthForYear:self.year_show andMonth:self.month_show andDay:day];
                }
                yearPromptDic=[_promptDic objectForKey:@(year_next)];
                if(yearPromptDic==nil){
                    yearPromptDic=[_promptDic objectForKey:@(year_next).stringValue];
                }
                if(yearPromptDic){

                    monthPromptDic=[yearPromptDic objectForKey:@(month_next)];
                    if(monthPromptDic==nil){
                        monthPromptDic=[yearPromptDic objectForKey:@(month_next).stringValue];
                    }
                    if(monthPromptDic){
                        dayPrompt=[monthPromptDic objectForKey:@(dayview.dayLabel.text.integerValue)];
                        if(dayPrompt==nil){
                            dayPrompt=[monthPromptDic objectForKey:@(dayview.dayLabel.text.integerValue).stringValue];
                        }
                    }

                }
                if(dayPrompt==nil){
                    dayview.promptLabel.text=chineseDay;
                }else{
                    dayview.promptLabel.text=dayPrompt;
                }
            }else{
                dayview.promptLabel.text=@"";
            }
        }
    }
}
#pragma mark set
-(void)setPromptDic:(NSMutableDictionary *)promptDic{
    _promptDic=promptDic;
    [self updateView];
}
-(void)setStyle:(HGBCalenderStyle *)style{
    _style=style;
    [self updateView];
}
#pragma mark get
-(NSMutableArray *)viewArray{
    if(_viewArray==nil){
        _viewArray=[NSMutableArray array];
    }
    return _viewArray;
}
-(NSArray *)weekDataArray{
    if(_weekDataArray==nil){
        if(_style==nil){
            _style=[[HGBCalenderStyle alloc]init];
        }
        if(_style.isWeekHead==NO){
            _weekDataArray=@[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
        }else{
            _weekDataArray=@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        }
    }
    return _weekDataArray;
}
-(NSDate *)selectDate{
    if(_selectDate==nil){
        _selectDate=[NSDate date];
    }
    return _selectDate;
}
-(NSDate *)showDate{
    if(_showDate==nil){
        _showDate=[NSDate date];
    }
    return _showDate;
}
-(NSDateFormatter *)dateFormatter{
    if(_dateFormatter==nil){
        _dateFormatter=[[NSDateFormatter alloc]init];
    }
    return _dateFormatter;
}
@end
