//
//  HGBNotification.m
//  测试
//
//  Created by huangguangbao on 2017/6/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBNotification.h"
@import AVFoundation;

#define Noti_Height 80
#define Font_Size 13

@import UIKit;

@interface HGBNotification()

@property (nonatomic,weak) id<HGBNotificationDelegate> delegate;
/**
 背景view
 */
@property(strong,nonatomic)UIView *backView;
/**
 标题view
 */
@property(strong,nonatomic)UIView *titleView;
/**
 消息view
 */
@property(strong,nonatomic)UIView *notiView;
/**
 标题背景颜色
 */
@property(strong,nonatomic)  UIColor *titleBackColor;
/**
 消息背景颜色
 */
@property(strong,nonatomic)  UIColor *msgBackColor;
/**
 消息标题颜色
 */
@property(strong,nonatomic)  UIColor *titleColor;
/**
 消息颜色
 */
@property(strong,nonatomic)  UIColor *msgColor;
/**
 消息时间颜色
 */
@property(strong,nonatomic)  UIColor *timeColor;

@end
@implementation HGBNotification
static HGBNotification *noti;
UIWindow *noti_window;
NSTimer *timer;
static BOOL backgroundNotiEnalble = NO;
static BOOL playSystemSound = YES;
static NSDictionary *infoPlist;


+ (HGBNotification *)shareNitifacation{
    
    if (noti == nil) {
        noti = [[HGBNotification alloc]init];
    }
    return noti;
    
}





