//
//  HGBCallPhoneWeexPlugin.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCallPhoneWeexPlugin.h"
@interface HGBCallPhoneWeexPlugin()

/*
 

 成功返回
 */
@property (nonatomic,copy)WXModuleCallback sucessCallback;
/*
 失败返回
 */
@property (nonatomic,copy)WXModuleCallback failCallback;

@end
@implementation HGBCallPhoneWeexPlugin

WX_EXPORT_METHOD(@selector(getCallPhone:::))

/**
 打电话

 @param arguments html传参数
 @param sucessCallback 成功回调
 @param failCallback 失败回调
 */
- (void)getCallPhone:(NSDictionary *)arguments :(WXModuleCallback)sucessCallback :(WXModuleCallback)failCallback{
    NSString *phoneNumber;

    phoneNumber = arguments[@"phone"];
    if(phoneNumber!=nil&&phoneNumber.length!=0){
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]];
        [[UIApplication sharedApplication] openURL:url];
        sucessCallback(@"sucess");
    }else{
        failCallback(@"error");
    }
}

@end
