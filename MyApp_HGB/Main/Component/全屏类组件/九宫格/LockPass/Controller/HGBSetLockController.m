//
//  HGBSetLockController.m
//  测试
//
//  Created by huangguangbao on 2017/6/28.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBSetLockController.h"
#import "HGBLockView.h"
#import "HGBLockPassHeader.h"

@interface HGBSetLockController ()<HGBLockViewDelegate>
/**
 提示
 */
@property(strong,nonatomic)UILabel *promptLab;
/**
 取消按钮
 */
@property(strong,nonatomic)UIButton *cancelButton;
/**
 确定按钮
 */
@property(strong,nonatomic)UIButton *confirmButton;
/**
 密码1
 */
@property(strong,nonatomic)NSString *pass1;
/**
 密码2
 */
@property(strong,nonatomic)NSString *pass2;
/**
 密码
 */
@property(strong,nonatomic)NSString *password;

@property(nonatomic, strong)NSString *pass;
/**
 背景
 */
@property(nonatomic,strong)HGBLockView *backView;
@end

@implementation HGBSetLockController

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetup];//ui
    
}

#pragma mark viewSetup
-(void)viewSetup{
    
    HGBLockView *lockView=[[HGBLockView alloc]initWithFrame:CGRectMake(0,kHeight-kWidth-400*hScale,kWidth, kWidth)];
    lockView.style=self.style;
    lockView.delegate=self;
    self.backView=lockView;
    [self.view addSubview:lockView];
    //背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:self.style.backgrondImage];
    NSLog(@"%@",self.style.backgrondImage);
    
    
    self.promptLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 160*hScale, kWidth,96*hScale)];
    self.promptLab.textColor=self.style.promptTextColor;
    self.promptLab.text=@"请绘制图形密码";
    self.promptLab.font=[UIFont  systemFontOfSize:28*hScale];
    self.promptLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:self.promptLab];
    
    self.cancelButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.cancelButton.frame=CGRectMake(80*wScale,kHeight-300*hScale, 255*wScale, 96*hScale);
    [self.cancelButton setTitle:@"返回" forState:(UIControlStateNormal)];
    [self.cancelButton setTitleColor:self.style.buttonEnableForeColor forState:(UIControlStateNormal)];
    self.cancelButton.backgroundColor=self.style.buttonEnableBackColor;
    [self.cancelButton addTarget:self action:@selector(cancelButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    self.confirmButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.confirmButton.frame=CGRectMake(415*wScale,kHeight-300*hScale, 255*wScale, 96*hScale);
    [self.confirmButton setTitle:@"继续" forState:(UIControlStateNormal)];
    [self.confirmButton setTitleColor:self.style.buttonUnableForeColor forState:(UIControlStateNormal)];
    self.confirmButton.backgroundColor=self.style.buttonUnableBackColor;
    self.confirmButton.enabled=NO;
    [self.confirmButton addTarget:self action:@selector(confirmButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    if(self.pass==nil||self.pass.length==0){
        [self.view addSubview:self.cancelButton];
        [self.view addSubview:self.confirmButton];
    }else{
        self.promptLab.text=@"取消图形锁屏";
    }
    
    
    
}
//导航栏
-(void)createNavigationItem
{
    self.navigationController.navigationBar.barTintColor=self.style.navColor;
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 34*hScale)];
    if(self.pass==nil||self.pass.length==0){
        titleLab.text=@"设置图形密码";
    }else{
        titleLab.text=@"取消图形密码";
    }
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=self.style.navTextColor;
    self.navigationItem.titleView=titleLab;
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(returnhandler)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [self.navigationItem.leftBarButtonItem setTintColor:self.style.navTextColor];
}
//返回
-(void)returnhandler{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(lockSetDidCanceled:)]){
        [self.delegate lockSetDidCanceled:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark handle
-(void)cancelButtonHandle:(UIButton *)_b{
    NSLog(@"cancel");
    if([_b.titleLabel.text isEqualToString:@"返回"]){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(lockSetDidCanceled:)]){
            [self.delegate lockSetDidCanceled:self];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if([_b.titleLabel.text isEqualToString:@"重试"]){
        self.pass1=@"";
        self.pass2=@"";
        [self.confirmButton setTitle:@"继续" forState:(UIControlStateNormal)];
        [self.confirmButton setTitleColor:self.style.buttonUnableForeColor forState:(UIControlStateNormal)];
        self.confirmButton.backgroundColor=self.style.buttonUnableBackColor;
        [self.cancelButton setTitle:@"返回" forState:(UIControlStateNormal)];
        self.promptLab.text=@"请绘制图形密码";
    }
    [self.backView removeSelector];
}
-(void)confirmButtonHandle:(UIButton *)_b{
    NSLog(@"confirm");
    if([_b.titleLabel.text isEqualToString:@"继续"]){
        
        self.pass1=self.password;
        [self.confirmButton setTitle:@"确定" forState:(UIControlStateNormal)];
        [self.confirmButton setTitleColor:self.style.buttonEnableForeColor forState:(UIControlStateNormal)];
        self.confirmButton.backgroundColor=self.style.buttonEnableBackColor;
        self.confirmButton.enabled=NO;
        self.promptLab.text=@"请再次输入图形密码";
        [self.cancelButton setTitle:@"重试" forState:(UIControlStateNormal)];
    }
    if([_b.titleLabel.text isEqualToString:@"确定"]){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(lockSet:didFinishedWithPath:)]){
            [self.delegate lockSet:self didFinishedWithPath:self.password];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.backView removeSelector];
}
#pragma mark delegate
- (void)lockView:(HGBLockView *)hvwLockView didFinishedWithPath:(NSString *)path {
    self.password=@"";
    
    if((self.pass1.length==0||self.pass1==nil)&&(self.pass2.length==0||self.pass2==nil)){
        if(path.length<4){
            self.promptLab.text=@"至少连接四个点,请重新输入";
        }else{
            self.promptLab.text=@"请继续或重试";
            [self.cancelButton setTitle:@"重试" forState:(UIControlStateNormal)];
            self.password=path;
            self.confirmButton.enabled=YES;
            [self.confirmButton setTitleColor:self.style.buttonEnableForeColor forState:(UIControlStateNormal)];
            self.confirmButton.backgroundColor=self.style.buttonEnableBackColor;
        }
        
    }else if(self.pass2.length==0||self.pass2==nil){
        if([self.pass1 isEqualToString:path]){
            self.password=path;
            self.confirmButton.enabled=YES;
            [self.confirmButton setTitleColor:self.style.buttonEnableForeColor forState:(UIControlStateNormal)];
            self.confirmButton.backgroundColor=self.style.buttonEnableBackColor;
            self.promptLab.text=@"两次输入一致!";
        }else{
            self.promptLab.text=@"两次输入不一致,请重试!";
            [self.backView removeSelector];
        }
    }
}
#pragma mark get
-(NSString *)pass{
    if(_pass==nil){
        _pass=[NSString string];
    }
    return _pass;
}
-(HGBLockPassStyle *)style{
    if(_style==nil){
        _style=[[HGBLockPassStyle alloc]init];
        _style.backgrondImage=[UIImage imageNamed:@"HGBLockPass.bundle/Home_refresh_bg"];
        _style.navColor=[UIColor colorWithRed:25.0/256 green:41.0/256 blue:60.0/256 alpha:1];
        _style.navTextColor=[UIColor whiteColor];
        _style.promptTextColor=[UIColor whiteColor];
        _style.buttonUnableForeColor=[UIColor colorWithRed:187.0/256 green:187.0/256 blue:191.0/256 alpha:1];
        _style.buttonUnableBackColor=[UIColor colorWithRed:230.0/256 green:230.0/256 blue:230.0/256 alpha:1];
        _style.buttonEnableBackColor=[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1];
        _style.buttonEnableForeColor=[UIColor whiteColor];
        _style.pathColor=[UIColor redColor];
        _style.buttonSelectImage=[UIImage imageNamed:@"HGBLockPass.bundle/gesture_node_highlighted"];
        _style.buttonUnSelectImage=[UIImage imageNamed:@"HGBLockPass.bundle/gesture_node_normal"];
        
    }
    return _style;
}
@end
