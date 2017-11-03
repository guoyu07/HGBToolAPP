//
//  HGBCustomKeyBordButton.h
//  Keyboard
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HGBCustomKeyBordButton;
/**
 键盘按钮代理
 */
@protocol HGBCustomKeyboardButtonDelegate <NSObject>
@required
/**
 按钮点击
 
 @param button 按钮
 */
- (void)keyboardButtonDidClick:(HGBCustomKeyBordButton *)button;
@end
/**
 键盘按钮
 */
@interface HGBCustomKeyBordButton : UIButton
@property (nonatomic, assign) id <HGBCustomKeyboardButtonDelegate> delegate;
/**
 创建按钮
 */
+ (HGBCustomKeyBordButton *)buttonWithTitle:(NSString *)title tag:(NSInteger)tag  delegate:(id)delegate;
@end
