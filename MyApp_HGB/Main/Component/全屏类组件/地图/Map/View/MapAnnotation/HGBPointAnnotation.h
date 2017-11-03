//
//  HGBPointAnnotation.h
//  CTTX
//
//  Created by huangguangbao on 16/9/21.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface HGBPointAnnotation : MKPointAnnotation

@property (nonatomic, strong) NSString *contactInformation;

@property(assign,nonatomic)NSUInteger tag;
@property(strong,nonatomic)NSString *idFlag;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)title subtitle:(NSString*)subtitle contactInformation:(NSString *)contactInfo;
@end
