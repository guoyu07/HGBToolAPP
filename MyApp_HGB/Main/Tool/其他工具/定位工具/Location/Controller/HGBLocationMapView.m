//
//  HGBLocationMapView.m
//  测试
//
//  Created by huangguangbao on 2017/8/10.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBLocationMapView.h"
#import <MapKit/MapKit.h>
#import "HGBLocationPromgressHud.h"
#import "HGBLocationCoordinateTool.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号

//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0

#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"

@interface HGBLocationMapView ()<CLLocationManagerDelegate,MKMapViewDelegate>
/**
 地图
 */
@property (strong, nonatomic) MKMapView *mapView;
/**
 定位工具
 */
@property(strong,nonatomic) CLLocationManager *locationManager;
/**
 地理编码工具
 */
@property (nonatomic, strong) CLGeocoder *geocoder;

/**
 定位标志
 */
@property(nonatomic,assign)BOOL locationFlag;
/**
 标记
 */
@property(strong,nonatomic)UIImageView *annotationImageView;
/**
 位置
 */
@property(assign,nonatomic)CGPoint point;
/**
 地图比例按钮
 */
@property(strong,nonatomic)UIStepper* stepper;

@end

@implementation HGBLocationMapView
static int proportion=1000;
#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavBar];
    [self setAuthority];
    [self createMapView];
    [self addFuncToMap];


}
#pragma mark nav
-(void)setNavBar{
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.text=@"地图";
    titleLab.textColor=[UIColor whiteColor];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    self.navigationItem.titleView=titleLab;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(returnHanler:)];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:16.0/256 green:149.0/256 blue:239.9/256 alpha:1]];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(pilotHandle:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

}
-(void)returnHanler:(UIBarButtonItem *)_b{
    dispatch_async(dispatch_get_global_queue(0, 2), ^{
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mapviewDidCanceled:)]){
            [self.delegate mapviewDidCanceled:self];
        }
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)pilotHandle:(UIBarButtonItem *)_b{
    CLLocationCoordinate2D coordinate=[self.mapView convertPoint:self.point toCoordinateFromView:self.mapView];
    CLLocation *location=[[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mapview:didSucessWithLocation:)]){
        [self.delegate mapview:self didSucessWithLocation:location];
    }
    coordinate=[HGBLocationCoordinateTool transformFromGCJToWGS:coordinate];
    dispatch_async(dispatch_get_global_queue(0, 2), ^{
        [self getPlaceMarkWithAnnotationCoordinate:coordinate];
    });

    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark map
-(void)createMapView{
    self.locationFlag=NO;
    self.mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [self.view addSubview:self.mapView];
    //地图类型
    self.mapView.mapType=MKMapTypeStandard;//混合
    //显示用户位置
    self.mapView.showsUserLocation=YES;
    self.mapView.showsScale=YES;

    self.mapView.showsTraffic=YES;
    self.mapView.showsBuildings=YES;
    //    self.mapView
    //用户跟踪模式
    self.mapView.userTrackingMode=MKUserTrackingModeNone;
    self.mapView.delegate=self;
    //滚动
    self.mapView.scrollEnabled=YES;
    //旋转
    self.mapView.rotateEnabled=YES;
    //缩放
    self.mapView.zoomEnabled=YES;
    //
    self.mapView.pitchEnabled=NO;
    self.annotationImageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 64*wScale, 64*hScale)];
    self.annotationImageView.image=[UIImage imageNamed:@"HGBLocationBundle.bundle/location_annotationImageView.png"];
