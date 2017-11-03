//
//  HViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HViewController.h"
#import "HBaseView.h"
@interface HViewController ()

@end

@implementation HViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItemWithTitle:@"nav-controller-view"];
    [self viewSetUp];
}
-(void)viewSetUp{
    self.view.backgroundColor=[UIColor whiteColor];
    HBaseView *v=[[HBaseView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:v];
}

@end
