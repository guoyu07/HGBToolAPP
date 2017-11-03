//
//  HGBNumOnlyKeyBord.h
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 数字键盘代理
 */
@protocol HGBNumOnlyKeyBordDelegate  <NSObject>
@required
/**
 转换按钮点击
 
 */
- (void)keyboardOnlyNumPadDidClickSwitchBtn:(UIButton *)btn;
/**
 按钮点击返回信息
 
 @param message 按钮信息
 */
-(void)keyboardOnlyNumPadReturnMessage:(NSString *)message;

@end
/**
 纯数字键盘
 */
@interface HGBNumOnlyKeyBord : UIView
@property(assign,nonatomic)id<HGBNumOnlyKeyBordDelegate>delegate;
/**
 是否随机
 */
@property (nonatomic, assign) BOOL random;
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
