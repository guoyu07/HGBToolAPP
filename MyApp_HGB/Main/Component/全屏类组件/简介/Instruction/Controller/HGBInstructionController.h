//
//  HGBInstructionController.h
//  CTTX
//
//  Created by huangguangbao on 2017/3/3.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 分条文本
 */
@interface HGBInstructionController : UIViewController
/**
 标题
 */
@property(nonatomic,strong)NSString *name;
/**
 内容
 */
@property(strong,nonatomic)NSString *promptStr;
/**
 副标题
 */
@property(strong,nonatomic)NSArray *subTitles;
/**
 导航栏创建
 
 @param title 标题
 */
-(void)createNavigationItemWithTitle:(NSString *)title;
@end
