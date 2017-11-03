
//
//  HGBCalenderStringTool.m
//  测试
//
//  Created by huangguangbao on 2017/10/23.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCalenderStringTool.h"

@implementation HGBCalenderStringTool
/**
 删除字符串空格

 @param string 字符串
 @return 处理后字符串
 */
+(NSString *)deleteSpaceWithString:(NSString *)string
{
    NSString *str=string;
    while ([str containsString:@" "]){
        str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return str;
}
@end
