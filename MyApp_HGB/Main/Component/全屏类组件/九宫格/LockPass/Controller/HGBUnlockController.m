//
//  HGBUnlockController.m
//  测试
//
//  Created by huangguangbao on 2017/6/28.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBUnlockController.h"
#import "HGBLockPassHeader.h"
#import "HGBLockView.h"
@interface HGBUnlockController ()<HGBLockViewDelegate>
/**
 提示
 */
@property(strong,nonatomic)UILabel *promptLab;
/**
 次数
 */
@property(assign,nonatomic)NSInteger count;
@end

@implementation HGBUnlockController

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetup];//ui
    if(self.setCount==0){
        self.setCount=3;
    }
    self.count=0;
}

#pragma mark viewSetup
-(void)viewSetup{
    
    HGBLockView *lockView=[[HGBLockView alloc]initWithFrame:CGRectMake(0,kHeight-kWidth-400*hScale,kWidth, kWidth)];
    lockView.delegate=self;
    lockView.style=self.style;
    lockView.autoRemoveSelected=YES;
    [self.view addSubview:lockView];
    //背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:self.style.backgrondImage];
    
    
    self.promptLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 160*hScale, kWidth,96*hScale)];
    self.promptLab.textColor=self.style.promptTextColor;
    self.promptLab.text=@"请绘制图形密码";
    self.promptLab.font=[UIFont  systemFontOfSize:28*hScale];
    self.promptLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:self.promptLab];
    
}
//导航栏
-(void)createNavigationItem
{
    self.navigationController.navigationBar.barTintColor=self.style.navColor;
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 34*hScale)];
    titleLab.text=@"请验证图形密码";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=self.style.navTextColor;
    self.navigationItem.titleView=titleLab;
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(returnhandler)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [self.navigationItem.leftBarButtonItem setTintColor:self.style.navTextColor];
}
//返回
-(void)returnhandler{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(unlock:didFinishedWithResult:)]){
        [self.delegate unlock:self  didFinishedWithResult:HGBUnlockStatusCancel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark delegate
- (void)lockView:(HGBLockView *)hvwLockView didFinishedWithPath:(NSString *)path {
//    NSLog(@"%@",path);
    if(path.length<4){
        self.promptLab.text=@"至少连接四个点,请重新输入";
    }else{
        if([self.password isEqualToString:path]){
            self.promptLab.text=@"密码正确!";
            if(self.delegate&&[self.delegate respondsToSelector:@selector(unlock:didFinishedWithResult:)]){
                [self.delegate unlock:self didFinishedWithResult:HGBUnlockStatusSucess];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            
            if(self.count<self.setCount){
                self.count++;
                if(self.count==self.setCount){
                    if(self.delegate&&[self.delegate respondsToSelector:@selector(unlock: didFinishedWithResult:)]){
                        [self.delegate unlock:self didFinishedWithResult:HGBUnlockStatusFail];
                    }
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }else{
                if(self.delegate&&[self.delegate respondsToSelector:@selector(unlock:didFinishedWithResult:)]){
                    [self.delegate unlock:self didFinishedWithResult:HGBUnlockStatusFail];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
            self.promptLab.text=@"密码错误,请重试";
        }
    }
    
}
#pragma mark get
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
