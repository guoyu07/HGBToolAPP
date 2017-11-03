//
//  HGBGeoPositionTool.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/27.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBGeoPositionTool.h"
#import <CoreLocation/CoreLocation.h>

#define ErrorCode @"errorCode"
#define ErrorMessage @"errorMessage"
#define Error @"error"

@implementation HGBGeoPositionTool
#pragma mark - 获取地理位置信息
/**
 地理位置转地理信息

 @param coordinate 地理位置
 @param reslut 结果
 */
+(void)getLocationInfoWithCoordinate:(CLLocationCoordinate2D )coordinate andWithReslutBlock:(void(^)(BOOL status,NSDictionary *info,NSArray *infos,CLPlacemark *mark,NSArray *marks))reslut{
    CLLocation *location=[[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [HGBGeoPositionTool getLocationInfoWithLocation:location andWithReslutBlock:reslut];
}

/**
 地理位置转地理信息

 @param location 地理位置
 @param reslut 结果
 */
+(void)getLocationInfoWithLocation:(CLLocation *)location andWithReslutBlock:(void(^)(BOOL status,NSDictionary *info,NSArray *infos,CLPlacemark *mark,NSArray *marks))reslut{

    NSMutableArray *locationMarks=[NSMutableArray array];
     CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(placemarks.count==0){
        }else{
            for(CLPlacemark *mark in placemarks){

                [locationMarks addObject:[HGBGeoPositionTool transPlaceMarkToLocationInfoDic:mark]];
            }

        }
        if(error){
            reslut(NO,@{ErrorCode:@(error.code),ErrorMessage:error.localizedDescription,Error:error},nil,nil,nil);
            NSLog(@"%@",error);
            return;
        }

        NSLog(@"locationMarks %@",locationMarks);
        if(locationMarks.count==0){
            reslut(NO,@{ErrorCode:@(0),ErrorMessage:@"目标地址不存在"},nil,nil,nil);
        }else{
            NSDictionary *dic=[locationMarks lastObject];
            reslut(NO,dic,locationMarks,[placemarks lastObject],placemarks);
        }
        
    }];
}
/**
 地理位置转地理信息

 @param string 搜索信息
 @param reslut 结果
 */
+(void)getLocationInfoWithString:(NSString *)string andWithReslutBlock:(void(^)(BOOL status,NSDictionary *info,NSArray *infos,CLPlacemark *mark,NSArray *marks))reslut{
    if(string==nil||string.length==0){

    }
    NSMutableArray *locationMarks=[NSMutableArray array];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];

    [geocoder geocodeAddressString:string completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(placemarks.count==0){
        }else{
            for(CLPlacemark *mark in placemarks){

                [locationMarks addObject:[HGBGeoPositionTool transPlaceMarkToLocationInfoDic:mark]];
            }

        }
        if(error){
            reslut(NO,@{ErrorCode:@(error.code),ErrorMessage:error.localizedDescription,Error:error},nil,nil,nil);
            NSLog(@"%@",error);
            return;
        }

        NSLog(@"locationMarks %@",locationMarks);
        if(locationMarks.count==0){
            reslut(NO,@{ErrorCode:@(0),ErrorMessage:@"目标地址不存在"},nil,nil,nil);
        }else{
            NSDictionary *dic=[locationMarks lastObject];
            reslut(NO,dic,locationMarks,[placemarks lastObject],placemarks);
        }
    }];

}
#pragma mark - 转换地理位置信息为字典
+(NSDictionary *)transPlaceMarkToLocationInfoDic:(CLPlacemark *)mark{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if(mark.locality){
        [dic setObject:mark.locality  forKey:@"city"];
    }
    NSArray *AddressArr=[mark.addressDictionary objectForKey:@"FormattedAddressLines"];

    NSString *str=[AddressArr firstObject];
    if(str){
        [dic setObject:str  forKey:@"address"];
    }

    [dic setValue:@(mark.location.coordinate.latitude).stringValue forKey:@"latitude"];
    [dic setValue:@(mark.location.coordinate.longitude).stringValue forKey:@"longitude"];
    NSLog(@"%@",dic);
    return dic;
}

@end
