//
//  HGBPageViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBPageViewController.h"
#import "HGBPageControl.h"
@interface HGBPageViewController ()<UIScrollViewDelegate>
@property(strong,nonatomic)NSArray *dataSource;
@property(strong,nonatomic)HGBPageControl *page;
@property(strong,nonatomic)UIScrollView* scrollView;
@end

@implementation HGBPageViewController
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
    titleLab.text=@"页码控制器";
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
#pragma mark view
-(void)viewSetUp{
    self.view.backgroundColor=[UIColor whiteColor];
    UIScrollView* scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(10,80, 160,320)];
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width*self.dataSource.count, scrollView.frame.size.height);
    scrollView.delegate=self;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.pagingEnabled=YES;
    self.scrollView=scrollView;
 scrollView.showsHorizontalScrollIndicator=YES;

    [self.view addSubview:scrollView];

    for(int  i=0;i<self.dataSource.count;i++){
        NSString *imageName=self.dataSource[i];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(scrollView.frame.size.width*i, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        imageView.image=[UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
    }
    HGBPageControl *page=[[HGBPageControl alloc]initWithFrame:CGRectMake(50,360, 80,20)];
    self.page=page;
    page.numberOfPages=scrollView.contentSize.width/scrollView.frame.size.width;
    page.pageIndicatorTintColor=[UIColor blueColor];
    page.currentPage=scrollView.contentOffset.x/scrollView.frame.size.width;
    page.currentPageIndicatorTintColor=[UIColor redColor];
    [page addTarget:self action:@selector(pageHandle:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:page];

    
}
-(void)pageHandle:(HGBPageControl *)_p{
    self.scrollView.contentOffset=CGPointMake(self.page.currentPage*self.scrollView.frame.size.width, 0);
}
#pragma mark delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.page.currentPage=scrollView.contentOffset.x/scrollView.frame.size.width;

}

#pragma mark get
-(NSArray *)dataSource{
    if(_dataSource==nil){
        _dataSource=@[@"cir0",@"cir1",@"cir2",@"cir3"];
    }
    return _dataSource;
}

@end