+ (void)hgb_notificationWithTitle:(NSString *)title msg:(NSString *)msg{
    [HGBNotification shareNitifacation];
    
//    if (![[[UIApplication sharedApplication] currentUserNotificationSettings] types])
//        return;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        infoPlist = [NSDictionary dictionaryWithContentsOfFile:path];
    });
    //横竖屏适配
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    if (noti_window) noti_window.hidden = YES;
    noti_window = [[UIWindow alloc]init];
    CGRect noti_window_frame;
    CGFloat win_x = 0;
    CGFloat win_y = 0;
    CGFloat win_w = screenFrame.size.width;
    CGFloat win_h = Noti_Height+13;
    noti_window_frame = CGRectMake(win_x, win_y, win_w, win_h);
    
    noti_window.frame = CGRectMake(win_x, -win_h, win_w, win_h);    noti_window.hidden = NO;
    noti_window.backgroundColor = [UIColor clearColor];
    noti_window.windowLevel = UIWindowLevelAlert;
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(13, 13, win_w-26, win_h)];
    backView.backgroundColor=[UIColor clearColor];
    backView.layer.masksToBounds=YES;
    backView.layer.cornerRadius=10;
    backView.tag=20;
    [noti_window addSubview:backView];
    
    
    
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0,0, win_w -26, Noti_Height * 0.5)];
    if(!noti.titleBackColor){
        titleView.backgroundColor=[UIColor colorWithRed:190.0/256 green:212.0/256 blue:119.0/256 alpha:1];
    }else{
        titleView.backgroundColor=noti.titleBackColor;
    }

    titleView.tag=21;
    [backView addSubview:titleView];
    
    
    UIView *notiView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), win_w-26, win_h-Noti_Height * 0.5)];
    notiView.tag=22;
    noti.notiView=notiView;
    if(!noti.msgBackColor){
        notiView.backgroundColor=[UIColor colorWithRed:190.0/256 green:212.0/256 blue:119.0/256 alpha:1];
    }else{
        notiView.backgroundColor=noti.msgBackColor;
    }

    [backView addSubview:notiView];
    
    
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, Noti_Height * 0.08, Noti_Height * 0.34, Noti_Height * 0.34)];
    NSString *iconName = [infoPlist[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"] lastObject];
    imgView.image = [UIImage imageNamed:iconName];
    imgView.tag=30;
    if (imgView.image == nil) {
        imgView.backgroundColor = [UIColor whiteColor];
    }
    imgView.layer.cornerRadius = 5;
    imgView.layer.masksToBounds = YES;
    [titleView addSubview:imgView];
    NSString *msg_title;
    if (title == nil || [title isEqualToString:@""]) {
        msg_title = infoPlist[@"CFBundleDisplayName"];
    }else{
        msg_title = title;
    }
    if (msg_title == nil || [msg_title isEqualToString:@""]) {
        msg_title = @"message";
    }
    UIFont *title_font = [UIFont systemFontOfSize:Font_Size weight:normal];
    CGSize title_size = [msg_title sizeWithAttributes:@{NSFontAttributeName:title_font}];
    
    CGFloat title_maxWidth = noti_window.frame.size.width - (CGRectGetMaxX(imgView.frame) + 5) - 40;
    
    if (title_size.width > title_maxWidth) {
        title_size.width = title_maxWidth;
    }
    
    UILabel *noti_title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 5, imgView.center.y - title_size.height / 2.0f, title_size.width, title_size.height)];
    noti_title.font = title_font;
    noti_title.text = msg_title;
    if(noti.titleColor){
        noti_title.textColor=noti.titleColor;
    }else{
        noti_title.textColor = [UIColor colorWithRed:102.0/256 green:102.0/256 blue:1102.0/256 alpha:1];
    }

    noti_title.tag=31;
    [titleView addSubview:noti_title];
    
    UILabel *title_now = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(titleView.frame)-56, noti_title.frame.origin.y,40, noti_title.frame.size.height)];
    title_now.textColor = [UIColor blackColor];
    titleView.tag=32;
    noti.titleView=titleView;
    title_now.text = @"现在";
    title_now.font = [UIFont systemFontOfSize:Font_Size - 1];
    if(noti.timeColor){
        title_now.textColor=noti.timeColor;
    }else{
        title_now.textColor = [UIColor colorWithRed:102.0/256 green:102.0/256 blue:1102.0/256 alpha:1];
    }
    [titleView addSubview:title_now];
    
    UILabel *noti_msg = [[UILabel alloc]initWithFrame:CGRectMake(15,3, CGRectGetWidth(notiView.frame) -30, noti_window.frame.size.height - CGRectGetHeight(notiView.frame) - 7)];
    noti_msg.font = [UIFont systemFontOfSize:Font_Size];
    noti_msg.text = msg;
    if(noti.msgColor){
        noti_msg.textColor=noti.msgColor;
    }else{
         noti_msg.textColor = [UIColor blackColor];
    }

    noti_msg.textAlignment=NSTextAlignmentLeft;
    noti_msg.numberOfLines = 2;
    noti_msg.tag = 10;
    
    [notiView addSubview:noti_msg];
    
    
    
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:[self class] action:@selector(tap:)];
    [noti_window addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipe_down = [[UISwipeGestureRecognizer alloc]initWithTarget:[self class] action:@selector(swipe_down:)];
    swipe_down.numberOfTouchesRequired = 1;
    swipe_down.direction = UISwipeGestureRecognizerDirectionDown;
    [noti_window addGestureRecognizer:swipe_down];
    
    UISwipeGestureRecognizer *swipe_up = [[UISwipeGestureRecognizer alloc]initWithTarget:[self class] action:@selector(swipe_up:)];
    swipe_up.numberOfTouchesRequired = 1;
    swipe_up.direction = UISwipeGestureRecognizerDirectionUp;
    [noti_window addGestureRecognizer:swipe_up];
    
    CGRect frame = noti_window.frame;
    frame.origin.y = 0;
    
    if (playSystemSound) [[self class] playSystemSound];
    if (backgroundNotiEnalble) [[self class] notification_systemWithTitle:title msg:msg];
    
    [UIView animateWithDuration:0.3 animations:^{
        noti_window.frame = noti_window_frame;
    } completion:^(BOOL finished) {
        [timer invalidate];
        timer = nil;
        timer = [NSTimer timerWithTimeInterval:3 target:[self class] selector:@selector(dismiss) userInfo:nil repeats:NO];
        NSRunLoop *runloop = [NSRunLoop mainRunLoop];
        [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    }];
}

+ (void)dismiss{
    
    CGRect frame = CGRectMake(0, -noti_window.frame.size.height, noti_window.frame.size.width, noti_window.frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        noti_window.frame = frame;
    } completion:^(BOOL finished) {
        noti_window.hidden = YES;
        noti_window = nil;
        [timer invalidate];
        timer = nil;
    }];
}

