//
//  HGBXMLModel.m
//  测试
//
//  Created by huangguangbao on 2017/9/5.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBXMLModel.h"

@implementation HGBXMLModel
/**
 *  重写init方法，主要是初始化subNodes
 */
- (instancetype)init {
    if(self = [super init]) {
        self.subNodes = [NSMutableArray array];
    }
    return self;
}
@end
