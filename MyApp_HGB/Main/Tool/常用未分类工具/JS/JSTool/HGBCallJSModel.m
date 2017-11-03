//
//  HGBCallJSModel.m
//  测试
//
//  Created by huangguangbao on 2017/7/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCallJSModel.h"

@implementation HGBCallJSModel
/**
 调用js方法
 
 @param jsFilePath js文件路径
 @param jsFunction 方法名
 @param jsArguments 参数
 @return 结果
 */
+(JSValue *)callJSInJSFilePath:(NSString *)jsFilePath WithFunction:(NSString *)jsFunction andWithArguments:(NSArray *)jsArguments{
    if(jsFilePath==nil||jsFilePath.length==0){
        return nil;
    }
    if(!jsArguments){
        jsArguments=[NSArray array];
    }
    NSString *path=[HGBCallJSModel getCompletePathFromSimplifyFilePath:jsFilePath];
    if(![HGBCallJSModel isExitAtFilePath:path]){
        return nil;
    }
    jsFilePath=path;
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
    if(jsString==nil||jsString.length==0){
        return nil;
    }
    if(!jsArguments){
        jsArguments=[NSArray array];
    }
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

#pragma mark 获取文件完整路径

/**
 将简化路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
+(NSString *)getCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    NSString *path=[simplifyFilePath copy];
    if(![HGBCallJSModel isExitAtFilePath:path]){
         path=[[HGBCallJSModel getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
        if(![HGBCallJSModel isExitAtFilePath:path]){
            path=[[HGBCallJSModel getDocumentFilePath] stringByAppendingPathComponent:simplifyFilePath];
            if(![HGBCallJSModel isExitAtFilePath:path]){
                path=[[HGBCallJSModel getMainBundlePath] stringByAppendingPathComponent:simplifyFilePath];
                if(![HGBCallJSModel isExitAtFilePath:path]){
                    path=simplifyFilePath;

                }
                
            }
            
        }
        
    }
    return path;
}
#pragma mark bundle
/**
 获取主资源文件路径

 @return 主资源文件路径
 */
+(NSString *)getMainBundlePath{
    return [[NSBundle mainBundle]resourcePath];
}
#pragma mark 获取沙盒文件路径
/**
 获取沙盒根路径

 @return 根路径
 */
+(NSString *)getHomeFilePath{
    NSString *path_huang=NSHomeDirectory();
    return path_huang;
}
/**
 获取沙盒Document路径

 @return Document路径
 */
+(NSString *)getDocumentFilePath{
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    return path_huang;
}
#pragma mark 文件
/**
 文档是否存在

 @param filePath 归档的路径
 @return 结果
 */
+(BOOL)isExitAtFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:filePath];
    return isExit;
}
@end
