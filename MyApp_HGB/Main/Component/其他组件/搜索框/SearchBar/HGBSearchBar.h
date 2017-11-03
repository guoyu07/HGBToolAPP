//
//  HGBSearchBar.h
//  CTTX
//
//  Created by huangguangbao on 2017/2/21.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGBSearchBar;
/**
 搜索框代理
 */
@protocol HGBSearchBarDelegate <NSObject>
@optional
/**
 进入编辑状态
 */
-(void)searchBarDidBecomeEdit:(HGBSearchBar *)searchBar;
/**
 结束编辑状态
 */
-(void)searchBarDidEndEdit:(HGBSearchBar *)searchBar;
/**
 文本变化
 */
-(void)searchBar:(HGBSearchBar *)searchBar stringDidChanged:(NSString *)string;
/**
 搜索按钮
 */
-(void)searchButtonDidClicked:(HGBSearchBar *)searchBar;

/**
 完成按钮
 */
-(void)searchBarCompeleteButtonClicked:(HGBSearchBar *)searchBar;
/**
 清空按钮
 */
-(void)clearButtonDidClicked:(HGBSearchBar *)searchBar;
@end

/**
 搜索框
 */
@interface HGBSearchBar : UIView
@property(strong,nonatomic)id<HGBSearchBarDelegate>delegate;
/**
 提示
 */
@property(strong,nonatomic)NSString *placeholder;
/**
 文本
 */
@property(strong,nonatomic)NSString *text;
/**
 文本颜色
 */
@property(strong,nonatomic)UIColor *textColor;
/**
 文字大小
 */
@property(assign,nonatomic)CGFloat font;
/**
 搜索图片
 */
@property(strong,nonatomic)UIImage *searchImage;
/**
 背景图片
 */
@property(strong,nonatomic)UIImage *backgroundImage;

/**
 成为第一响应者
 */
-(void)becomeFirstResponder;
/**
 取消第一响应
 */
-(void)resignFirstResponder;

@end
