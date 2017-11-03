//
//  HGBCustomKeyBordTool.m
//  Keyboard
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCustomKeyBordTool.h"

@implementation HGBCustomKeyBordTool

+ (NSRange)rangeFromTextRange:(UITextRange *)textRange inTextField:(UITextField *)textField{
    
    UITextPosition* beginning = textField.beginningOfDocument;
    UITextPosition* start = textRange.start;
    UITextPosition* end = textRange.end;
    
    const NSInteger location = [textField offsetFromPosition:beginning toPosition:start];
    const NSInteger length = [textField offsetFromPosition:start toPosition:end];
    
    return NSMakeRange(location, length);
}
+ (UITextRange *)textRangeFromRange:(NSRange)range inTextField:(UITextField *)textField{
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *startPosition = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [textField positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [textField textRangeFromPosition:startPosition toPosition:endPosition];
    return selectionRange;
}
+ (void)setSelectedRange:(NSRange)range ofTextField:(UITextField *)textField{
    
    UITextRange *selectionRange = [self textRangeFromRange:range inTextField:textField];
    [textField setSelectedTextRange:selectionRange];
}
+ (void)appendString:(NSString *)newString forResponder :(UITextField *)textField{
    
    NSRange selectRange = [HGBCustomKeyBordTool rangeFromTextRange:textField.selectedTextRange inTextField:textField];
    
    BOOL shouldChange = YES;
    if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        shouldChange = [textField.delegate textField:textField shouldChangeCharactersInRange:selectRange replacementString:newString];
    }
    if (!shouldChange) return;
    
    [textField insertText:newString];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:textField userInfo:nil];
}
+ (void)deleteStringForResponder:(UITextField *)textField{
    
    [textField deleteBackward];
}
@end
