//
//  HGBTableSelector.h
//  CTTX
//
//  Created by huangguangbao on 16/10/4.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGBTableSelector;
#pragma mark 表格选择代理
@protocol  HGBTableSelectorDelegate <NSObject>
/**
 点击事件

 @param dic 信息
 */
-(void)tableSelector:(HGBTableSelector *)selector didSelectedIndexPath:(NSIndexPath *)indexPath   andWithInfoDic:(NSDictionary *)dic;
@optional
/**
 取消选择
 */
-(void)tableSelectorDidCanceled:(HGBTableSelector *)selector;
///**
// 刷新
//
// @param index id
// */
//-(void)tableSelectorReloadWithIndex:(NSInteger)index;
@end



/**
 表格选择
 */
@interface HGBTableSelector : UIViewController
@property(strong,nonatomic)id<HGBTableSelectorDelegate>delegate;
/**
 刷新功能开关
 */
@property(assign,nonatomic)BOOL refreshFlag;
/**
 标记
 */
@property(assign,nonatomic)NSInteger tag;
/**
 默认已选中
 */
@property(strong,nonatomic)NSString *selectorStr;
/**
 显示id
 */
@property(strong,nonatomic)NSString *IdStr;
/**
 显示名称
 */
@property(strong,nonatomic)NSString *nameStr;
/**
 数据源dic-array-dic 显示 dic2中内容 key值为nameStr
 */
@property(strong,nonatomic)NSDictionary *dataSource;

/**
 导航栏创建

 @param title 导航栏标题
 */
-(void)createNavigationItemWithTitle:(NSString *)title;
/**
 更新

 @param dataFlag 更新数据状态-加载数据成功-失败
 */
//-(void)updateSelectorDataWithFlag:(BOOL)dataFlag;
@end
