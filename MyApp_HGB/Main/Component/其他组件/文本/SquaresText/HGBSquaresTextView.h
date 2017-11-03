//
//  HGBSquaresTextView.h
//  密码格子
//
//  Created by huangguangbao on 2017/6/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGBSquaresTextView;
@protocol HGBSquaresTextViewDelegate <NSObject>

@optional
-(void)squaresTextView:(HGBSquaresTextView *)squaresText didFinishWithResult:(NSString *)result;

@end
@interface HGBSquaresTextView : UITextField
@property(strong,nonatomic)id<HGBSquaresTextViewDelegate>squareViewDelegate;
@property(strong,nonatomic)UIView *keybord;
/**
 初始化

 @param frame 大小
 @param length 输入数据长度
 @return 实例
 */
-(instancetype)initWithFrame:(CGRect)frame length:(NSInteger)length;
@end
