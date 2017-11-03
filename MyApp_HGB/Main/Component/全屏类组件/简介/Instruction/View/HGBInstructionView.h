//
//  HGBInstructionView.h
//  CTTX
//
//  Created by huangguangbao on 2017/3/3.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 分条文本
 */
@interface HGBInstructionView : UIView
/**
 标题
 */
@property(nonatomic,strong)NSString *name;
/**
 提示字符串
 */
@property(strong,nonatomic)NSString *promptStr;
/**
 副标题
 */
@property(strong,nonatomic)NSArray *subTitles;
/**
 init方法
 */
- (instancetype)initWithFrame:(CGRect)frame andWithTitle:(NSString *)title andWithSubTitles:(NSArray *)subTitles andWithPrompt:(NSString *)prompt;

@end
