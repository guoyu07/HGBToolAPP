//
//  HGBPointAnnotation.m
//  CTTX
//
//  Created by huangguangbao on 16/9/21.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import "HGBPointAnnotation.h"

@implementation HGBPointAnnotation
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
