//
//  HGBCustomKeyBordTool.h
//  Keyboard
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 加密键盘工具
 */

@interface HGBCustomKeyBordTool : NSObject

+ (NSRange)rangeFromTextRange:(UITextRange *)textRange inTextField:(UITextField *)textField;
+ (UITextRange *)textRangeFromRange:(NSRange)range inTextField:(UITextField *)textField;
+ (void)setSelectedRange:(NSRange)range ofTextField:(UITextField *)textField;
+ (void)appendString:(NSString *)newString forResponder:(UITextField *)textField;
+ (void)deleteStringForResponder:(UITextField *)textField;
@end
