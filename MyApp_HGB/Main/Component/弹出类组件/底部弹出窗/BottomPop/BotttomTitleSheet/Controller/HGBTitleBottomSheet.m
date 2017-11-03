//
//  HGBTitleBottomSheet.m
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBTitleBottomSheet.h"
#import "HGBBottomPopHeader.h"
#import "HGBTitleBottomCommonCell.h"
#import "HGBTitleBottomTypeCell.h"

#define identify_common @"commoncell"
#define identify_type @"typecell"

@interface HGBTitleBottomSheet ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)id<HGBTitleBottomSheetDelegate>delegate;
/**
 根控制器
 */
@property(strong,nonatomic)UIWindow *window;
/**
 灰层
 */
@property(strong,nonatomic)UIButton *grayHeaderView;
/**
 父控制器
 */
@property (strong,nonatomic)UIViewController *parent;
/**
 背景
 */
@property (nonatomic,strong)UIScrollView *backgroudScrollView;
/**
 主界面
 */
@property (nonatomic,strong)UITableView *tableView;
/**
 二级选择界面
 */
@property (nonatomic,strong)UITableView *typeTableView;
/**
 支付按钮
 */
@property (nonatomic,strong)UIButton *OKButton;
/**
 标题
 */
@property(strong,nonatomic)UILabel *titleLab;
/**
 type标题
 */
@property(strong,nonatomic)UILabel *typeTitleLab;
/**
 主界面点击标记
 */
@property(assign,nonatomic)NSInteger tapIdx_main;
/**
 二级界面点击标记
 */
@property(assign,nonatomic)NSInteger tapIdx_next;
@end

@implementation HGBTitleBottomSheet
static HGBTitleBottomSheet *obj=nil;
#pragma mark init

+(instancetype)instanceWithDelegate:(id<HGBTitleBottomSheetDelegate>)delegate InParent:(UIViewController *)parent
{
    return [[[self class]alloc]initWithDelegate:delegate InParent:parent];
}

