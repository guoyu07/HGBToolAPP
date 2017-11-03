//
//  HGBNumKeyBord.h
//  Keyboard
//
//  Created by huangguangbao on 16/11/2.
//  Copyright © 2016年 xuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBCustomKeyBordHeader.h"

/**
 数字键盘代理
 */
@protocol HGBNumKeyboardDelegate  <NSObject>
@required
/**
 转换按钮点击

 */
- (void)keyboardNumPadDidClickSwitchBtn:(UIButton *)btn;
/**
 按钮点击返回信息

 @param message 按钮信息
 */
-(void)keyboardNumPadReturnMessage:(NSString *)message;

@end


/**
 数字键盘
 */
@interface HGBNumKeyBord : UIView
/**
 是否随机
 */
@property (nonatomic, assign) BOOL random;
@property(assign,nonatomic)HGBCustomKeyBordType keybordType;

@property (nonatomic, assign) id <HGBNumKeyboardDelegate> delegate;
/**
 按钮数组
 */
@property (nonatomic, strong) NSMutableArray *btnArray;
/**
 相应
 */
@property (nonatomic, weak)   UITextField *responder;
/**
 数字数组
 */
@property (nonatomic, strong) NSArray *numArray;
/**
 选中
 */
@property (nonatomic, assign) NSRange selectedRange;
@end
