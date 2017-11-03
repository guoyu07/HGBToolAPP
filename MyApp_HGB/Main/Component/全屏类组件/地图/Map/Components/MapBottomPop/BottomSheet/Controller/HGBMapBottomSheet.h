//
//  HGBMapBottomSheet.h
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGBMapBottomSheet;
/**
 底部弹窗代理
 */
@protocol HGBMapBottomSheetDelegate <NSObject>
/**
 点击事件

 @param bottomSheet bottomSheet
 @param index 位置
 */
-(void)bottomSheet:(HGBMapBottomSheet *)bottomSheet  didClickButtonWithIndex:(NSInteger)index;
/**
 取消

 @param bottomSheet bottomSheet
 */
-(void)bottomSheetDidClickcancelButton:(HGBMapBottomSheet *)bottomSheet;
@end

/**
 底部弹窗
 */
@interface HGBMapBottomSheet : UITableViewController
/**
 标题集合
 */
@property(strong,nonatomic)NSArray *titles;

/**
 创建
 */
+(instancetype)instanceWithDelegate:(id<HGBMapBottomSheetDelegate>)delegate InParent:(UIViewController *)parent;
/**
 弹出
 */
-(void)popInParentView;
@end

