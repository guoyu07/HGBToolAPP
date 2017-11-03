//
//  HGBCustomKeyBordSquareTextField.h
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/22.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HGBCustomKeyBordSquareTextFieldDelegate <NSObject>

@optional
-(void)deleteBackward;
@end

@interface HGBCustomKeyBordSquareTextField : UITextField
@property(assign,nonatomic)id<HGBCustomKeyBordSquareTextFieldDelegate>squareTextFieldDelegate;
@end
