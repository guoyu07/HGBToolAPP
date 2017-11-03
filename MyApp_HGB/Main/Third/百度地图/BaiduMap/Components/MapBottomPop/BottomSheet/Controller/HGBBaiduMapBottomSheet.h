//
//  HGBBaiduMapBottomSheet.h
//  测试
//
//  Created by huangguangbao on 2017/11/2.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGBBaiduMapBottomSheet;
/**
 底部弹窗代理
 */
@protocol HGBBaiduMapBottomSheetDelegate <NSObject>
/**
 点击事件

 @param bottomSheet bottomSheet
 @param index 位置
 */
-(void)bottomSheet:(HGBBaiduMapBottomSheet *)bottomSheet  didClickButtonWithIndex:(NSInteger)index;
/**
 取消

 @param bottomSheet bottomSheet
 */
-(void)bottomSheetDidClickcancelButton:(HGBBaiduMapBottomSheet *)bottomSheet;
@end

/**
 底部弹窗
 */
@interface HGBBaiduMapBottomSheet : UITableViewController
/**
 标题集合
 */
@property(strong,nonatomic)NSArray *titles;

/**
 创建
 */
+(instancetype)instanceWithDelegate:(id<HGBBaiduMapBottomSheetDelegate>)delegate InParent:(UIViewController *)parent;
/**
 弹出
 */
-(void)popInParentView;
@end

