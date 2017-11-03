//
//  HGBWordKeyBord.h
//  Keyboard
//
//  Created by huangguangbao on 16/11/2.
//  Copyright © 2016年 xuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBCustomKeyBordHeader.h"

/**
 字母键盘代理
 */
@protocol HGBWordKeyboardDelegate <NSObject>

@required
/**
 按钮点击

 @param btn 按钮
 */
- (void)keyboardWordPadDidClickSwitchBtn:(UIButton *)btn;
/**
 按钮点击返回信息
 
 @param message 按钮信息
 */
-(void)keyboardWordPadReturnMessage:(NSString *)message;

@end

/**
 字母键盘
 */
@interface HGBWordKeyBord : UIView

/**
 随机
 */
@property (nonatomic, assign) BOOL random;
@property (nonatomic, assign) id <HGBWordKeyboardDelegate> delegate;
/**
 相应
 */
@property (nonatomic, weak)   UITextField *responder;
@property(assign,nonatomic)HGBCustomKeyBordType keybordType;
/**
 按钮数组
 */
@property (nonatomic, strong) NSMutableArray *btnArray;
/**
 小写字符数组
 */
@property (nonatomic, strong) NSArray  *wordArray;
/**
 大写字符数组
 */
@property (nonatomic, strong) NSArray  *WORDArray;

@end
