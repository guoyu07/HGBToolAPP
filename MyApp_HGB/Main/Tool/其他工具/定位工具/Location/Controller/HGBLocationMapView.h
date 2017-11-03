//
//  HGBLocationMapView.h
//  测试
//
//  Created by huangguangbao on 2017/8/10.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

/**
 错误类型
 */
typedef enum HGBLocationMapViewErrorType
{
    HGBLocationMapViewErrorTypeLocationError,//定位失败
    HGBLocationMapViewErrorTypeAuthority//权限受限

}HGBLocationMapViewErrorType;

@class HGBLocationMapView;
@protocol HGBLocationMapViewDelegate <NSObject>
@optional
/**
 定位成功返回地址

 @param mapview 控件
 @param location 地址
 */
-(void)mapview:(HGBLocationMapView *)mapview didSucessWithLocation:(CLLocation *)location;
/**
 定位失败

 @param mapview 控件
 */
-(void)mapview:(HGBLocationMapView *)mapview didFailedWithError:(NSDictionary *)errorInfo;
/**
 定位成功返回地址

 @param mapview 控件
 @param locationInfo 地址信息
 */
-(void)mapview:(HGBLocationMapView *)mapview didSucessWithLocationInfo:(NSDictionary *)locationInfo;
/**
 定位取消

 @param mapview 控件
 */
-(void)mapviewDidCanceled:(HGBLocationMapView *)mapview;

@end

@interface HGBLocationMapView : UIViewController
@property (nonatomic, strong) id<HGBLocationMapViewDelegate> delegate;
/**
 跳转

 @param parent 父控制器
 */
-(void)popInParent:(UIViewController *)parent;
@end
