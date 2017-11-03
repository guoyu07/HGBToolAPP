//
//  HGBPieChat.h
//  测试
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBPieValue.h"

@class HGBPieChat;

@protocol HGBPieChatDelegate <NSObject>
-(void)pieChat:(HGBPieChat *)pieChat didClickWithValue:(HGBPieValue *)value;
@end

@interface HGBPieChat : UIView
@property (nonatomic, strong) id <HGBPieChatDelegate>delegate;
/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray<HGBPieValue *> *dataArray;
/**
 圆饼半径
 */
@property (nonatomic, assign) CGFloat radius;
/**
 是否需要动画
 */
@property (nonatomic, assign) BOOL needAnimation;
/**
 动画类型
 */
@property (nonatomic, assign) BOOL draWAlong;
/**
 动画执行时间
 */
@property (nonatomic, assign) CGFloat duration;
/**
 是否显示文字
 */
@property (nonatomic, assign) BOOL showText;
/**
 初始化

 @param frame 尺寸
 @param dataArray 数据源
 @return 模型
 */
- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray;
/**
 数据刷新

 @param dataArray 数据源
 */
-(void)updateWithDataSource:(NSArray *)dataArray;
@end
