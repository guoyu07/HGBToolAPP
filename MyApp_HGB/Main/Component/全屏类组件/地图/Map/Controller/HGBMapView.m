//
//  HGBMapView.m
//  测试
//
//  Created by huangguangbao on 2017/10/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBMapView.h"
#import <CoreLocation/CoreLocation.h>


#import "HGBMapHeader.h"


#import "HGBAnnotationView.h"
#import "HGBPointAnnotation.h"

#import "HGBMapCoordinateTool.h"

#import "HGBMapBottomSheet.h"

@interface HGBMapView ()<CLLocationManagerDelegate,MKMapViewDelegate,HGBAnnotationViewDelegate,HGBMapBottomSheetDelegate>
/**
 地址
 */
@property(strong,nonatomic) CLLocationManager *locationManager;

/**
 地理位置转化
 */
@property (nonatomic, strong) CLGeocoder *geocoder;

/**
 地图定位区域变化标记
 */
@property(assign,nonatomic)BOOL mapRegionflag;

/**
 地图比例按钮
 */
@property(strong,nonatomic)UIStepper* stepper;
/**
 功能选择按钮1
 */
@property(strong,nonatomic)UIButton *firstButton;
/**
 功能选择按钮2
 */
@property(strong,nonatomic)UIButton *secondButton;

/**
 大头针集合
 */
@property(strong,nonatomic)NSMutableArray *annotationsArr;
/**
 大头针信息集合
 */
@property(strong,nonatomic)NSMutableArray *annotationsInfoDataSource;
@property(strong,nonatomic)NSMutableArray *mapTypes;//导航地图
@end

@implementation HGBMapView
static int proportion=1000;
static int funcType=0;

#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];
    self.functype=funcType;
    [self setAuthority];
    [self createMapView];
    [self addFuncToMap];
    [self addAnnotationsToMapView:self.annotationsInfoDataSource];

}


#pragma mark 导航栏
//导航栏
-(void)createNavigationItemWithTitle:(NSString *)title
{
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1];
   
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=title;
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;

    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"HGBMapBundle.bundle/Btn_Back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(returnHandler)];

    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];


}
//返回
-(void)returnHandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//重新定位
-(void)resetCurrentLocationHandler{

    [self.locationManager stopUpdatingLocation];
}