//    [self.mapView addSubview:self.annotationImageView];
}
#pragma mark 为地图添加功能
-(void)addFuncToMap{
    //放大缩小按钮
    self.stepper=[[UIStepper alloc]initWithFrame:CGRectMake(kWidth-120,kHeight-80,50,20)];
    self.stepper.tintColor=[UIColor grayColor];
    self.stepper.backgroundColor=[UIColor whiteColor];
    self.stepper.maximumValue=2000;
    self.stepper.minimumValue=0;
    self.stepper.value=1000;
    self.stepper.stepValue=1;
    self.stepper.autorepeat=YES;
    self.stepper.wraps=YES;
    self.stepper.continuous=YES;
    [self.stepper addTarget:self action:@selector(stepperHandle:) forControlEvents:UIControlEventValueChanged];
    [self.mapView addSubview:self.stepper];


    //定位按钮
    UIButton *locationButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
    locationButton.frame=CGRectMake(658*wScale,64+20*hScale,72*wScale, 72*hScale);
    [locationButton setImage:[UIImage imageNamed:@"HGBLocationBundle.bundle/icon_normal_dingwei.png"] forState:(UIControlStateNormal)];
    [locationButton setImage:[UIImage imageNamed:@"HGBLocationBundle.bundle/icon_pressed_dingwei.png"] forState:(UIControlStateHighlighted)];
    locationButton.backgroundColor=[UIColor whiteColor];
    [locationButton addTarget:self action:@selector(locationButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mapView addSubview:locationButton];


}

#pragma mark 地图缩放功能
//地图缩放
-(void)stepperHandle:(UIStepper *)_s
{
    //坐标
    CLLocationCoordinate2D coordinate;
    MKCoordinateSpan span;
    coordinate=self.mapView.region.center;

    if(_s.value>proportion){
        span.latitudeDelta=0.5*self.mapView.region.span.latitudeDelta;
        span.longitudeDelta=0.5*self.mapView.region.span.longitudeDelta;
    }else{
        span.latitudeDelta=2*self.mapView.region.span.latitudeDelta;
        span.longitudeDelta=2*self.mapView.region.span.longitudeDelta;
    }
    MKCoordinateRegion region ={coordinate,span};
    if(_s.value<proportion){
        if(coordinate.latitude>=0){
            if((self.mapView.region.span.latitudeDelta+coordinate.latitude)>=90){
                _s.value=proportion;
                return;
            }
        }else{
            if((-self.mapView.region.span.latitudeDelta+coordinate.latitude)<=-90){
                _s.value=proportion;
                return;
            }
        }
        if(coordinate.longitude>=0){
            if((coordinate.longitude+self.mapView.region.span.longitudeDelta)>=180){
                _s.value=proportion;
                return;
            }
        }else{
            if((coordinate.longitude-self.mapView.region.span.longitudeDelta)<=-180){
                _s.value=proportion;
                return;
            }
        }

    }
    proportion=_s.value;
    [self.mapView setRegion:region];
}
#pragma mark 定位功能
-(void)locationButtonAction:(UIButton *)_b{
    self.locationFlag=NO;
    [self.locationManager startUpdatingLocation];
}
#pragma mark pop
-(void)popInParent:(UIViewController *)parent{
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:self];
    [parent presentViewController:nav animated:YES completion:nil];
}
#pragma mark 位置工具
//地理位置反编译-坐标转地理信息
-(void)getPlaceMarkWithAnnotationCoordinate:(CLLocationCoordinate2D )coordinate{
    CLLocation *location=[[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];

     NSMutableArray *locationMarks=[NSMutableArray array];

    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        CLPlacemark *placemark = [placemarks firstObject];
        if(placemarks.count==0){
        }else{
            for(CLPlacemark *mark in placemarks){

                [locationMarks addObject:[self transPlaceMarkToLocationInfoDic:mark]];
            }
            [self.locationManager stopUpdatingLocation];
        }
        if(error){
            NSLog(@"%@",error);
            if(self.delegate&&[self.delegate respondsToSelector:@selector(mapview:didFailedWithError:)]){
                [self.delegate mapview:self didFailedWithError:@{ReslutCode:@(HGBLocationMapViewErrorTypeLocationError),ReslutMessage:error.localizedDescription}];
            }
            return;
        }

        NSLog(@"locationMarks %@",locationMarks);
        if(locationMarks.count==0){
            if(self.delegate&&[self.delegate respondsToSelector:@selector(mapview:didFailedWithError:)]){
                [self.delegate mapview:self didFailedWithError:@{ReslutCode:@(HGBLocationMapViewErrorTypeLocationError),ReslutMessage:@"目标地址不存在"}];
            }

            return;
        }
        dispatch_async(dispatch_get_global_queue(0, 2), ^{
            if(self.delegate&&[self.delegate respondsToSelector:@selector(mapview:didSucessWithLocationInfo:)]){
                [self.delegate mapview:self didSucessWithLocationInfo:[locationMarks lastObject]];
            }
        });

        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
// 转换地理位置信息为字典
-(NSDictionary *)transPlaceMarkToLocationInfoDic:(CLPlacemark *)mark{
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
#pragma mark locationdelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location=[locations firstObject];
    if(self.locationFlag==NO){
        self.locationFlag=YES;
        CLLocationCoordinate2D coordinate=[location coordinate];
        coordinate=[HGBLocationCoordinateTool transformFromWGSToGCJ:coordinate];
        MKCoordinateSpan span;
        span.latitudeDelta=0.01;
        span.longitudeDelta=0.01;
        //区域
        MKCoordinateRegion region ={coordinate,span};
        [self.mapView setRegion:region];
        [self.locationManager stopUpdatingLocation];
    }
}
//探测位置失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    NSLog(@"探测失败");
    NSLog(@"Error: %@",[error localizedDescription]);
    NSString *promptString=@"";
    switch([error code]) {
        case kCLErrorDenied:{
            promptString=@"定位失败:请到设置隐私中开启本程序定位权限";

        }
            break;
        case kCLErrorLocationUnknown:{
            promptString=@"定位失败，请刷新数据";
        }
            break;
        default:{
            promptString=@"定位失败，请刷新数据";
        }
            break;
    }
    [HGBLocationPromgressHud  showHUDResult:promptString ToView:[UIApplication sharedApplication].keyWindow];
    [HGBLocationPromgressHud  showHUDResult:@"定位失败" ToView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark mapdelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocation *location=userLocation.location;


    if(self.locationFlag==NO){
        NSLog(@"%@",location);
        self.locationFlag=YES;
        CLLocationCoordinate2D coordinate=[location coordinate];
        MKCoordinateSpan span;
        span.latitudeDelta=0.01;
        span.longitudeDelta=0.01;
        //区域
        MKCoordinateRegion region ={coordinate,span};
        [self.mapView setRegion:region];
        self.point=[self.mapView convertCoordinate: region.center toPointToView:self.mapView];
        self.annotationImageView.frame=CGRectMake(self.point.x-CGRectGetWidth(self.annotationImageView.frame)*0.5, self.point.y-CGRectGetHeight(self.annotationImageView.frame)-20, CGRectGetWidth(self.annotationImageView.frame), CGRectGetHeight(self.annotationImageView.frame));
        [self.mapView addSubview:self.annotationImageView];
        NSLog(@"%.10f-%.10f",coordinate.latitude,coordinate.longitude);
        [self.locationManager stopUpdatingLocation];
    }

}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{

    [UIView animateWithDuration:0.1 animations:^{
        self.annotationImageView.frame=CGRectMake(self.annotationImageView.frame.origin.x, self.annotationImageView.frame.origin.y-20, self.annotationImageView.frame.size.width, self.annotationImageView.frame.size.height);
    } completion:^(BOOL finished) {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeHandle:) userInfo:nil repeats:NO];
    }];
}
-(void)timeHandle:(NSTimer *)_t{
    [UIView animateWithDuration:0.1 animations:^{
        self.annotationImageView.frame=CGRectMake(self.annotationImageView.frame.origin.x, self.annotationImageView.frame.origin.y+20, self.annotationImageView.frame.size.width, self.annotationImageView.frame.size.height);
        self.navigationItem.rightBarButtonItem.enabled=YES;
    }];
}
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    self.navigationItem.rightBarButtonItem.enabled=NO;
}

