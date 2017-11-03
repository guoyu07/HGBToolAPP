//
//  HGBBaiduPointAnnotation.h
//  测试
//
//  Created by huangguangbao on 2017/10/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBaiduMapActionLabel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface HGBBaiduPointAnnotation : BMKPointAnnotation

@property (nonatomic, strong) NSString *contactInformation;

@property(assign,nonatomic)NSUInteger tag;
@property(strong,nonatomic)NSString *idFlag;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)title subtitle:(NSString*)subtitle contactInformation:(NSString *)contactInfo;
@end