#pragma mark 地图设置
-(void)createMapView{
    self.mapView=[[MKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    //地图类型
    self.mapView.mapType=MKMapTypeStandard;
    self.mapView.showsUserLocation=YES;
    //    self.mapView.showsScale=YES;

    //    self.mapView.showsTraffic=YES;
    self.mapView.showsBuildings=YES;
    self.mapView.userTrackingMode=MKUserTrackingModeNone;
    self.mapView.delegate=self;
    self.mapView.scrollEnabled=YES;
    self.mapView.rotateEnabled=YES;
    self.mapView.zoomEnabled=YES;
    self.mapView.pitchEnabled=NO;
    self.mapRegionflag=NO;

    CLLocationCoordinate2D coordinate= CLLocationCoordinate2DMake(31.2295612784, 121.4729663090);
    [self.locationManager stopUpdatingLocation];
    MKCoordinateSpan span;
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    //区域
    MKCoordinateRegion region ={coordinate,span};
    [self.mapView setRegion:region];
}
#pragma mark 为地图添加功能
-(void)addFuncToMap{
    //功能按钮
    UIView *funcView=[[UIView alloc]initWithFrame:CGRectMake(20*wScale, 160*hScale, 618*wScale, 72*hScale)];
    funcView.backgroundColor=[UIColor whiteColor];
    [self.mapView addSubview:funcView];

    self.firstButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.firstButton.frame=CGRectMake(309*wScale, 0, 309*wScale, 72*hScale);
    [self.firstButton setTitle:@"1" forState:(UIControlStateNormal)];
    [self.firstButton setTitleColor:[UIColor colorWithRed:191.0/256 green:191.0/256 blue:191.0/256 alpha:1] forState:(UIControlStateNormal)];
    [self.firstButton addTarget:self action:@selector(firstButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [funcView addSubview:self.firstButton];

    self.secondButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.secondButton.frame=CGRectMake(0*wScale,0, 309*wScale, 72*hScale);
    [self.secondButton setTitle:@"2" forState:(UIControlStateNormal)];
    [self.secondButton setTitleColor:[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1] forState:(UIControlStateNormal)];
    [self.secondButton addTarget:self action:@selector(secondButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [funcView addSubview:self.secondButton];

    UIImageView  *lineImageV=[[UIImageView alloc]initWithFrame:CGRectMake(309*wScale, 15*hScale, 1*wScale, 42*hScale)];
    lineImageV.image=[UIImage imageNamed:@"HGBMapBundle.bundle/line_V"];
    [funcView addSubview:lineImageV];

    //放大缩小按钮
    self.stepper=[[UIStepper alloc]initWithFrame:CGRectMake(kWidth-120,kHeight-64-80,50,20)];
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
    locationButton.frame=CGRectMake(658*wScale,160*hScale,72*wScale, 72*hScale);
    [locationButton setImage:[UIImage imageNamed:@"HGBMapBundle.bundle/icon_normal_dingwei"] forState:(UIControlStateNormal)];
    [locationButton setImage:[UIImage imageNamed:@"HGBMapBundle.bundle/icon_normal_dingwei"] forState:(UIControlStateHighlighted)];
    locationButton.backgroundColor=[UIColor whiteColor];
    [locationButton addTarget:self action:@selector(locationButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mapView addSubview:locationButton];

}
#pragma mark 功能选择
-(void)firstButtonHandle:(UIButton *)_b{
    funcType=1;
    self.functype=1;
    [self.firstButton setTitleColor:[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1] forState:(UIControlStateNormal)];
    [self.secondButton setTitleColor:[UIColor colorWithRed:191.0/256 green:191.0/256 blue:191.0/256 alpha:1] forState:(UIControlStateNormal)];
    CLLocationCoordinate2D coordinate=[HGBMapCoordinateTool transformFromWGSToGCJ:self.mapView.region.center];
    NSDictionary *dic=@{@"lng":@(coordinate.longitude).stringValue,@"lat":@(coordinate.latitude).stringValue,@"scope":@""};
    NSLog(@"1:%@",dic);


}
-(void)secondButtonHandle:(UIButton *)_b{
    funcType=0;
    self.functype=0;
    [self.secondButton setTitleColor:[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1] forState:(UIControlStateNormal)];
    [self.firstButton setTitleColor:[UIColor colorWithRed:191.0/256 green:191.0/256 blue:191.0/256 alpha:1] forState:(UIControlStateNormal)];


    CLLocationCoordinate2D coordinate=[HGBMapCoordinateTool transformFromWGSToGCJ:self.mapView.region.center];
    NSDictionary *dic=@{@"lng":@(coordinate.longitude).stringValue,@"lat":@(coordinate.latitude).stringValue,@"scope":@""};
    NSLog(@"2:%@",dic);
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
    [self.locationManager startUpdatingLocation];
}
#pragma mark 大头针
/**
 设置大头针

 @param annotations 大头针集合 lat纬度 lng经度
 */
-(void)setAnnotations:(NSArray<HGBMapAnnotationModel *> *)annotations{
    for(HGBPointAnnotation *annotation in self.annotationsArr){
        [self.mapView removeAnnotation:annotation];
    }
    self.annotationsInfoDataSource=[NSMutableArray arrayWithArray:annotations];
    [self.annotationsArr removeAllObjects];
    [self addAnnotationsToMapView:annotations];
}
/**
 添加大头针

 @param annotations 大头针集合 lat纬度 lng经度
 */
-(void)addAnnotations:(NSArray<HGBMapAnnotationModel *> *)annotations{
    for(HGBMapAnnotationModel *model in annotations){
        [self.annotationsInfoDataSource addObject:model];
    }
    [self addAnnotationsToMapView:self.annotationsInfoDataSource];
}
/**
 删除大头针

 @param annotations 大头针集合 lat纬度 lng经度
 */
-(void)removeAnnotations:(NSArray<HGBMapAnnotationModel *> *)annotations{
    for(HGBMapAnnotationModel *model in annotations){
        for(HGBMapAnnotationModel *model2 in self.annotationsInfoDataSource){
            if([model.id isEqualToString:model2.id]){
                [self.annotationsInfoDataSource removeObject:model2];
            }
        }
    }
        [self setAnnotations:self.annotationsInfoDataSource];
}
/**
 添加大头针

 @param annotations 大头针集合 lat纬度 lng经度
 */
-(void)addAnnotationsToMapView:(NSArray<HGBMapAnnotationModel *> *)annotations{
    for(int i=0;i<annotations.count;i++ ){
        HGBMapAnnotationModel *model=annotations[i];
        NSString *latString=model.lat;
        NSString *lngString=model.lng;
        CLLocationDegrees lat=latString.floatValue;
        CLLocationDegrees lng=lngString.floatValue;
        CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(lat, lng);
        HGBPointAnnotation *annotation=[[HGBPointAnnotation alloc]init];
        annotation.tag=i;
        annotation.idFlag=model.id;
        annotation.coordinate=coordinate;

        [self.annotationsArr addObject:annotation];
        [self.mapView addAnnotation:annotation];
    }

}
#pragma mark 定位权限
-(void)setAuthority{
    if(SYSTEM_VERSION>=8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

#pragma mark 定位

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location=[locations firstObject];
    CLLocationCoordinate2D coordinate=[HGBMapCoordinateTool transformFromWGSToGCJ:location.coordinate];
    self.location=location;
    self.startCoordinate=coordinate;
    [self.locationManager stopUpdatingLocation];
    MKCoordinateSpan span;
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    //区域
    MKCoordinateRegion region ={coordinate,span};
    [self.mapView setRegion:region];
}
//探测位置失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{

    [self.locationManager stopUpdatingLocation];
    NSLog(@"探测失败");
    CLLocationCoordinate2D coordinate= CLLocationCoordinate2DMake(31.2295612784, 121.4729663090);
    [self.locationManager stopUpdatingLocation];
    MKCoordinateSpan span;
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    //区域
    MKCoordinateRegion region ={coordinate,span};
    [self.mapView setRegion:region];

    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:{
            [self alertAuthorityWithPrompt:@"请到设置隐私中开启本程序定位权限"];

        }
            break;
        case kCLErrorLocationUnknown:{
            [self alertWithPrompt:@"定位失败，请刷新数据"];

        }
            break;
        default:{
            [self alertWithPrompt:@"定位失败，请刷新数据"];
        }
            break;
    }
}

#pragma mark mapdelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocation *location=userLocation.location;
    self.location=location;
    self.startCoordinate=location.coordinate;
    if(self.mapRegionflag==NO){
        self.mapRegionflag=YES;
        CLLocationCoordinate2D coordinate=[location coordinate];
        MKCoordinateSpan span;
        span.latitudeDelta=0.1;
        span.longitudeDelta=0.1;
        //区域
        MKCoordinateRegion region ={coordinate,span};
        [self.mapView setRegion:region];

    }

}
-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    [self alertWithPrompt:@"加载地图失败,请重试"];

}
//区域变动
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //    NSDictionary *dic=@{@"lng":@"121.50909",@"lat":@"31.23743",@"scope":@""};
    CLLocationCoordinate2D coordinate=[HGBMapCoordinateTool transformFromWGSToGCJ:self.mapView.region.center];
    NSDictionary *dic=@{@"lng":@(coordinate.longitude).stringValue,@"lat":@(coordinate.latitude).stringValue,@"scope":@""};
    NSLog(@"region:%@",dic);
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
}
//标记
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    if ([annotation isKindOfClass:[HGBPointAnnotation class]]) {
        HGBAnnotationView *customPinView = (HGBAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"carWashAnnotationView"];
        HGBPointAnnotation *ann=( HGBPointAnnotation *)annotation;
        if (!customPinView){
            customPinView=[[HGBAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"carWashAnnotationView"];
        }
        NSString *title=@"实例";
        customPinView.titleLab.text=title;
        customPinView.userInteractionEnabled=YES;
        customPinView.canShowCallout = NO;
        customPinView.tag=ann.tag;
        customPinView.delegate=self;

        return customPinView;
    }
    return nil;
}


-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{

    MKAnnotationView *annotationView;
    for (annotationView in views)
    {
        if (![annotationView isKindOfClass:[MKPinAnnotationView class]])
        {
            CGRect endFrame = annotationView.frame;
            annotationView.frame = CGRectMake(endFrame.origin.x, endFrame.origin.y  , endFrame.size.width, endFrame.size.height);

            [UIView beginAnimations:@"drop" context:NULL];
            [UIView setAnimationDuration:0.45];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [annotationView setFrame:endFrame];
            [UIView commitAnimations];
        }
    }
}
////取消选中
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//}
#pragma mark list
-(void)popAnnotationViewWithIndex:(NSInteger)index{
    HGBPointAnnotation *ann=self.annotationsArr[index];
    CLLocationCoordinate2D coordinate=ann.coordinate;
    MKCoordinateSpan span=self.mapView.region.span;
    span.latitudeDelta=0.01;
    span.longitudeDelta=0.01;
    //区域
    MKCoordinateRegion region ={coordinate,span};
    [self.mapView setRegion:region];
    [self selectAnntationViewWithIndex:index];
}
#pragma mark 标记按钮代理
-(void)annotationButtonActionWithIndex:(NSInteger)index{
    [self selectAnntationViewWithIndex:index];
}
#pragma  mark 导航弹出视图
-(void)selectAnntationViewWithIndex:(NSInteger)index{
    [self getMapType];
    HGBPointAnnotation *ann=self.annotationsArr[index];
    self.stopCoordinate=ann.coordinate;
    HGBMapBottomSheet *sheet=[HGBMapBottomSheet instanceWithDelegate:self InParent:self];
        sheet.titles=self.mapTypes;
    [sheet popInParentView];


}

-(void)bottomSheet:(HGBMapBottomSheet *)bottomSheet didClickButtonWithIndex:(NSInteger)index{
    NSString *title=self.mapTypes[index];
    if([title isEqualToString:@"苹果地图"]){
        //起点
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        CLLocationCoordinate2D desCorrdinate = CLLocationCoordinate2DMake(self.stopCoordinate.latitude,self.stopCoordinate.longitude);
        //终点
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCorrdinate addressDictionary:nil]];
        //默认驾车
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }else if([title isEqualToString:@"高德地图"]){
        //        self.startCoordinate=[self transformFromWGSToGCJ:self.startCoordinate];
        //        self.stopCoordinate=[self transformFromWGSToGCJ:self.self.stopCoordinate];

        NSString *urlString =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=1&style=0",@"畅通车友会",@"icbcCTTX",@"终点",self.stopCoordinate.latitude,self.stopCoordinate.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;

        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }else if([title isEqualToString:@"百度地图"]){
        self.startCoordinate=[HGBMapCoordinateTool transformFromGCJToBaidu:[HGBMapCoordinateTool transformFromWGSToGCJ:self.startCoordinate]];
        self.stopCoordinate=[HGBMapCoordinateTool transformFromGCJToBaidu:self.stopCoordinate];
        NSString *urlString =[[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",self.startCoordinate.latitude,self.startCoordinate.longitude,self.stopCoordinate.latitude,self.stopCoordinate.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;

        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];

    }else if([title isEqualToString:@"腾讯地图"]){
        self.startCoordinate=[HGBMapCoordinateTool transformFromWGSToGCJ:self.startCoordinate];
        self.stopCoordinate=self.stopCoordinate;
        NSString *urlString =[[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f, %f&tocoord=%f,%f&coord_type=1&policy=0&refer=%@",self.startCoordinate.latitude,self.startCoordinate.longitude,self.stopCoordinate.latitude,self.stopCoordinate.longitude,@"畅通车友会"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }else if([title isEqualToString:@"谷歌地图"]){
        self.startCoordinate=[HGBMapCoordinateTool transformFromWGSToGCJ:self.startCoordinate];
        self.stopCoordinate=self.stopCoordinate;

        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"畅通车友会",@"icbcCTTX",self.stopCoordinate.latitude,self.stopCoordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

- (void)bottomSheetDidClickcancelButton:(HGBMapBottomSheet *)bottomSheet {
    NSLog(@"cancel");
}

#pragma mark 获取地图导航支持的类型
-(void)getMapType{
    [self.mapTypes removeAllObjects];
    [self.mapTypes addObject:@"苹果地图"];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        [self.mapTypes addObject:@"百度地图"];
    }
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        [self.mapTypes addObject:@"高德地图"];
    }
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        [self.mapTypes addObject:@"谷歌地图"];

    }
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]){
        [self.mapTypes addObject:@"腾讯地图"];
    }
}
#pragma mark alert
-(void)alertWithPrompt:(NSString *)prompt{
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self.parent presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:prompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alertview.tag=0;
    [alertview show];
#endif
}
-(void)alertAuthorityWithPrompt:(NSString *)prompt{
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"权限提示" message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if(![HGBMediaTool openAppSetView]){
            [self alertWithPrompt:@"跳转失败,请在设置界面开启权限"];
        }

    }];
    [alert addAction:action1];
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action2];
    [self.parent presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:prompt delegate:self cancelButtonTitle:@"设置" otherButtonTitles:@"取消", nil];
    alertview.tag=1;
    [alertview show];
