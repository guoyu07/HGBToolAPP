//
//  HGBCustomKeyBordSquareTextView.h
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/22.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGBCustomKeyBordSquareTextView;
@protocol HGBCustomKeyBordSquareTextViewDelegate <NSObject>

@optional
-(void)squaresTextView:(HGBCustomKeyBordSquareTextView *)squaresText didFinishWithResult:(NSString *)result;

@end

@interface HGBCustomKeyBordSquareTextView : UITextField
@property(strong,nonatomic)id<HGBCustomKeyBordSquareTextViewDelegate>squareViewDelegate;
@property(strong,nonatomic)UIView *keybord;
/**
 初始化
 
 @param frame 大小
 @param length 输入数据长度
 @return 实例
 */
-(instancetype)initWithFrame:(CGRect)frame length:(NSInteger)length;
@end
