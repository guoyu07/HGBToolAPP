//
//  HGBCommonCameraStyle.m
//  CTTX
//
//  Created by huangguangbao on 2017/3/21.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCommonCameraStyle.h"

@implementation HGBCommonCameraStyle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isEdit=YES;
        self.cropSize=CGSizeMake(200, 200);
        self.cropRectColor=[UIColor whiteColor];
    }
    return self;
}
@end
