//
//  HGBLocationCoordinateTool.h
//  测试
//
//  Created by huangguangbao on 2017/8/11.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface HGBLocationCoordinateTool : NSObject
#pragma mark 地理位置转距离
/**
 经纬度转化距离

 @param lat1 纬度1
 @param lng1 经度1
 @param lat2 纬度2
 @param lng2 经度2
 @return 距离
 */
+(double)distanceBetweenOrderByCurrentLocationLatitude:(double)lat1 Longitude:(double)lng1 andWithOtherLocationLatitude:(double)lat2 Longitude:(double)lng2;
/**
 地理位置转化距离

 @param curCoordinate 地理位置1
 @param otherCoordinate 地理位置2
 @return 距离
 */
+(double)distanceBetweenOrderByCurrentCoordinate2D:(CLLocationCoordinate2D)curCoordinate ToOtherCoordinate2D:(CLLocationCoordinate2D)otherCoordinate;
#pragma mark 地理位置纠错
/**
 wgs坐标转化为gcj坐标

 @param wgsLoc wgs坐标
 @return gcj坐标
 */
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;
/**
 gcj坐标转化为wgs坐标

 @param p gcj坐标
 @return wgs坐标
 */
+(CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)p;
/**
 gcj坐标转化为百度坐标

 @param p gcj坐标
 @return 百度坐标
 */
+(CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)p;
/**
 百度坐标转化为gcj坐标

 @param p 百度坐标
 @return gcj坐标
 */
+(CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)p;

@end
