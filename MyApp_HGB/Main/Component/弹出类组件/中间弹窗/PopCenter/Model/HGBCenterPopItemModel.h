//
//  HGBCenterPopItemModel.h
//  CTTX
//
//  Created by huangguangbao on 16/12/28.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
  中心弹出视图模型
 */
@interface HGBCenterPopItemModel : NSObject
/**
   标记
 */
@property(strong,nonatomic)NSString *idx;
/**
   提示图
 */
@property(strong,nonatomic)UIImage *promptImage;
/**
   提示标题
 */
@property(strong,nonatomic)NSString *promptTitle;
/**
   指示图
 */
@property(strong,nonatomic)UIImage *indicatorImage;

@end
