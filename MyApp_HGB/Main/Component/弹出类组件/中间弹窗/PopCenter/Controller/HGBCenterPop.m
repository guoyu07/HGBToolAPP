//
//  HGBCenterPop.m
//  CTTX
//
//  Created by huangguangbao on 16/12/28.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import "HGBCenterPop.h"
#import "AppDelegate.h"
#import "HGBCenterPopCell.h"

#pragma mark 颜色
/**
 颜色

 @param r 红色
 @param g 绿色
 @param b 蓝色
 @param a 透明度
 @return 颜色
 */
#define HGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/**
 颜色-不透明

 @param r 红色
 @param g 绿色
 @param b 蓝色
 @return 颜色
 */
#define HGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号

//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0

@interface HGBCenterPop ()
@property(strong,nonatomic)id<HGBCenterPopDelegate>delegate;
/**
 父控制器
 */
@property (strong,nonatomic)UIViewController *parent;

/**
 跟窗口
 */
@property(strong,nonatomic)UIWindow *window;
/**
 关闭图标
 */
@property(strong,nonatomic)UIImageView *closeImgV;
/**
 关闭按钮
 */
@property(strong,nonatomic)UIButton *closeButton;

/**
 灰层
 */
@property(strong,nonatomic)UIButton *grayHeaderView;//
@property(strong,nonatomic)AppDelegate* appDelegate;
@end

@implementation HGBCenterPop
static NSString *identify=@"center";

#pragma mark init

/**
 创建
 */
+(instancetype)instanceWithDelegate:(id<HGBCenterPopDelegate>)delegate andWithParent:(UIViewController *)parent
{
    return [[[self class]alloc]initWithParent:parent andWithDelegate:delegate];
}

-(instancetype)initWithParent:(UIViewController *)parent andWithDelegate:(id<HGBCenterPopDelegate>)delegate
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
    [self.tableView registerClass:[HGBCenterPopCell class] forCellReuseIdentifier:identify];
    self.tableView.backgroundColor=HGBColor(245,242,242);
    self.tableView.alpha=1;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled=NO;
    self.view.frame=CGRectMake(20*wScale,kHeight+30,kWidth-40*wScale,202);
    self.view.layer.cornerRadius=10;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*hScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60 * hScale;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-106, 60*hScale)];
    headView.backgroundColor = [UIColor whiteColor];
    //信息提示栏
    UILabel *tipMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 7.5, CGRectGetWidth(headView.frame), CGRectGetHeight(headView.frame))];
    tipMessageLabel.backgroundColor = [UIColor clearColor];
    if(self.titleStr){
         tipMessageLabel.text = self.titleStr;
    }
    tipMessageLabel.textColor =HGBColor(58,58,58);
    tipMessageLabel.textAlignment = NSTextAlignmentCenter;
    tipMessageLabel.font = [UIFont systemFontOfSize:17];
    [headView addSubview:tipMessageLabel];
    
    self.closeImgV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-70*wScale-28*wScale, 22*hScale, 28*wScale, 28*hScale)];
    self.closeImgV.image=[UIImage imageNamed:@"icon_normal_close_xuanzechepaisuozaidiqu"];
    [headView addSubview:self.closeImgV];
    
    self.closeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.closeButton.frame = CGRectMake(kWidth-98*wScale, 0 * hScale,58 * wScale, 72 * hScale);
    [self.closeButton addTarget:self action:@selector(popViewRemoved) forControlEvents:(UIControlEventTouchUpInside)];
    self.closeButton.tag = 201;
    [headView addSubview:self.closeButton];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HGBCenterPopCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    HGBCenterPopItemModel *model=self.dataSource[indexPath.row];
    cell.promptImgV.image=model.promptImage;
    if(model.indicatorImage){
        cell.indicatorImgV.hidden=NO;
        cell.indicatorImgV.image=model.indicatorImage;
    }else{
        cell.indicatorImgV.hidden=YES;
    }
    cell.titleLab.text=model.promptTitle;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     HGBCenterPopItemModel *model=self.dataSource[indexPath.row];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(centerPopDidSelectedAtIndex:withCenterModel:)]){
        [self.delegate centerPopDidSelectedAtIndex:indexPath.row withCenterModel:model];
    }
    [self popViewDisappearWithSucessBlock:^{
    }];
    
}
#pragma mark 弹出视图选择模式
//弹出视图
-(void)popInParentView
{
    [self.tableView reloadData];
    
    //在window上添加灰色的按钮
    self.grayHeaderView=[UIButton buttonWithType:UIButtonTypeSystem];
    self.grayHeaderView.frame=[UIScreen mainScreen].bounds;
    self.grayHeaderView.tag=10;
    self.grayHeaderView.backgroundColor=HGBAColor(0,0,0,0.3);
    [self.grayHeaderView addTarget:self action:@selector(popViewRemoved) forControlEvents:(UIControlEventTouchUpInside)];
    [self.window addSubview:self.grayHeaderView];
    
    //将当前的view加载到window上
    self.view.frame=CGRectMake(15,kHeight+30,kWidth-30,260*hScale);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=CGRectMake(15, (kHeight-64-( 60*hScale+self.dataSource.count*100*hScale))*0.5, kWidth-30, 60*hScale+self.dataSource.count*100*hScale);
    }];
    [self.window addSubview:self.view];
    [self.parent addChildViewController:self];
}

#pragma mark 弹出视图消失
//弹出视图消失
-(void)popViewDisappearWithSucessBlock:(void (^)(void))successBlock
{
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.view.transform=CGAffineTransformTranslate(self.view.transform,0,1000*hScale);
    } completion:^(BOOL finished) {
        successBlock();
        [self popViewRemoved];
    }];
}
//弹出视图移除
-(void)popViewRemoved
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self.grayHeaderView removeFromSuperview];
}

#pragma mark - GET
-(AppDelegate *)appDelegate{
    if(_appDelegate==nil){
        _appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return _appDelegate;
}
-(UIWindow *)window
{
    if(_window==nil){
        _window=[[UIApplication sharedApplication]keyWindow];
    }
    return _window;
}
-(NSArray<HGBCenterPopItemModel *> *)dataSource{
    if(_dataSource==nil){
        _dataSource=@[];
    }
    return _dataSource;
}
@end
