//
//  HGBBaiduMapAnnotationModel.h
//  测试
//
//  Created by huangguangbao on 2017/11/2.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBBaiduMapAnnotationModel : NSObject
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
