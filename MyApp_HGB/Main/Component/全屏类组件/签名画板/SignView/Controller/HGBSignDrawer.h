//
//  HGBSignDrawer.h
//  sdk测试
//
//  Created by huangguangbao on 2017/8/4.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 按钮拖动类型
 */
typedef enum HGBSignDrawerType
{
    HGBSignDrawerTypeNOLimit,//按钮齐全
    HGBSignDrawerTypeNOSave,//无保存图片到相册按钮
    HGBSignDrawerTypeNOGet//无获取图片按钮

}HGBSignDrawerType;

///**
// 按钮拖动类型
// */
//typedef enum HGBSignDrawerStyle
//{
//    HGBSignDrawerStyleNO,//无边框无圆角
//    HGBSignDrawerStyleNoLimit,//有边框有圆角
//    HGBSignDrawerStyleBorder,//有边框
//    HGBSignDrawerStyleRadius//有圆角
//
//
//}HGBSignDrawerStyle;


@class HGBSignDrawer;

/**
 签名画板代理
 */
@protocol HGBSignDrawerDelegate <NSObject>
@optional
/**
 返回图片

 @param image 图片
 */
-(void)signDrawer:(HGBSignDrawer *)signDrawer didReturnImage:(UIImage *)image;
/**
 返回图片路径

 @param imagePath 图片路径
 */
-(void)signDrawer:(HGBSignDrawer *)signDrawer didReturnImagePath:(NSString *)imagePath;
/**
 取消
 */
-(void)signDrawerDidCanceled:(HGBSignDrawer *)signDrawer;
@end
@interface HGBSignDrawer : UIViewController
/**
 样式
 */
@property(assign,nonatomic)BOOL withoutCompleteClose;

/**
 画笔颜色
 */
@property(strong,nonatomic)UIColor *lineColor;

/**
 画笔粗细
 */
@property(assign,nonatomic)CGFloat lineWidth;
/**
 画布背景颜色
 */
@property(strong,nonatomic)UIColor *drawBackColor;
/**
 按钮背景颜色
 */
@property(strong,nonatomic)UIColor *buttonBackColor;
/**
 按钮标题颜色
 */
@property(strong,nonatomic)UIColor *buttonTitleColor;

/**
 类型
 */
@property(assign,nonatomic)HGBSignDrawerType drawerType;
/**
 是否保存缓存
 */
@property(assign,nonatomic)BOOL isSaveToCache;
/**
 样式
 */
//@property(assign,nonatomic)HGBSignDrawerStyle drawerStyle;

/**
 创建
 */
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBSignDrawerDelegate>)delegate;
/**
 弹出视图
 */
-(void)popInParentView;

/**
 移除视图
 */
-(void)popViewRemoved;
@end
