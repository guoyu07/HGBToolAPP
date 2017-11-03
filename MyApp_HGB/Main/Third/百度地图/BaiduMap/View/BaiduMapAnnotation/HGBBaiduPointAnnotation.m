//
//  HGBBaiduPointAnnotation.m
//  测试
//
//  Created by huangguangbao on 2017/10/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBaiduPointAnnotation.h"

@implementation HGBBaiduPointAnnotation
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)title subtitle:(NSString *)subtitle contactInformation:(NSString *)contactInfo {
    self = [super init];
    if (self) {
        self.coordinate = coord;
        self.title = title;
        self.subtitle = subtitle;
        self.contactInformation = contactInfo;
    }
    return self;
}
@end
