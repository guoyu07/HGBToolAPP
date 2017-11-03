//
//  HGBSquareTextField.m
//  密码格子
//
//  Created by huangguangbao on 2017/6/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBSquareTextField.h"

@implementation HGBSquareTextField
-(void)deleteBackward
{
    [super deleteBackward];
    if ([self.squareTextFieldDelegate respondsToSelector:@selector(deleteBackward)]) {
        [self.squareTextFieldDelegate deleteBackward];
    }
}

@end
