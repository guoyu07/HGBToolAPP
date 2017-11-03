//
//  HGBBaseTableViewController.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 tableview 基类
 */
@interface HGBBaseTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
/**
 表格
 */
@property(strong,nonatomic)UITableView *tableView;
/**
 数据源
 */
@property(strong,nonatomic)NSMutableArray *dataSourceArray;
/**
 数据源
 */
@property(strong,nonatomic)NSMutableDictionary *dataSourceDictionary;
@end
