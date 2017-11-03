//
//  HGBLocation.m
//  测试
//
//  Created by huangguangbao on 2017/8/10.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBLocation.h"
#import <UIKit/UIKit.h>
#import "HGBLocationPromgressHud.h"

#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"


@interface HGBLocation()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;// 定位管理器
@property (nonatomic, strong) CLGeocoder *geocoder;// 地址编码

@end
@implementation HGBLocation
static HGBLocation *instance=nil;
static int flag = 0;
#pragma mark init
/**
 单例

 @return 对象
 */
+(instancetype)shareInstanceWithDelegate:(id<HGBLocationDelegate>)delegate
{
    if (instance==nil) {
        instance=[[HGBLocation alloc]initWithDelegate:delegate];

    }
    instance.delegate=delegate;
    return instance;
}
+(instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBLocation alloc]init];

    }
    return instance;
}
- (instancetype)initWithDelegate:(id<HGBLocationDelegate>)delegate
{
    self = [super init];
    if (self) {
        [self authoritySet];
        self.delegate=delegate;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self authoritySet];
    }
    return self;
}
#pragma mark func

- (void)startLocate
{
    flag = 0;
    // 设置代理
    self.locationManager.delegate = self;
    //设置精度(实时更新)
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设定频率，即每隔多少米更新一次
    CLLocationDistance myDistance = 1.0;//一米定位一次
    self.locationManager.distanceFilter = myDistance;

    // 启动自动跟踪定位
    [self.locationManager startUpdatingLocation];
}

#pragma mark - 发送位置信息
-(void)postLocation:(CLLocation *)location{
    if(location){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(loaction:didSucessWithLocation:)]){
            [self.delegate loaction:self didSucessWithLocation:location];
        }

        [self getLocationInfoWithLocation:location];
    }else{
        if(self.delegate&&[self.delegate respondsToSelector:@selector(loaction:didFailedWithError:)]){
            [self.delegate loaction:self didFailedWithError:@{ReslutCode:@(HGBLocationErrorTypeLocationError),ReslutMessage:@"定位失败"}];
        }
    }
}

#pragma mark - 获取地理位置信息
/**
 地理位置转地理信息

 @param coordinate 地理位置
 */
-(void)getLocationInfoWithCoordinate:(CLLocationCoordinate2D )coordinate{
    CLLocation *location=[[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self getLocationInfoWithLocation:location];
}
/**
 地理位置转地理信息

 @param location 地理位置
 */
-(void)getLocationInfoWithLocation:(CLLocation *)location{
    NSMutableArray *locationMarks=[NSMutableArray array];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(placemarks.count==0){
        }else{
            for(CLPlacemark *mark in placemarks){

                [locationMarks addObject:[HGBLocation transPlaceMarkToLocationInfoDic:mark]];
            }
            [self.locationManager stopUpdatingLocation];
        }
        if(error){
            NSLog(@"%@",error);
            if(self.delegate&&[self.delegate respondsToSelector:@selector(loaction:didFailedWithError:)]){
                [self.delegate loaction:self didFailedWithError:@{ReslutCode:@(HGBLocationErrorTypeLocationError),ReslutMessage:error.localizedDescription}];
            }
            return;
        }

        NSLog(@"locationMarks %@",locationMarks);
        if(locationMarks.count==0){
            if(self.delegate&&[self.delegate respondsToSelector:@selector(loaction:didFailedWithError:)]){
                [self.delegate loaction:self didFailedWithError:@{ReslutCode:@(HGBLocationErrorTypeLocationError),ReslutMessage:@"目标地址不存在"}];
            }
            return;
        }
        if(self.delegate&&[self.delegate respondsToSelector:@selector(loaction:didSucessWithLocationInfo:)]){
            [self.delegate loaction:self didSucessWithLocationInfo:[locationMarks lastObject]];
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

#pragma mark - CLLocationManagerDelegate
//定位更新
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    //经纬度
    NSLog(@"当前位置:纬度-%f 经度-%f",location.coordinate.latitude,location.coordinate.longitude);
    if(flag == 0){
        [self postLocation:location];
    }
    flag++;
    [self.locationManager stopUpdatingLocation];
}

//探测位置失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"探测失败:%@",error);
    NSLog(@"Error: %@",[error localizedDescription]);
    NSString *promptString=@"";
    switch([error code]) {
        case kCLErrorDenied:{

           promptString=@"定位失败:请到设置隐私中开启本程序定位权限";
            if(self.delegate&&[self.delegate respondsToSelector:@selector(loaction:didFailedWithError:)]){
                [self.delegate loaction:self didFailedWithError:@{ReslutCode:@(HGBLocationErrorTypeAuthority),ReslutMessage:promptString}];
            }

        }
            break;
        case kCLErrorLocationUnknown:{
           promptString=@"定位失败，请刷新数据";
            if(self.delegate&&[self.delegate respondsToSelector:@selector(loaction:didFailedWithError:)]){
                [self.delegate loaction:self didFailedWithError:@{ReslutCode:@(HGBLocationErrorTypeLocationError),ReslutMessage:promptString}];
            }
        }
            break;
        default:{
           promptString=@"定位失败，请刷新数据";
            if(self.delegate&&[self.delegate respondsToSelector:@selector(loaction:didFailedWithError:)]){
                [self.delegate loaction:self didFailedWithError:@{ReslutCode:@(HGBLocationErrorTypeLocationError),ReslutMessage:promptString}];
            }
        }
            break;
    }
    [HGBLocationPromgressHud  showHUDResult:promptString ToView:[UIApplication sharedApplication].keyWindow];

    [self.locationManager stopUpdatingLocation];
}

// IOS8 新增方法,授权状态改变
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
    }
}
#pragma mark 权限申请
-(void)authoritySet{
    float version=[[[UIDevice currentDevice] systemVersion]floatValue];
    if(self.allowBackGroundLocation){
        //权限
        if(version>=9.0){
             //9.0之前仅打开capabilities-backgroundmode-location即可
            self.locationManager.allowsBackgroundLocationUpdates=YES;
            //位置管理对象中有requestAlwaysAuthorization这个行为NSLocationAlwaysUsageDescription
            if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){//位置管理对象中有requestAlwaysAuthorization这个行为
                [self.locationManager requestAlwaysAuthorization];
            }
        }
    }
//    定位
    if(version>=8.0){

        //NSLocationWhenInUseUsageDescription
        [self.locationManager requestWhenInUseAuthorization];
    }
}
#pragma mark getter 
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
@end
