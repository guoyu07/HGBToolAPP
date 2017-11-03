//
//  HGBKeybordController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBKeybordController.h"
#import "HGBCustomKeyBord.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0





/**
 名称:键盘组件


 调用:1.HGBCustomKeyBord 扫描界面
 2.HGBCustomKeyBordType  键盘类型
 3.HGBCustomKeyBordShowType 键盘样式
 3.HGBCustomKeyBordDelegate代理
 customKeybordReturnMessage:返回键盘输入结果

 4. popKeyBordWithType:(HGBCustomKeyBordShowType)showType inParent:(UIViewController *)parent 弹出键盘
 text.inputView 弹出键盘

 功能:自定义键盘：数字，字母，数字字母，字母数字，数字字母标点，字母数字标点
 无标题，有标题，文字，密码，支付密码 提供按键返回加密

 framework:
 UIKit.framework
 AudioToolbox.framework
 Security.framework
 */
@interface HGBKeybordController ()<HGBCustomKeyBordDelegate>

@end

@implementation HGBKeybordController
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetUp];//UI

}
#pragma mark 导航栏
//导航栏
-(void)createNavigationItem
{
    //导航栏
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0/256 green:191.0/256 blue:256.0/256 alpha:1];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0.0/256 green:191.0/256 blue:256.0/256 alpha:1]];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=@"自定义键盘";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;


    //左键
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回"  style:UIBarButtonItemStylePlain target:self action:@selector(returnhandler)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -15, 0, 5)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

}
//返回
-(void)returnhandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UI
-(void)viewSetUp{
    self.view.backgroundColor=[UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale,64+5, kWidth-60*wScale, 30)];
    label.text=@"键盘keybordType改变:";
    [self.view addSubview:label];

    for(int i=0;i<6;i++){
        UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(30*wScale,64+40+36*i, kWidth-60*wScale, 30)];
        text.backgroundColor=[UIColor whiteColor];
        text.layer.masksToBounds=YES;
        text.layer.borderColor=[[UIColor grayColor]CGColor];
        text.layer.borderWidth=1;
        text.layer.cornerRadius=5;

        [self.view addSubview:text];

        HGBCustomKeyBord *keybord=[HGBCustomKeyBord instance];
        if(i==0){
            keybord.keybordType=HGBCustomKeyBordType_Num;
            text.placeholder=@"数字键盘";
        }else if (i==1){
            keybord.keybordType=HGBCustomKeyBordType_Word;
            text.placeholder=@"字母键盘";
        }else if (i==2){
            keybord.keybordType=HGBCustomKeyBordType_NumWord;
            text.placeholder=@"数字字母键盘";
        }else if (i==3){
            keybord.keybordType=HGBCustomKeyBordType_WordNum;
            text.placeholder=@"字母数字键盘";

        }else if (i==4){
            keybord.keybordType=HGBCustomKeyBordType_NumWordSymbol;
            text.placeholder=@"数字字母标点键盘";
        }else if (i==5){
            keybord.keybordType=HGBCustomKeyBordType_WordNumSymbol;
            text.placeholder=@"字母数字标点键盘";
        }
        text.inputView=keybord;
    }

    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale,64+40+36*6+10, kWidth-60*wScale, 30)];
    label2.text=@"键盘以POP的形式弹出时:keybordShowType改变:";
    [self.view addSubview:label2];

    for(int i=0;i<5;i++){
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(30*wScale,64+40+36*6+10+40+36*i, kWidth-60*wScale, 30)];
        button.backgroundColor=[UIColor blueColor];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        button.layer.masksToBounds=YES;
        button.layer.borderColor=[[UIColor grayColor]CGColor];
        button.layer.borderWidth=1;
        button.layer.cornerRadius=5;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        button.tag=i;

        [self.view addSubview:button];

        if (i==0){

            [button setTitle:@"无标题" forState:(UIControlStateNormal)];

        }else if (i==1){

           [button setTitle:@"普通" forState:(UIControlStateNormal)];
        }else if (i==2){

            [button setTitle:@"文本" forState:(UIControlStateNormal)];

        }else if (i==3){

           [button setTitle:@"密码" forState:(UIControlStateNormal)];
        }else if (i==4){
            [button setTitle:@"支付密码" forState:(UIControlStateNormal)];
        }


    }


}
-(void)buttonAction:(UIButton *)_b{
    HGBCustomKeyBord *keybord=[HGBCustomKeyBord instance];
    keybord.delegate=self;
    if (_b.tag==0){
        keybord.keybordShowType=HGBCustomKeyBordShowType_NoTitle;


    }else if (_b.tag==1){
        keybord.keybordShowType=HGBCustomKeyBordShowType_Common;

    }else if (_b.tag==2){
        keybord.keybordShowType=HGBCustomKeyBordShowType_Text;


    }else if (_b.tag==3){
        keybord.keybordShowType=HGBCustomKeyBordShowType_Pass;

    }else if (_b.tag==4){
        keybord.keybordShowType=HGBCustomKeyBordShowType_PayPass;

    }
    [keybord popKeyBordInParent:self];
}
-(void)customKeybord:(HGBCustomKeyBord *)keybord didReturnMessage:(NSString *)message{
    NSLog(@"%@",message);
}
@end
