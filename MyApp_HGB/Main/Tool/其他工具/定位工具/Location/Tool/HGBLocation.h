//
//  HGBLocation.h
//  测试
//
//  Created by huangguangbao on 2017/8/10.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


/**
 错误类型
 */
typedef enum HGBLocationErrorType
{
    HGBLocationErrorTypeLocationError,//定位失败
    HGBLocationErrorTypeAuthority//权限受限

}HGBLocationErrorType;
@class HGBLocation;
@protocol HGBLocationDelegate <NSObject>
@optional
/**
 定位成功返回地址

 @param hgblocation 控件
 @param location 地址
 */
-(void)loaction:(HGBLocation *)hgblocation didSucessWithLocation:(CLLocation *)location;
/**
 定位失败

 @param hgblocation 控件
 */
-(void)loaction:(HGBLocation *)hgblocation didFailedWithError:(NSDictionary *)errorInfo;
/**
 定位成功返回地址

 @param hgblocation 控件
 @param locationInfo 地址信息
 */
-(void)loaction:(HGBLocation *)hgblocation didSucessWithLocationInfo:(NSDictionary *)locationInfo;

@end

@interface HGBLocation : NSObject
/**
 代理
 */
@property(nonatomic,assign)id<HGBLocationDelegate>delegate;
/**
 是否允许后台定位
 */
@property(nonatomic,assign)BOOL allowBackGroundLocation;

#pragma mark init
/**
 单例

 @return 对象
 */
+(instancetype)shareInstanceWithDelegate:(id<HGBLocationDelegate>)delegate;
/**
 单例

 @return 对象
 */
+(instancetype)shareInstance;
/**
 开始定位
 */
- (void)startLocate;
#pragma mark - 获取地理位置信息
/**
 地理位置转地理信息

 @param location 地理位置
 */
-(void)getLocationInfoWithLocation:(CLLocation *)location;
/**
 地理位置转地理信息

 @param coordinate 地理位置
 */
-(void)getLocationInfoWithCoordinate:(CLLocationCoordinate2D )coordinate;
@end
