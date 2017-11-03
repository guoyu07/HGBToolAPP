//
//  HGBMapBottomBaseTableViewCell.h
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 cell表层按钮
 */
@protocol HGBMapBottomBaseCellBackGroundButtonDelegate <NSObject>
-(void)bottomBaseCellBackGroundButtonActionWithIndexPath:(NSIndexPath *)indexPath;
@end

@interface HGBMapBottomBaseTableViewCell : UITableViewCell
@property(strong,nonatomic)id<HGBMapBottomBaseCellBackGroundButtonDelegate>backGroundDelegate;
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