-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    [HGBLocationPromgressHud  showHUDResult:@"地图加载失败" ToView:[UIApplication sharedApplication].keyWindow];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mapview:didFailedWithError:)]){
        [self.delegate mapview:self didFailedWithError:@{ReslutCode:@(HGBLocationMapViewErrorTypeLocationError),ReslutMessage:@"定位失败"}];
    }
}
#pragma mark 权限
-(void)setAuthority{
    float version=[[[UIDevice currentDevice] systemVersion]floatValue];
    //权限
    if(version>=8.0){
        //位置管理对象中有requestAlwaysAuthorization这个行为NSLocationAlwaysUsageDescription
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){//位置管理对象中有requestAlwaysAuthorization这个行为
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    //后台定位
    if(version>=9.0){
        self.locationManager.allowsBackgroundLocationUpdates=YES;
        //8.0之前仅打开capabilities-backgroundmode-location即可
        //NSLocationWhenInUseUsageDescription
        [self.locationManager requestWhenInUseAuthorization];
    }


    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.delegate=self;
}


#pragma mark get
-(CLLocationManager *)locationManager
{
    if(_locationManager==nil){
        _locationManager=[[CLLocationManager alloc]init];
        [_locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}
-(CLGeocoder *)geocoder{
    if(_geocoder==nil){
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}
@end
