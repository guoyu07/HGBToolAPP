//
//  HGBJSModel.m
//  测试app
//
//  Created by huangguangbao on 2017/7/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBJSModel.h"

@implementation HGBJSModel
/**
 调用js方法
 
 @param jsFilePath js文件路径
 @param jsFunction 方法名
 @param jsArguments 参数
 @return 结果
 */
+(JSValue *)callJSInJSFilePath:(NSString *)jsFilePath WithFunction:(NSString *)jsFunction andWithArguments:(NSArray *)jsArguments{
    JSContext *context = [[JSContext alloc] init];
    NSString *jsScript = [NSString stringWithContentsOfFile:jsFilePath encoding:NSUTF8StringEncoding error:nil];
    
    if(jsScript&&jsScript.length!=0){
        [context evaluateScript:jsScript];
        JSValue *function = [context objectForKeyedSubscript:jsFunction];
        JSValue *result = [function callWithArguments:jsArguments];
        return result;
    }else{
        return nil;
    }
}
/**
 调用js方法
 
 @param jsString js
 @param jsFunction 方法名
 @param jsArguments 参数
 @return 结果
 */
+(JSValue *)callJSWithJSString:(NSString *)jsString WithFunction:(NSString *)jsFunction andWithArguments:(NSArray *)jsArguments{
    JSContext *context = [[JSContext alloc] init];
    NSString *jsScript = jsString;
    
    if(jsScript&&jsScript.length!=0){
        [context evaluateScript:jsScript];
        JSValue *function = [context objectForKeyedSubscript:jsFunction];
        JSValue *result = [function callWithArguments:jsArguments];
        return result;
    }else{
        return nil;
    }
}
@end
