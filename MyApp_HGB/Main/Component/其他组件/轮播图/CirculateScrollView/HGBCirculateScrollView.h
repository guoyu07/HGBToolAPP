//
//  HGBCirculateScrollView.h
//  CTTX
//
//  Created by huangguangbao on 16/9/20.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 轮播滚动视图
 */
typedef void (^HGBScrollViewCurrentIndex)(NSInteger);

/**
 轮播滚动视图
 */
@interface HGBCirculateScrollView : UIView<UIScrollViewDelegate>
/**
 滑动视图
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 存储view的地址
 */
@property (nonatomic, strong) NSMutableArray *slideViewsArray;
/**
 扩展及滚动方向
 */
@property (nonatomic) BOOL isVerticalScroll;

/**
 此时的幻灯片图片序号
 */
@property (nonatomic, copy) HGBScrollViewCurrentIndex iCurrentIndex;

/**
 是否显示pageControl
 */
@property (nonatomic) BOOL withoutPageControl;
/**
 是否自动滚动
 */
@property (nonatomic) BOOL withoutAutoScroll;
/**
 是否手动滚动
 */
@property(nonatomic)BOOL withoutManualScroll;
/**
 滚动时间
 */
@property (nonatomic) NSNumber *autoTime;

//翻页提示按钮颜色
/**
 //0 原点 1长条
 */
@property (nonatomic, assign)NSInteger pageControlStyle;
/**
 当前页颜色
 */
@property (nonatomic, strong) UIColor *pageControlCurrentPageIndicatorTintColor;
/**
 页码颜色
 */
@property (nonatomic, strong) UIColor *PageControlPageIndicatorTintColor;
/**
 大小
 */
@property(assign,nonatomic)CGSize pageSize;


/**
 加载初始化（必须实现）
 */
- (void)startLoading; // 加载初始化（必须实现）
// 或者
/**
 加载初始化并制定初始图

 @param index 位置
 */
- (void)startLoadingByIndex:(NSInteger)index;
@end
