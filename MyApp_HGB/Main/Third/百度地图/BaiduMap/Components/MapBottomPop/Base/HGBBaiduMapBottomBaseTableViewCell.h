//
//  HGBBaiduMapBottomBaseTableViewCell.h
//  测试
//
//  Created by huangguangbao on 2017/11/2.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 cell表层按钮
 */
@protocol HGBBaiduMapBottomBaseCellBackGroundButtonDelegate <NSObject>
-(void)baiduBottomBaseCellBackGroundButtonActionWithIndexPath:(NSIndexPath *)indexPath;
@end
@interface HGBBaiduMapBottomBaseTableViewCell : UITableViewCell
@property(strong,nonatomic)id<HGBBaiduMapBottomBaseCellBackGroundButtonDelegate>backGroundDelegate;

@property(strong,nonatomic)NSIndexPath *indexPath;
/**
 背景按钮
 */
@property(strong,nonatomic)UIButton *backButton;


/**
 下短线标志
 */
@property(assign,nonatomic)BOOL shortHiden;
/**
 底部线
 */
@property(assign,nonatomic)BOOL bottomHiden;
/**
 上部线
 */
@property(assign,nonatomic)BOOL topHiden;
/**
 添加右部功能按钮
 */
-(void)addBackButton;//
@end