-(instancetype)initWithDelegate:(id<HGBTitleBottomSheetDelegate>)delegate InParent:(UIViewController *)parent
{
    self=[super init];
    if(self){
        self.delegate=delegate;
        self.parent=parent;
        [self viewSetUp];
        [self createTableHeaderView];
        [self createTableFooterView];
        [self createTypeTableHeaderView];
    }
    return self;
}

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.tableView){
        return self.dataSource.count;
    }else if (tableView==self.typeTableView){
        return self.typeDataSource.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96*hScale;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==self.tableView){
        NSDictionary *dic=self.dataSource[indexPath.row];
        NSString *type=[dic objectForKey:@"type"];
        if([type isEqualToString:@"1"]){
            HGBTitleBottomTypeCell *cell0=[tableView dequeueReusableCellWithIdentifier:identify_type forIndexPath:indexPath];
            cell0.titleLab.text=[dic objectForKey:@"title"];
            cell0.detailLab.text=[dic objectForKey:@"detail"];
            if(self.typeDataSource&&self.typeDataSource.count!=0){
                NSDictionary *typeDic=[self.typeDataSource objectAtIndex:self.tapIdx_next];
                cell0.detailLab.text=[typeDic objectForKey:@"title"];
            }
            cell0.titleLab.textColor=[UIColor colorWithRed:166.0/256 green:166.0/256 blue:166.0/256 alpha:1];
            return cell0;
        }
        HGBTitleBottomCommonCell *cell=[tableView dequeueReusableCellWithIdentifier:identify_common forIndexPath:indexPath];
        cell.titleLab.text=[dic objectForKey:@"title"];
        cell.titleLab.textColor=[UIColor colorWithRed:166.0/256 green:166.0/256 blue:166.0/256 alpha:1];
        cell.detailLab.text=[dic objectForKey:@"detail"];
        if([type isEqualToString:@"2"]){
            cell.detailLab.textColor=[UIColor redColor];
        }
        if([type isEqualToString:@"3"]){
            cell.detailLab.textColor=[UIColor blackColor];
            cell.detailLab.numberOfLines=0;
            cell.detailLab.font=[UIFont systemFontOfSize:30*hScale];
        }
        return cell;
    }else if (tableView==self.typeTableView){
        NSDictionary *dic=self.typeDataSource[indexPath.row];
        HGBTitleBottomCommonCell *cell=[tableView dequeueReusableCellWithIdentifier:identify_common forIndexPath:indexPath];
        cell.titleLab.text=[dic objectForKey:@"title"];
        cell.detailLab.text=[dic objectForKey:@"detail"];
        cell.titleLab.textColor=[UIColor colorWithRed:51.0/256 green:51.0/256 blue:51.0/256 alpha:1];
        return cell;
    }
    HGBTitleBottomCommonCell *cell=[tableView dequeueReusableCellWithIdentifier:identify_common forIndexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView==self.tableView){

        NSDictionary *dic=self.dataSource[indexPath.row];
        NSString *type=[dic objectForKey:@"type"];
        if([type isEqualToString:@"1"]){
            self.tapIdx_main=indexPath.row;
            if(self.delegate&&[self.delegate respondsToSelector:@selector(titleBottomSheet:didClickButtonWithIndex:)]){
                [self.delegate titleBottomSheet:self didClickButtonWithIndex:indexPath.row];
                [self.typeTableView reloadData];
                self.backgroudScrollView.contentOffset=CGPointMake(kWidth, 0);
            }
        }
        self.typeTitleLab.text=self.typeTitle;
    }else if (tableView==self.typeTableView){
        self.typeTitleLab.text=self.typeTitle;
        self.tapIdx_next=indexPath.row;
        if(self.delegate&&[self.delegate respondsToSelector:@selector(titleBottomSheet:didClickSecondaryButtonWithIndex:andWithMainIndex:)]){
            [self.delegate titleBottomSheet:self didClickSecondaryButtonWithIndex:indexPath.row andWithMainIndex:self.tapIdx_main];
            self.backgroudScrollView.contentOffset=CGPointMake(0, 0);
            [self.tableView reloadData];
        }
    }

}

