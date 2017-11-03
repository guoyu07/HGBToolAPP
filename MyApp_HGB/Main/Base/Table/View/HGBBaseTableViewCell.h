//
//  HGBBaseTableViewCell.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 cell表层按钮
 */
@protocol HGBBaseTableViewCellBackGroundButtonDelegate <NSObject>
-(void)baseTableCellBackButtonClickedWithIndexPath:(NSIndexPath *)indexPath;
@end



/**
 cell基类
 */
@interface HGBBaseTableViewCell : UITableViewCell
@property(strong,nonatomic)id<HGBBaseTableViewCellBackGroundButtonDelegate>backGroundDelegate;
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

#pragma mark view
-(void)viewSetUp;
@end
