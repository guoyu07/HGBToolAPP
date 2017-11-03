//
//  HGBBaseViewController.m
//  测试
//
//  Created by huangguangbao on 2017/6/29.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBaseViewController.h"
#import "HGBModalTransitionAnimation.h"



#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0

@interface HGBBaseViewController ()<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>
/**
 模态动画
 */
@property(nonatomic,strong)HGBModalTransitionAnimation *animation;
/**
 标题标签
 */
@property(nonatomic,strong)UILabel *titleLab;
@end

@implementation HGBBaseViewController
#pragma mark life
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground)name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground)name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching)name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.animation=[[HGBModalTransitionAnimation alloc]init];
}
/**
 登录状态
 */
-(void)applicationDidFinishLaunching{
    NSLog(@"DidFinishLaunching");
}
/**
 将进入前台
 */
- (void)applicationWillEnterForeground{
    NSLog(@"WillEnterForeground");
}
/**
 进入后台
 */
-(void)applicationDidEnterBackground{
    NSLog(@"DidEnterBackground");
}
/**
 将进入后台
 */
-(void)applicationWillResignActive{
    NSLog(@"WillResignActive");
}
/**
 进入前台
 */
-(void)applicationDidBecomeActive{
    NSLog(@"DidBecomeActive");
}

#pragma mark 导航栏
//导航栏
-(void)createNavigationItemWithTitle:(NSString *)title
{
    //导航栏
    self.navigationController.navigationBar.barTintColor=[UIColor redColor];
    [[UINavigationBar appearance]setBarTintColor:[UIColor redColor]];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=title;
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;
    
    //左键
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonHandle:)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
}
//返回
#pragma mark handle
//左按钮
-(void)leftButtonHandle:(UIBarButtonItem *)_b{
    UIViewController *rootVC=self.navigationController.childViewControllers[0];
    if([self.parentViewController isKindOfClass:[UINavigationController class]]){
        if(self==rootVC){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//右按钮
-(void)rightButtonHandle:(UIBarButtonItem *)_b{
}

#pragma mark set
/**
 导航栏背景颜色设置

 @param navColor 颜色
 */
-(void)setNavColor:(UIColor *)navColor{
     self.navigationController.navigationBar.barTintColor=navColor;
}

/**
 设置导航栏背景图片

 @param navImage 导航栏背景图片
 */
-(void)setNavImage:(UIImage *)navImage{
    [self.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
}




/**
 设置导航栏标题

 @param navTitle 导航栏标题
 */
-(void)setNavTitle:(NSString *)navTitle{
    if(![self.titleLab superview]){
        self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    }
    self.titleLab.font=[UIFont boldSystemFontOfSize:16];
    self.titleLab.text=navTitle;
    self.titleLab.textAlignment=NSTextAlignmentCenter;
    self.titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=self.titleLab;
}
/**
 设置导航栏标题颜色

 @param navTitleColor 导航栏颜色
 */
-(void)setNavTitleColor:(UIColor *)navTitleColor{
    if(![self.titleLab superview]){
        self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    }
    self.titleLab.textColor=navTitleColor;
}

/**
 设置导航栏标题view

 @param navTitleView 标题view
 */
-(void)setNavTitleView:(UIView *)navTitleView{
     self.navigationItem.titleView=navTitleView;
}


/**
 设置导航栏左按钮标题

 @param leftButtonTitle 导航栏左按钮标题
 */
-(void)setLeftButtonTitle:(NSString *)leftButtonTitle{
    //左键
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:leftButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonHandle:)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    if(!_leftButtonTitleColor){
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    }
    
}
/**
 设置导航栏左按钮标题颜色

 @param leftButtonTitleColor 导航栏左按钮标题颜色
 */
-(void)setLeftButtonTitleColor:(UIColor *)leftButtonTitleColor{
    _leftButtonTitleColor=leftButtonTitleColor;
    [self.navigationItem.leftBarButtonItem setTintColor:leftButtonTitleColor];
}
/**
 设置导航栏左按钮图片

 @param leftButtonImage 导航栏左按钮图片
 */
-(void)setLeftButtonImage:(UIImage *)leftButtonImage{
    //左键
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[leftButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonHandle:)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}

/**
 设置导航栏左view

 @param leftView 导航栏左view
 */
-(void)setLeftView:(UIView *)leftView{
    
    //左键
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftView];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}




/**
 设置导航栏右按钮标题
 
 @param rightButtonTitle 导航栏右按钮标题
 */
-(void)setRightButtonTitle:(NSString *)rightButtonTitle{
    //右键
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:rightButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonHandle:)];
    [self.navigationItem.rightBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    if(!_rightButtonTitleColor){
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    }
    
}
/**
 设置导航栏右按钮标题颜色
 
 @param rightButtonTitleColor 导航栏右按钮标题颜色
 */
-(void)setRightButtonTitleColor:(UIColor *)rightButtonTitleColor{
    _leftButtonTitleColor=rightButtonTitleColor;
    [self.navigationItem.leftBarButtonItem setTintColor:rightButtonTitleColor];
}
/**
 设置导航栏右按钮图片
 
 @param rightButtonImage 导航栏右按钮图片
 */
-(void)setRightButtonImage:(UIImage *)rightButtonImage{
    //右键
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[rightButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonHandle:)];
    [self.navigationItem.rightBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

/**
 设置导航栏右view
 
 @param rightView 导航栏右view
 */
-(void)setRightView:(UIView *)rightView{
    
    //右键
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}
#pragma mark 模态动画代理
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _animation.animationType = HGBAnimationTypePresent;
    return _animation;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _animation.animationType = HGBAnimationTypeDismiss;
    return _animation;
    
}

@end