#pragma mark pop
//弹出视图
-(void)popInParentView
{
    if(obj){
        [obj popViewRemoved];
    }
    [self.tableView reloadData];
    if(self.okButtonTitle&&self.okButtonTitle.length!=0){
        [self.OKButton setTitle:self.okButtonTitle forState:UIControlStateNormal];
    }
    if(self.popTitle&&self.popTitle.length!=0){
        self.titleLab.text=self.popTitle;
    }
    if(self.typeTitle&&self.typeTitle.length!=0){
        self.typeTitleLab.text=self.typeTitle;
    }
    self.grayHeaderView=[UIButton buttonWithType:UIButtonTypeSystem];
    self.grayHeaderView.frame=[UIScreen mainScreen].bounds;
    self.grayHeaderView.tag=10;
    self.grayHeaderView.backgroundColor=[UIColor blackColor];
    self.grayHeaderView.alpha=0.3;
    [self.grayHeaderView addTarget:self action:@selector(popViewRemoved) forControlEvents:(UIControlEventTouchUpInside)];

    [self.window addSubview:self.grayHeaderView];

    self.view.frame=CGRectMake(0,kHeight+30,kWidth,366*hScale);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=CGRectMake(0, kHeight-(96*hScale*(self.dataSource.count+1)+240*hScale), kWidth,(96*hScale*(self.dataSource.count+1)+300*hScale));
        self.backgroudScrollView.frame=CGRectMake(0, 0, kWidth,(96*hScale*(self.dataSource.count+1)+240*hScale));
        self.backgroudScrollView.contentSize=CGSizeMake(2*kWidth, (96*hScale*(self.dataSource.count+1)+240*hScale));
        self.tableView.frame=CGRectMake(0,0, kWidth,(96*hScale*(self.dataSource.count+1)+240*hScale));
        self.typeTableView.frame=CGRectMake(kWidth,0, kWidth,(96*hScale*(self.dataSource.count+1)+240*hScale));

    }];
    [self.window addSubview:self.view];
    [self.parent addChildViewController:self];
    [self.tableView reloadData];
    obj=self;
}
//弹出视图消失
-(void)popViewDisappear
{
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.view.transform=CGAffineTransformTranslate(self.view.transform,0,kHeight+61.8*(self.dataSource.count+1)+50);
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
#pragma mark 更新
-(void)titleBottomPopUpate{
    [self.tableView reloadData];
    [self.typeTableView reloadData];
}
#pragma mark veiwSetUp
-(void)viewSetUp{
    self.view.backgroundColor = [UIColor colorWithRed:245.0/256 green:242.0/256 blue:242.0/256 alpha:1];

    self.backgroudScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0 * hScale, kWidth, 300 * hScale)];
    self.backgroudScrollView.contentSize = CGSizeMake(kWidth * 2,300 * hScale);
    self.backgroudScrollView.pagingEnabled = YES;
    self.backgroudScrollView.scrollEnabled = NO;
    self.backgroudScrollView.backgroundColor = [UIColor whiteColor];
    self.backgroudScrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:self.backgroudScrollView];

    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth,300*hScale) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/256 green:242.0/256 blue:242.0/256 alpha:1];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.backgroudScrollView  addSubview:self.tableView];
    self.tableView.backgroundColor=[UIColor colorWithRed:245.0/256 green:242.0/256 blue:242.0/256 alpha:1];
    [self.tableView registerClass:[HGBTitleBottomCommonCell class] forCellReuseIdentifier:identify_common];
    [self.tableView registerClass:[HGBTitleBottomTypeCell class] forCellReuseIdentifier:identify_type];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=[UIColor colorWithRed:245.0/256 green:242.0/256 blue:242.0/256 alpha:1];
    self.tableView.alpha=1;
    self.tableView.scrollEnabled=NO;




    self.typeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 330 * hScale) style:(UITableViewStylePlain)];
    self.typeTableView.backgroundColor = [UIColor clearColor];
    self.typeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.typeTableView.delegate = self;
    self.typeTableView.dataSource = self;
    [self.typeTableView registerClass:[HGBTitleBottomCommonCell class] forCellReuseIdentifier:identify_common];
    [self.backgroudScrollView addSubview:self.typeTableView];

    self.view.frame=CGRectMake(0,kHeight+30,kWidth,202);

}
#pragma mark footer-header
-(void)createTableHeaderView{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 96*hScale)];
    headView.backgroundColor=[UIColor whiteColor];

    UIButton *closeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    closeButton.frame = CGRectMake(30 * wScale, 34 * hScale, 28.3 * wScale, 28.3 * wScale);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"HGBBottomPopBundle.bundle/icon_normal_close.png"] forState:(UIControlStateNormal)];
    [closeButton addTarget:self action:@selector(popViewDisappear) forControlEvents:(UIControlEventTouchUpInside)];
    [headView addSubview:closeButton];

    UIButton *closeBackButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    closeBackButton.frame = CGRectMake(0 * wScale, 0 * hScale, 96 * wScale, 96 * wScale);

    [closeBackButton addTarget:self action:@selector(cancelButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    closeBackButton.tag = 201;
    [headView addSubview:closeBackButton];

    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(closeBackButton.frame), 0, kWidth - 96*2* wScale, 96 * hScale)];
    self.titleLab.textColor = [UIColor colorWithRed:51.0/256 green:51.0/256 blue:51.0/256 alpha:1];
    self.titleLab.backgroundColor = [UIColor clearColor];
    self.titleLab.textAlignment=NSTextAlignmentCenter;
    self.titleLab.font = [UIFont systemFontOfSize:17.0];
    self.titleLab.text = @"付款详情";

    if(self.popTitle&&self.popTitle.length!=0){
        self.titleLab.text=self.popTitle;
    }

    [headView addSubview:self.titleLab];

    self.tableView.tableHeaderView=headView;

}

