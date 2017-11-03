//
//  HGBCenterPop.h
//  CTTX
//
//  Created by huangguangbao on 16/12/28.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBCenterPopHeader.h"
#import "HGBCenterPopItemModel.h"

/**
 中部选择弹框代理
 */
@protocol HGBCenterPopDelegate <NSObject>
/**
 点击事件

 @param idx 选中了第几个cell
 @param centerModel 信息
 */
-(void)centerPopDidSelectedAtIndex:(NSInteger)idx withCenterModel:(HGBCenterPopItemModel *)centerModel;
@end


/**
 中部选择弹框
 */

@interface HGBCenterPop : UITableViewController
/**
 标记
 */
@property(assign,nonatomic)NSInteger index;
/**
 选项
 */
@property(strong,nonatomic)NSArray<HGBCenterPopItemModel *> *dataSource;
/**
 标题
 */
@property(strong,nonatomic)NSString *titleStr;
/**
 创建
 */
+(instancetype)instanceWithDelegate:(id<HGBCenterPopDelegate>)delegate andWithParent:(UIViewController *)parent;
/**
 弹出视图
 */
-(void)popInParentView;

@end
