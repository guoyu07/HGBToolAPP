//
//  HGBGeoPositionTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/27.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HGBGeoPositionTool : NSObject
#pragma mark - 获取地理位置信息
/**
 地理位置转地理信息

 @param coordinate 地理位置
 @param reslut 结果
 */
+(void)getLocationInfoWithCoordinate:(CLLocationCoordinate2D )coordinate andWithReslutBlock:(void(^)(BOOL status,NSDictionary *info,NSArray *infos,CLPlacemark *mark,NSArray *marks))reslut;

/**
 地理位置转地理信息

 @param location 地理位置
 @param reslut 结果
 */
+(void)getLocationInfoWithLocation:(CLLocation *)location andWithReslutBlock:(void(^)(BOOL status,NSDictionary *info,NSArray *infos,CLPlacemark *mark,NSArray *marks))reslut;
/**
 地理位置转地理信息

 @param string 搜索信息
 @param reslut 结果
 */
+(void)getLocationInfoWithString:(NSString *)string andWithReslutBlock:(void(^)(BOOL status,NSDictionary *info,NSArray *infos,CLPlacemark *mark,NSArray *marks))reslut;
@end
