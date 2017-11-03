//
//  HGBFileBaseTableCell.h
//  测试
//
//  Created by huangguangbao on 2017/8/15.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 cell表层按钮
 */
@protocol HGBFileBaseTableCellDelegate <NSObject>
-(void)fileBaseTableCellBackGroundButtonActionWithIndexPath:(NSIndexPath *)indexPath;
@end

/**
 基类-表格
 */
@interface HGBFileBaseTableCell : UITableViewCell
@property(strong,nonatomic)id<HGBFileBaseTableCellDelegate>backGroundDelegate;
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
/**
 添加分割线

 @param height 高度
 */
- (void)drawWithHeight:(float)height;
@end
