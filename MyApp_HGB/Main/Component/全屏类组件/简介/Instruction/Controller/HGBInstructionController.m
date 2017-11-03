//
//  HGBInstructionController.m
//  CTTX
//
//  Created by huangguangbao on 2017/3/3.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBInstructionController.h"
#import "HGBInstructionView.h"
#import "HGBInstructionHeader.h"
@interface HGBInstructionController ()
/**
 view
 */
@property(strong,nonatomic)HGBInstructionView *showView;
@end

@implementation HGBInstructionController
#pragma mark life
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _showView=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewSetUp];//UI
    
}
#pragma mark 导航栏
-(void)createNavigationItemWithTitle:(NSString *)title
{
    //导航栏
   [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1]];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=title;
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;
    
    //左键
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(returnhandler)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}
//返回
-(void)returnhandler{
    if(self.navigationController){
        NSArray *vcs=self.navigationController.viewControllers;
        if(self==vcs[0]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark viewSetUp
-(void)viewSetUp{
    self.showView=[[HGBInstructionView alloc]initWithFrame:self.view.bounds andWithTitle:self.name andWithSubTitles:self.subTitles andWithPrompt:self.promptStr];
    self.showView.name=self.name;
    self.showView.promptStr=self.promptStr;
    [self.view addSubview:self.showView];
}
@end
