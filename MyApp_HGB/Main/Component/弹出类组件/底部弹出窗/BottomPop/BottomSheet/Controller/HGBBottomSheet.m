//
//  HGBBottomSheet.m
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBottomSheet.h"
#import "HGBBottomCell.h"
#import "HGBBottomPopHeader.h"

#define identify_bottomsheet @"bottomsheet"


@interface HGBBottomSheet ()
/**
 父控制器
 */
@property (strong,nonatomic)UIViewController *parent;
@property(strong,nonatomic)id<HGBBottomSheetDelegate>delegate;
/**
 根控制器
 */
@property(strong,nonatomic)UIWindow *window;
/**
 样式
 */
@property(assign,nonatomic)NSUInteger style;
/**
 灰层
 */
@property(strong,nonatomic)UIButton *grayHeaderView;

@end

@implementation HGBBottomSheet
static HGBBottomSheet *obj=nil;
#pragma mark init

+(instancetype)instanceWithDelegate:(id<HGBBottomSheetDelegate>)delegate InParent:(UIViewController *)parent
{
    return [[[self class]alloc]initWithDelegate:delegate InParent:parent];
}

-(instancetype)initWithDelegate:(id<HGBBottomSheetDelegate>)delegate InParent:(UIViewController *)parent
{
    self=[super init];
    if(self){
        self.delegate=delegate;
        self.parent=parent;
    }
    return self;
}

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
     [self viewSetUp];
}


#pragma mark viewSetUp
-(void)viewSetUp{
    [self.tableView registerClass:[HGBBottomCell class] forCellReuseIdentifier:identify_bottomsheet];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=[UIColor colorWithRed:245.0/256 green:242.0/256 blue:242.0/256 alpha:1];
    self.tableView.alpha=1;
    self.tableView.scrollEnabled=NO;
    self.view.frame=CGRectMake(0,kHeight+30,kWidth,202);
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(section==0)
    {
      return self.titles.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61.8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==0){
        return 16.6;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth,16.6)];
    footerView.backgroundColor=[UIColor colorWithRed:245.0/256 green:242.0/256 blue:242.0/256 alpha:1];
    footerView.alpha=1;
    if(section==0){
        return footerView;
    }
    return nil;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HGBBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:identify_bottomsheet forIndexPath:indexPath];
    if(indexPath.section==0){
        cell.backgroundColor=[UIColor whiteColor];
        cell.title.text=self.titles[indexPath.row];
        if(indexPath.row==0){
            cell.topHiden=NO;

        }else{
            cell.topHiden=YES;
        }
        if(indexPath.row==self.titles.count){
            cell.bottomHiden=NO;
            cell.shortHiden=YES;
        }else{
            cell.shortHiden=NO;
            cell.bottomHiden=YES;
        }
    }
    if(indexPath.section==1){
        cell.shortHiden=YES;
        cell.topHiden=YES;
        cell.bottomHiden=NO;

        cell.title.text=@"取消";
        cell.title.backgroundColor=[UIColor colorWithRed:247.0/256 green:247.0/256 blue:247.0/256 alpha:1];
        cell.title.textColor=[UIColor colorWithRed:51.0/256 green:51.0/256 blue:51.0/256 alpha:1];
        cell.backgroundColor=[UIColor lightGrayColor];
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(bottomSheet:didClickButtonWithIndex:)]){
            [self.delegate bottomSheet:self didClickButtonWithIndex:indexPath.row];
        }

    }else if(indexPath.section==1){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(bottomSheetDidClickcancelButton:)]){
            [self.delegate bottomSheetDidClickcancelButton:self];
        }
    }
    [self popViewDisappear];

}
#pragma mark pop
//弹出视图
-(void)popInParentView
{
    if(obj){
        [obj popViewRemoved];
    }
    self.grayHeaderView=[UIButton buttonWithType:UIButtonTypeSystem];
    self.grayHeaderView.frame=[UIScreen mainScreen].bounds;
    self.grayHeaderView.tag=10;
    self.grayHeaderView.backgroundColor=[UIColor blackColor];
    self.grayHeaderView.alpha=0.3;
    [self.grayHeaderView addTarget:self action:@selector(popViewRemoved) forControlEvents:(UIControlEventTouchUpInside)];

    [self.window addSubview:self.grayHeaderView];
    CGFloat cellHeight=61.8;
    self.view.frame=CGRectMake(0,kHeight+30,kWidth,366*hScale);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=CGRectMake(0, kHeight-(cellHeight*(self.titles.count+1)+17), kWidth, cellHeight*(self.titles.count+1)+18);
    }];
    [self.window addSubview:self.view];
    [self.parent addChildViewController:self];
    obj=self;
}
//弹出视图消失
-(void)popViewDisappear
{
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.view.transform=CGAffineTransformTranslate(self.view.transform,0,kHeight+61.8*(self.titles.count+1)+50);
    } completion:^(BOOL finished) {
        [self popViewRemoved];
    }];
}
//弹出视图移除
-(void)popViewRemoved
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self.grayHeaderView removeFromSuperview];
    obj=nil;
}
#pragma mark get
-(UIWindow *)window
{
    if(_window==nil){
        _window=[[UIApplication sharedApplication]keyWindow];
    }
    return _window;
}
-(NSArray *)titles{
    if(_titles==nil){
        _titles=[NSArray array];
    }
    return _titles;
}
@end