-(void)createTableFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 240 * hScale)];
    footerView.backgroundColor = [UIColor whiteColor];
    //下一步
    self.OKButton=[UIButton buttonWithType:UIButtonTypeSystem];
    self.OKButton.frame=CGRectMake(30*wScale,80*hScale,kWidth-60*wScale,96*hScale);
    [self.OKButton setTitle:@"绑定" forState:UIControlStateNormal];
    self.OKButton.titleLabel.font=[UIFont systemFontOfSize:19.8];
    self.OKButton.enabled=YES;
    self.OKButton.layer.masksToBounds=YES;
    self.OKButton.layer.cornerRadius=10*hScale;
    self.OKButton.backgroundColor=[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1];;
    [self.OKButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    if(self.okButtonTitle&&self.okButtonTitle.length!=0){
        [self.OKButton setTitle:self.okButtonTitle forState:UIControlStateNormal];
    }
    [self.OKButton addTarget:self action:@selector(okButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [footerView addSubview:self.OKButton];
    self.tableView.tableFooterView=footerView;
}
-(void)okButtonHandle:(UIButton *)_b{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(titleBottomSheetDidClickOKButton:)]){
        [self.delegate titleBottomSheetDidClickOKButton:self];
    }
    [self popViewDisappear];
}
-(void)cancelButtonHandle:(UIButton *)_b{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(titleBottomSheetDidClickCancelButton:)]){
        [self.delegate titleBottomSheetDidClickCancelButton:self];
    }
    [self popViewDisappear];
}
-(void)createTypeTableHeaderView{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 96*hScale)];
    headView.backgroundColor=[UIColor whiteColor];

    UIButton *closeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    closeButton.frame = CGRectMake(30 * wScale, 34 * hScale, 16 * wScale, 28.3 * wScale);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"HGBBottomPopBundle.bundle/icon_normal_close.png"] forState:(UIControlStateNormal)];
    [closeButton addTarget:self action:@selector(returnHandle) forControlEvents:(UIControlEventTouchUpInside)];
    [headView addSubview:closeButton];

    UIButton *closeBackButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    closeBackButton.frame = CGRectMake(0 * wScale, 0 * hScale, 96 * wScale, 96 * wScale);

    [closeBackButton addTarget:self action:@selector(returnHandle) forControlEvents:(UIControlEventTouchUpInside)];
    closeBackButton.tag = 201;
    [headView addSubview:closeBackButton];

    self.typeTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(closeButton.frame), 0, kWidth - 96*2* wScale, 96 * hScale)];
    self.typeTitleLab.textAlignment = NSTextAlignmentCenter;
    self.typeTitleLab.textColor = [UIColor colorWithRed:51.0/256 green:51.0/256 blue:51.0/256 alpha:1];
    self.typeTitleLab.backgroundColor = [UIColor clearColor];
    self.typeTitleLab.font = [UIFont systemFontOfSize:17.0];
    self.typeTitleLab.text = @"支付类型";
    if(self.typeTitle&&self.typeTitle.length!=0){
        self.typeTitleLab.text=self.typeTitle;
    }
    [headView addSubview:self.typeTitleLab];

    self.typeTableView.tableHeaderView=headView;

}
-(void)returnHandle{
    self.backgroudScrollView.contentOffset=CGPointMake(0, 0);
}
#pragma mark get
-(UIWindow *)window
{
    if(_window==nil){
        _window=[[UIApplication sharedApplication]keyWindow];
    }
    return _window;
}
-(NSArray *)dataSource{
    if(_dataSource==nil){
        _dataSource=[NSArray array];
    }
    return _dataSource;
}
-(NSArray *)typeDataSource{
    if(_typeDataSource==nil){
        _typeDataSource=[NSArray array];
    }
    return _typeDataSource;
}
@end
