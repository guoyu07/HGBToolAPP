//
//  HGBTableSelector.m
//  CTTX
//
//  Created by huangguangbao on 16/10/4.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import "HGBTableSelector.h"
#import "HGBaTableSelectorHeader.h"
#import "HGBTableSelectorIndexView.h"
#import "HGBTableSelectorCell.h"

#define identify_selector @"selector"

@interface HGBTableSelector ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;//表格
/**
 索引
 */
@property(strong,nonatomic)HGBTableSelectorIndexView *indexView;
/**
 列
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBTableSelector
#pragma mark life
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    _keys=nil;
//    _selectorStr=nil;
//    _nameStr=nil;
//    _IdStr=nil;
//    _dataSource=nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createTableView];//创建表格
    if(self.refreshFlag){
         [self createRefersh];//创建刷新
    }
    [self createSearchIndexView];//创建索引
    
}

#pragma mark 导航栏
//导航栏
-(void)createNavigationItemWithTitle:(NSString *)title
{
    //导航栏
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1]];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=title;
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回"  style:UIBarButtonItemStylePlain target:self action:@selector(returnhandler)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}
//返回
-(void)returnhandler{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(tableSelectorDidCanceled:)]){
        [self.delegate tableSelectorDidCanceled:self];
    }
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
#pragma mark tableview
-(void)createTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:(UITableViewStylePlain)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor colorWithRed:245.0/256 green:242.0/256 blue:242.0/256 alpha:1];
    [self.tableView registerClass:[HGBTableSelectorCell class] forCellReuseIdentifier:identify_selector];
    [self.view addSubview:self.tableView];
    
    UIView *footer=[[UIView alloc]init];
    footer.backgroundColor=[UIColor colorWithRed:245.0/256 green:242.0/256 blue:242.0/256 alpha:1];
    self.tableView.tableFooterView=footer;
    
}
#pragma mark 索引栏
-(void)createSearchIndexView{
    self.indexView = [HGBTableSelectorIndexView viewWithFrame:CGRectMake(kWidth-30, 64+50, 30, kHeight-64-100)
                                    indexTitles:self.keys
                                      tableView:self.tableView
                         tableViewSectionsCount:self.keys.count];
    if(self.keys.count<=1){
    }else{
        [self.view addSubview:self.indexView];
    }
    
    
    //其它个性化设置
    self.indexView.isHaveAnimation = YES;
    self.indexView.titleFont = [UIFont systemFontOfSize:14];
    self.indexView.tapIndexTitleBtn = ^(NSInteger titleIndex, NSString *title){
        return titleIndex;
    };
}
-(void)updateSearchIndex{
    if([self.indexView superview]){
        [self.indexView removeFromSuperview];
    }
    self.indexView = [HGBTableSelectorIndexView viewWithFrame:CGRectMake(kWidth-30, 50, 30, kHeight-64-100)
                                    indexTitles:self.keys
                                      tableView:self.tableView
                         tableViewSectionsCount:self.keys.count];
    if(self.keys.count<=1){
    }else{
        [self.view addSubview:self.indexView];
    }
    
    
    //其它个性化设置
    self.indexView.isHaveAnimation = YES;
    self.indexView.titleFont = [UIFont systemFontOfSize:14];
    self.indexView.tapIndexTitleBtn = ^(NSInteger titleIndex, NSString *title){
        return titleIndex;
    };
}
#pragma mark tableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keys.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *selectors=[self.dataSource objectForKey:self.keys[section]];
    return selectors.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.keys.count<=1){
        return 0;
    }else{
        return 72 * hScale;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 72 * hScale)];
    headView.backgroundColor = [UIColor colorWithRed:245.0/256 green:242.0/256 blue:242.0/256 alpha:1];
    //信息提示栏
    UILabel *tipMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(32 * wScale, 0, kWidth - 32 * wScale, CGRectGetHeight(headView.frame))];
    tipMessageLabel.backgroundColor = [UIColor clearColor];
    tipMessageLabel.text=self.keys[section];
    tipMessageLabel.textColor = [UIColor colorWithRed:166.0/256 green:166.0/256 blue:166.0/256 alpha:1];
    tipMessageLabel.textAlignment = NSTextAlignmentLeft;
    tipMessageLabel.font = [UIFont systemFontOfSize:12.0];
    tipMessageLabel.numberOfLines = 0;
    [headView addSubview:tipMessageLabel];
    if(self.keys.count<=1){
        return nil;
    }else{
        return headView;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HGBTableSelectorCell *cell=[tableView dequeueReusableCellWithIdentifier:identify_selector forIndexPath:indexPath];
    NSArray *selectors=[self.dataSource objectForKey:self.keys[indexPath.section]];
    NSDictionary *dic=selectors[indexPath.row];
    NSString *promptStr=[dic objectForKey:self.nameStr];
    if([self.selectorStr isEqualToString:promptStr]){
            cell.selectImageView.hidden=NO;
    }else{
            cell.selectImageView.hidden=YES;
    }
    cell.titleLab.text=promptStr;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *selectors=[self.dataSource objectForKey:self.keys[indexPath.section]];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(tableSelector: didSelectedIndexPath:andWithInfoDic:)]){
        [self.delegate tableSelector:self didSelectedIndexPath:indexPath andWithInfoDic:selectors[indexPath.row]];
    }
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
#pragma mark 数据更新
-(void)updateSelectorDataWithFlag:(BOOL)dataFlag{
    
    if(dataFlag){
        [self updateSearchIndex];
        [self.tableView reloadData];
    }else{
    }
}
#pragma mark 刷新数据
-(void)createRefersh{
    
}

#pragma mark get
-(NSDictionary *)dataSource{
    if(_dataSource==nil){
        _dataSource=[NSDictionary dictionary];
    }
    return _dataSource;
}

-(NSArray *)keys{
    NSArray *arr=[self.dataSource allKeys];
    _keys=[arr sortedArrayUsingSelector:@selector(compare:)];
    return _keys;
}
-(NSString *)nameStr{
    if(_nameStr==nil){
        _nameStr=@"name";
    }
    return _nameStr;
}
@end
