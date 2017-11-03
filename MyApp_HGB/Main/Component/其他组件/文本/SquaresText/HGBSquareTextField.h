//
//  HGBSquareTextField.h
//  密码格子
//
//  Created by huangguangbao on 2017/6/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HGBSquareTextFieldDelegate <NSObject>

@optional
-(void)deleteBackward;
@end
@interface HGBSquareTextField : UITextField
@property(assign,nonatomic)id<HGBSquareTextFieldDelegate>squareTextFieldDelegate;
@end
