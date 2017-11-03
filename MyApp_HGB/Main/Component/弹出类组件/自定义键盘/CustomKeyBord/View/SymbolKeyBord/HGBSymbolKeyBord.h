//
//  HGBSymbolKeyBord.h
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBCustomKeyBordHeader.h"
@protocol HGBSymbolKeyBordDelegate<NSObject>

@required
/**
 转换按钮点击

 @param btn 按钮
 */
- (void)keyboardSymbolPadDidClickSwitchBtn:(UIButton *)btn;

/**
 按钮点击返回信息
 
 @param message 按钮信息
 */
-(void)keyboardSymbolPadReturnMessage:(NSString *)message;

@end

@interface HGBSymbolKeyBord : UIView
@property(assign,nonatomic)HGBCustomKeyBordType keybordType;

@property (nonatomic, assign) BOOL random;
@property (nonatomic, assign) id <HGBSymbolKeyBordDelegate> delegate;
@property (nonatomic, weak)   UITextField *responder;
/**
 标点集合
 */
@property (nonatomic, strong) NSArray *symbolArray;
/**
 按钮集合
 */
@property (nonatomic, strong) NSMutableArray *btnArray;
@end
