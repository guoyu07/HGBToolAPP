//
//  HGBCustomKeyBordSquareTextField.m
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/22.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCustomKeyBordSquareTextField.h"

@implementation HGBCustomKeyBordSquareTextField
-(void)deleteBackward
{
    [super deleteBackward];
    if ([self.squareTextFieldDelegate respondsToSelector:@selector(deleteBackward)]) {
        [self.squareTextFieldDelegate deleteBackward];
    }
}

@end