#endif

}
#ifdef KiOS8Later
#else
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==0){

    }else if (alertView.tag==1){
        if(buttonIndex==0){
            if(![self openAppSetView]){
                [self alertWithPrompt:@"跳转失败,请在设置界面开启权限"];
            }
        }else{

        }
    }
}
#endif

/**
 打开设置界面

 @return 结果
 */
-(BOOL)openAppSetView{

    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {

#ifdef KiOS10Later
        static BOOL sucessFlag=YES;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            sucessFlag=success;
            //发出已完成的信号
            dispatch_semaphore_signal(semaphore);
        }];


        //等待执行，不会占用资源
        dispatch_semaphore_wait(semaphore, 20);
        return sucessFlag;
#else
        return [[UIApplication sharedApplication]openURL:url];
#endif
    }else{
        return NO;
    }
}
#pragma mark get
-(NSMutableArray *)mapTypes{
    if(_mapTypes==nil){
        _mapTypes=[NSMutableArray array];
    }
    return _mapTypes;
}
-(NSMutableArray *)annotationsArr{
    if(_annotationsArr==nil){
        _annotationsArr=[NSMutableArray array];
    }
    return _annotationsArr;
}
-(NSMutableArray *)annotationsInfoDataSource{
    if(_annotationsInfoDataSource==nil){
        _annotationsInfoDataSource=[NSMutableArray array];
    }
    return _annotationsInfoDataSource;
}
-(CLLocationManager *)locationManager
{
    _locationManager=[[CLLocationManager alloc]init];
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.delegate=self;
    return _locationManager;
}
-(CLGeocoder *)geocoder{
    if(_geocoder==nil){
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

@end
