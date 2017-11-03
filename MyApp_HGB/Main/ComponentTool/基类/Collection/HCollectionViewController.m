//
//  HCollectionViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HCollectionViewController.h"
#import "HGBCollectionViewCell.h"

#define identify_cell @"cell"
#define identify_week @"week"

#define identify_footer @"CollectionReusableViewFooter"
#define identify_header @"CollectionReusableViewHeader"

@interface HCollectionViewController ()

@end

@implementation HCollectionViewController

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
    titleLab.text=@"collection-cell";
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
    self.view.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    CGFloat itemHeight=self.view.frame.size.height/8;
    CGFloat itemWidth=self.view.frame.size.width/8;



    //创建流式布局
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];

    //指定每一个cell的大小
    flowLayout.itemSize=CGSizeMake(itemWidth, itemHeight);

    flowLayout.minimumInteritemSpacing=0;
    flowLayout.minimumLineSpacing=0;
    //设置滑动方向
    // flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    //指定边距
    flowLayout.sectionInset=UIEdgeInsetsMake(0, 0,0, 0);
    //创建集合视图


    //    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0.5*itemWidth,2*itemHeight, 7*itemWidth,6*itemHeight) collectionViewLayout:flowLayout];
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0.5*itemWidth,1*itemHeight, 7*itemWidth,6*itemHeight) collectionViewLayout:flowLayout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    //    self.collectionView.
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[HGBCollectionViewCell class] forCellWithReuseIdentifier:identify_cell];

    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identify_header];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identify_footer];
    self.collectionView.allowsMultipleSelection=YES;


}
#pragma mark collectiondelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 42;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier=identify_cell;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = identify_footer;
    }else{
        reuseIdentifier = identify_header;
    }

    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    return view;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemHeight=self.view.frame.size.height/8;    CGFloat itemWidth=self.view.frame.size.width/8;

    return CGSizeMake(itemWidth, itemHeight);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={0,0};
    return size;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    HGBCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify_cell forIndexPath:indexPath];
    cell.promptLabel.text=@"";
    cell.imageV.image=[UIImage imageNamed:@""];
    cell.promptLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row];
    cell.imageV.image=[UIImage imageNamed:@"cir0"];
    return cell;
}


@end
