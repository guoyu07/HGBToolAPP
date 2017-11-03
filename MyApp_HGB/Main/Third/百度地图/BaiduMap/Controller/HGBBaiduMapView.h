//
//  HGBBaiduMapView.h
//  测试
//
//  Created by huangguangbao on 2017/10/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>


#import "HGBBaiduMapAnnotationModel.h"



@interface HGBBaiduMapView : UIViewController

@property (strong, nonatomic) BMKMapView *mapView;
/**
 类型-预留
 */
@property(assign,nonatomic)NSInteger type;
/**
 功能类型
 */
@property(assign,nonatomic)NSInteger functype;
/**
 定位位置信息
 */
@property (nonatomic, retain)CLLocation *location;
/**
 导航起点位置
 */
@property(assign,nonatomic)CLLocationCoordinate2D startCoordinate;//起始点位置
/**
 导航终点位置
 */
@property(assign,nonatomic)CLLocationCoordinate2D stopCoordinate;//终点位置

#pragma mark 功能
/**
 导航栏

 @param title 标题
 */
-(void)createNavigationItemWithTitle:(NSString *)title;
/**
 设置大头针

 @param annotations 大头针集合 lat纬度 lng经度
 */
-(void)setAnnotations:(NSArray<HGBBaiduMapAnnotationModel *> *)annotations;
/**
 添加大头针

 @param annotations 大头针集合 lat纬度 lng经度
 */
-(void)addAnnotations:(NSArray<HGBBaiduMapAnnotationModel *> *)annotations;
/**
 删除大头针

 @param annotations 大头针集合 lat纬度 lng经度
 */
-(void)removeAnnotations:(NSArray<HGBBaiduMapAnnotationModel *> *)annotations;
@end
