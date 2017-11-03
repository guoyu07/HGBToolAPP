//
//  HLayoutCollectionViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HLayoutCollectionViewController.h"
#import "HGBlayout.h"
#import "HGBCell.h"
#import "HGBCellModel.h"


@interface HLayoutCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,HGBlayoutDelegate>
@property(strong,nonatomic)NSMutableArray *dataSource;
@property(strong,nonatomic)UICollectionView *collection;

@end

@implementation HLayoutCollectionViewController
@synthesize collection;
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];
    [self viewSetUp];
}
#pragma mark 导航栏
//导航栏
-(void)createNavigationItem
{
    //导航栏
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=@"瀑布流";
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
/**
 UI
 */
-(void)viewSetUp{
    //瀑布流:使用uicollectionview实现等宽不登高或登高不等宽的cell技术
    [self loadData];
    HGBlayout *layout=[[HGBlayout alloc]init];
    layout.delegate=self;
    collection=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    [collection registerClass:[HGBCell class] forCellWithReuseIdentifier:@"water"];
    //collection.delegate=self;
    collection.dataSource=self;
    [self.view addSubview:collection];
}
#pragma mark data
-(void)loadData
{
    self.dataSource=[NSMutableArray array];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"water" ofType:@"plist"];
    NSArray *arr=[NSArray arrayWithContentsOfFile:path];
    for(NSDictionary *dict in arr){
        HGBCellModel *model=[HGBCellModel cellModelWithDict:dict];
        [self.dataSource addObject:model];
    }
}
#pragma mark layput
-(CGFloat)layout:(HGBlayout *)layout heightWithWidth:(int)height indexPath:(NSIndexPath *)indexPath
{
    HGBCellModel *model=self.dataSource[indexPath.row];
    return height*(model.h*1.0)/model.w;
}
#pragma mark collection
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HGBCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"water" forIndexPath:indexPath];
    HGBCellModel *model=self.dataSource[indexPath.row];
    cell.model=model;
    return cell;
}
@end