+ (void)swipe_down:(UISwipeGestureRecognizer *)swipe{
    [timer invalidate];
    timer = [NSTimer timerWithTimeInterval:3 target:[self class] selector:@selector(dismiss) userInfo:nil repeats:NO];
    NSRunLoop *runloop = [NSRunLoop mainRunLoop];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    timer = nil;
    UIView *backView=[noti_window viewWithTag:20];
    UIView *titleView=[backView viewWithTag:21];
    UILabel *nowLabel=[titleView viewWithTag:32];
    UIView *notiView=[backView viewWithTag:22];
    UILabel *label = [notiView viewWithTag:10];
    label.numberOfLines = 0;
    CGFloat height = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.height;
    
    CGRect window_frame = noti_window.frame;
    window_frame.size.height = window_frame.size.height + height -Noti_Height*0.5+7;
    
    
    CGRect label_frame = label.frame;
    label_frame.size.height = height;
    
    
    CGRect backView_frame=backView.frame;
    backView_frame.size.height=window_frame.size.height+13;
    
    
    CGRect notiView_frame=notiView.frame;
    notiView_frame.size.height=label_frame.size.height+7;
    
    
    [UIView animateWithDuration:0.1 animations:^{
        noti_window.frame = window_frame;
        backView.frame=backView_frame;
        backView.layer.masksToBounds=YES;
        backView.layer.cornerRadius=10;
        backView.tag=20;
        notiView.frame=notiView_frame;
        label.frame = label_frame;
        
        [nowLabel removeFromSuperview];
        UIButton *closeButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
        [closeButton setImage:[UIImage imageNamed:@"HGBNotificationBundle.bundle/icon_normal_close.png"] forState:(UIControlStateNormal)];
        closeButton.frame=CGRectMake(CGRectGetWidth(titleView.frame)-CGRectGetHeight(titleView.frame)+7+15,3, CGRectGetHeight(titleView.frame)-3, CGRectGetHeight(titleView.frame)-3);
        [closeButton addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchDown)];
        [titleView addSubview:closeButton];
        
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)swipe_up:(UISwipeGestureRecognizer *)swipe{
    [HGBNotification dismiss];
}

+ (void)tap:(UIGestureRecognizer*)tap{
    
    if([[[self class] shareNitifacation].delegate respondsToSelector:@selector(notification:didClickWithMsg:)]){
        UILabel *label = [noti_window viewWithTag:10];
        [[[self class] shareNitifacation].delegate notification:[HGBNotification shareNitifacation] didClickWithMsg:label.text];
    }
    [[self class] dismiss];
}

+ (void)notification_systemWithTitle:(NSString *)title msg:(NSString *)msg{
    
    UILocalNotification *noti = [[UILocalNotification alloc]init];
    noti.alertTitle = title;
    noti.alertBody = msg;
    noti.fireDate = [NSDate date];
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
    
}

+ (void)playSystemSound{
    
    AudioServicesPlayAlertSound(1012);
    
}
/**
 *  设置代理
 *
 *  @param delegate 代理对象
 */
+ (void)setDelegate:(id<HGBNotificationDelegate>)delegate{

    [[self class] shareNitifacation].delegate = delegate;
}
/**
 *  设置通知栏是否显示(容易递归,建议使用默认)
 *
 *  @param enable 默认为不显示
 */
+ (void)setBackgroundNotiEnable:(BOOL)enable{
    
    backgroundNotiEnalble = enable;
    
}

/**
 *  设置是否播放系统声音
 *
 *  @param enable 默认为播放
 */
+ (void)setPlaySystemSound:(BOOL)enable{
    
    playSystemSound = enable;
    
}
/**
 *  设置消息背景颜色
 *
 *  @param msgBackColor 背景颜色
 */
+ (void)setMsgBackGroundColor:(UIColor*) msgBackColor{
    [HGBNotification shareNitifacation];
    noti.msgBackColor=msgBackColor;

}
/**
 *  设置标题背景颜色
 *
 *  @param titleBackColor 背景颜色
 */
+ (void)setTitleBackGroundColor:(UIColor*) titleBackColor{
     [HGBNotification shareNitifacation];
    noti.titleBackColor=titleBackColor;

}
/**
 *  设置时间颜色
 *
 *  @param timeColor 时间颜色
 */
+ (void)setTimeColor:(UIColor*) timeColor{
    [HGBNotification shareNitifacation];
    noti.timeColor=timeColor;
}
/**
 *  设置消息颜色
 *
 *  @param msgColor 背景颜色
 */
+ (void)setMsgColor:(UIColor*)msgColor{
    [HGBNotification shareNitifacation];
    noti.msgColor=msgColor;
}
/**
 *  设置标题颜色
 *
 *  @param titleColor 标题颜色
 */
+ (void)setTitleColor:(UIColor*) titleColor{
    [HGBNotification shareNitifacation];
    noti.titleColor=titleColor;
}
@end
