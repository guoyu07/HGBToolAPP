//
//  HNav1ViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/27.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HNav1ViewController.h"
#import "HGBControllerTool.h"

@interface HNav1ViewController ()

@end

@implementation HNav1ViewController
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewSetUp];
    [HGBControllerTool createNavigationItemWithTitle:@"导航栏1" andWithTarget:self andWithLeftAction:@selector(returnhandler) inController:self];

}


//返回
-(void)returnhandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UI
-(void)viewSetUp{
    self.view.backgroundColor=[UIColor yellowColor];

}
@end
