//
//  HGBTitleBottomSheet.h
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGBTitleBottomSheet;
/**
 底部标题弹窗代理
 */
@protocol HGBTitleBottomSheetDelegate <NSObject>
/**
 点击事件

 @param titleBottomSheet titleBottomSheet
 @param index 位置
 */
-(void)titleBottomSheet:(HGBTitleBottomSheet *)titleBottomSheet didClickButtonWithIndex:(NSInteger)index;

/**
 二级点击事件

 @param titleBottomSheet titleBottomSheet
 @param idx type选择界面位置
 @param index 首页位置
 */
-(void)titleBottomSheet:(HGBTitleBottomSheet *)titleBottomSheet didClickSecondaryButtonWithIndex:(NSInteger)idx andWithMainIndex:(NSInteger)index;
/**
 确定按钮事件
 
 @param titleBottomSheet titleBottomSheet
 */
-(void)titleBottomSheetDidClickOKButton:(HGBTitleBottomSheet *)titleBottomSheet;
/**
 取消按钮事件

 @param titleBottomSheet titleBottomSheet
 */
-(void)titleBottomSheetDidClickCancelButton:(HGBTitleBottomSheet *)titleBottomSheet;


@end
@interface HGBTitleBottomSheet : UIViewController

/**
 标题
 */
@property(strong,nonatomic)NSString *popTitle;
/**
 数据源:内含字典 title: detail: type 0无下一级 1有下一级 2无下一级－红色 3无下一级分行
 */
@property (nonatomic,strong)NSArray *dataSource;

@property(assign,nonatomic)BOOL nextViewFlag;
/**
 类型选择标题
 */
@property(strong,nonatomic)NSString *typeTitle;
/**
 按钮标题
 */
@property(strong,nonatomic)NSString *okButtonTitle;
/**
 数据源:内含字典 title: detail: id:
 */
@property(strong,nonatomic)NSArray *typeDataSource;
/**
 创建
 */
+(instancetype)instanceWithDelegate:(id<HGBTitleBottomSheetDelegate>)delegate InParent:(UIViewController *)parent;
/**
 弹出
 */
-(void)popInParentView;
/**
 更新
 */
-(void)titleBottomPopUpate;
@end
