//
//  HGBMapAnnotationModel.h
//  测试
//
//  Created by huangguangbao on 2017/10/11.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBMapAnnotationModel : NSObject
/**
 id
 */
@property(strong,nonatomic)NSString *id;
/**
 纬度
 */
@property(strong,nonatomic)NSString *lat;
/**
 经度
 */
@property(strong,nonatomic)NSString *lng;
/**
 标题
 */
@property(strong,nonatomic)NSString *title;
@end
