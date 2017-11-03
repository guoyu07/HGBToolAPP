//
//  HGBBaseView.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/25.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGBBaseView : UIView
/**
 界面大小
 */
@property(assign,nonatomic)CGRect frameRect;
/**
 界面设置
 */
-(void)viewSetUp;

@end
