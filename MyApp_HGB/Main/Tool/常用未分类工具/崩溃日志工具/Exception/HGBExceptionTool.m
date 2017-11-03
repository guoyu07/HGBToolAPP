//
//  HGBExceptionTool.m
//  测试
//
//  Created by huangguangbao on 2017/8/11.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBExceptionTool.h"
#import <sys/utsname.h>
#pragma mark UUID
#import <Security/Security.h>

@implementation HGBExceptionTool
#pragma mark 崩落捕获
/**
 崩溃日志捕捉

 @param exception 崩溃
 */
void uncaughtExceptionHandler(NSException *exception)
{
    NSDictionary *exceptionInfo = [HGBExceptionTool getExceptionInfo:exception];
    [HGBExceptionTool saveExceptions:@[exceptionInfo]];
}


/**
 设置崩溃监控-app登录时
 */
+(void)setExceptionMonitor{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}



/**
 错误捕捉

 @param hanldeBloack 函数
 @param errorBloack 错误
 */
+(void)catchExceptionWithHandle:(HGBExceptionHandleBlock)hanldeBloack andWithError:(HGBExceptionErrorBlock)errorBloack{
    @try {
        hanldeBloack();
    } @catch (NSException *exception) {
        errorBloack(exception);
    } @finally {
    }
}

/**
 错误捕捉

 @param hanldeBloack 函数
 @param errorBloack 错误
 @param finalBloack 下一步执行
 */
+(void)catchExceptionWithHandle:(HGBExceptionHandleBlock)hanldeBloack andWithError:(HGBExceptionErrorBlock)errorBloack andWithFinal:(HGBExceptionFinalBlock)finalBloack{
    @try {
        hanldeBloack();
    } @catch (NSException *exception) {
        errorBloack(exception);
    } @finally {
        finalBloack();
    }
}

#pragma mark 错误文件处理
/**
 获取未标记错误列表-一般用于未上传服务器

 @return 已归档错误列表
 */
+(NSArray *)getUnMarkExceptionLogs{

    NSArray *allExceptionLogs=[HGBExceptionTool getAllExceptionLogs];
    if(allExceptionLogs==nil){
        allExceptionLogs=[NSArray array];
    }
    NSMutableArray *unMarkExceptionLogs=[NSMutableArray array];
    for(NSDictionary *exception in allExceptionLogs){
        NSString *mark=[exception objectForKey:@"mark"];
        if(!(mark&&mark.integerValue==1)){
            [unMarkExceptionLogs addObject:exception];
        }
    }
    return unMarkExceptionLogs;
}
/**
 标记错误日志

 @param exceptionLogs 错误日志列表
 @return 成功失败
 */
+(BOOL)markExceptionLogs:(NSArray *)exceptionLogs{

    NSMutableArray *allExceptionLogs=[NSMutableArray arrayWithArray:[HGBExceptionTool getAllExceptionLogs]];
    if(allExceptionLogs==nil){
        allExceptionLogs=[NSMutableArray array];
    }
    for(NSMutableDictionary *exception in exceptionLogs){
        NSString *exception_id=[exception objectForKey:@"id"];
        for(NSMutableDictionary *exception_all in allExceptionLogs){
            NSString *exception_all_id=[exception_all objectForKey:@"id"];
            if(exception_all_id&&exception_id&&[exception_all_id isEqualToString:exception_id]){
                [exception_all setObject:@"1" forKey:@"mark"];
            }
        }
    }
   return [allExceptionLogs writeToFile:[HGBExceptionTool getExceptionLogPath] atomically:YES];


}
/**
 获取已归档错误列表

 @return 已归档错误列表
 */
+(NSArray *)getAllExceptionLogs{
    NSString * exceptionErrorFile =[HGBExceptionTool getExceptionLogPath];

    NSArray *allExceptionLogs=[NSArray arrayWithContentsOfFile:exceptionErrorFile];
    if(allExceptionLogs==nil){
        allExceptionLogs=[NSArray array];
    }
    return allExceptionLogs;
}
/**
 主动保存崩溃

 @param exception 崩溃
 */
+ (void)saveException:(NSException *)exception {

    NSDictionary *exceptionInfo = [HGBExceptionTool getExceptionInfo:exception];

    [self saveExceptions:@[exceptionInfo]];
}
/**
  保存错误日志

 @param exceptions 错误日志
 @return 结果
 */
+(BOOL)saveExceptions:(NSArray *)exceptions{
     NSMutableArray *allExceptionLogs=[NSMutableArray arrayWithArray:[HGBExceptionTool getAllExceptionLogs]];
    for(id exceptionInfo in exceptions){
        if([exceptionInfo isKindOfClass:[NSDictionary class]]){
            [allExceptionLogs addObject:exceptionInfo];
        }else if ([exceptionInfo isKindOfClass:[NSException class]]){
            [allExceptionLogs addObject:[HGBExceptionTool getExceptionInfo:exceptionInfo]];
        }

    }
   BOOL flag1=[allExceptionLogs writeToFile:[HGBExceptionTool getExceptionLogPath] atomically:YES];
    BOOL flag2=[allExceptionLogs writeToFile:[self getExceptionPlistPath] atomically:YES];
    return flag1&&flag2;


}

/**
 获取崩溃信息

 @param exception 崩溃
 @return 崩溃信息
 */
+ (NSDictionary *)getExceptionInfo:(NSException *)exception {
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];

    // 异常出处
    NSString * mainCallStackSymbolMsg = [HGBExceptionTool getMainCallStackSymbolMessageWithCallStackSymbols:stackArray];

    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:stackArray];
    [tmpArr insertObject:reason atIndex:0];
    NSString * errorPlace = [NSString stringWithFormat:@"Error Place%@",mainCallStackSymbolMsg];
    NSLog(@"初始化完毕%@",errorPlace);


    NSMutableDictionary *exceptionInfo = [NSMutableDictionary dictionary];
    if(reason){
        [exceptionInfo setObject:reason forKey:@"reason"];
    }
    if(name){
        [exceptionInfo setObject:reason forKey:@"name"];
    }
    if(errorPlace){
        [exceptionInfo setObject:errorPlace forKey:@"errorPlace"];
    }
    if(tmpArr){
        [exceptionInfo setObject:tmpArr forKey:@"stack"];
    }
    [exceptionInfo setObject:[HGBExceptionTool getTimeString] forKey:@"time"];
    [exceptionInfo setObject:[HGBExceptionTool getSecondTimeStringSince1970] forKey:@"id"];
    [exceptionInfo setObject:@"0" forKey:@"mark"];
    [exceptionInfo setObject:[HGBExceptionTool getBundleID] forKey:@"bundleId"];
    [exceptionInfo setObject:[HGBExceptionTool getDefaultsUdidCode] forKey:@"uuid"];
    [exceptionInfo setObject:[HGBExceptionTool getDeviceModelName] forKey:@"device"];
     [exceptionInfo setObject:[HGBExceptionTool getLocalAppVersion] forKey:@"appVersion"];
    [exceptionInfo setObject:[HGBExceptionTool getLocalAppBuildVersion] forKey:@"appBuildVersion"];
    return exceptionInfo;
}
/**
 获取崩溃日志log版路径

 @return 崩溃日志路径
 */
+(NSString *)getExceptionLogPath{
    NSString * exceptionErrorFile =[NSString stringWithFormat:@"%@/errorLogs_%@/error_exception.log",[HGBExceptionTool getDocumentDirectory],[HGBExceptionTool getBundleID]];
    NSString * exceptionErrorDirectory =[exceptionErrorFile stringByDeletingLastPathComponent];
    [HGBExceptionTool createDirectoryPath:exceptionErrorDirectory];
    return exceptionErrorFile;
}
/**
 获取崩溃日志plist版路径

 @return 崩溃日志路径
 */
+(NSString *)getExceptionPlistPath{
    NSString * exceptionErrorFile =[NSString stringWithFormat:@"%@/errorLogs_%@/error_exception.plist",[HGBExceptionTool getDocumentDirectory],[HGBExceptionTool getBundleID]];
    NSString * exceptionErrorDirectory =[exceptionErrorFile stringByDeletingLastPathComponent];
    [HGBExceptionTool createDirectoryPath:exceptionErrorDirectory];
    return exceptionErrorFile;
}
#pragma mark 崩溃信息提取
/**
 提取崩溃地址

 @param callStackSymbols 崩溃堆栈
 @return 崩溃地址
 */
+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols {
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;

    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";

    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];

        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];

                //get className
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;

                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];

                //filter category and system class
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                }
                *stop = YES;
            }
        }];

        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    return mainCallStackSymbolMsg;
}


#pragma mark 时间工具
/**
 获取格式化时间字符串

 @return 格式化时间字符串
 */
+ (NSString *)getTimeString
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:nowDate];
    return dateString;
}
/**
 获取日期字符串

 @return 日期字符串
 */
+ (NSString *)getFormatDateString
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [formatter stringFromDate:nowDate];
    return dateString;
}
/**
 获取时间戳-秒级

 @return 秒级时间戳
 */
+ (NSString *)getSecondTimeStringSince1970
{
    NSDate* date = [NSDate date];
    NSTimeInterval interval=[date timeIntervalSince1970];  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%f", interval]; //转为字符型
    NSString *timeStr = [NSString stringWithFormat:@"%lf",[timeString doubleValue]*1000000];

    if(timeStr.length>=16){
        return [timeStr substringToIndex:16];
    }else{
        return timeStr;
    }
}
#pragma mark 文件工具
// 沙盒地址
+(NSString *)getDocumentDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

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

/**
 创建文件夹

 @param directoryPath 路径
 @return 结果
 */
+(BOOL)createDirectoryPath:(NSString *)directoryPath{
    if([HGBExceptionTool isExitAtFilePath:directoryPath]){
        return YES;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];
    BOOL flag=[filemanage createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];
    if(flag){
        return YES;
    }else{
        return NO;
    }
}
#pragma mark app信息工具
/**
 获取app版本号

 @return app版本号
 */
+(NSString*) getLocalAppVersion

{

    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

}
/**
 获取build版本号

 @return app版本号
 */
+(NSString*) getLocalAppBuildVersion

{

    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

}
/**
 获取BundleID

 @return BundleID
 */
+(NSString*) getBundleID

{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];

}
#pragma mark 设备信息
/**
 获取设备型号

 @return 设备型号
 */
+ (NSString *)getDeviceModelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"VerizoniPhone4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone6Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone6sPlus";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone7(CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone7(GSM)";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone7Plus(CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone7Plus(GSM)";

    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPodTouch1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPodTouch2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPodTouch3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPodTouch4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPodTouch5G";

    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad2(WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad2(GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad2(CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad2(32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPadMini(WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPadMini(GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPadMini(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad4 WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad4(4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad4(CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPadAir";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPadAir";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPadAir";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPadAir2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPadAir2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPadMini2";
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPadMini3";
    return deviceModel;
}
#pragma mark 获取UUID
/**
 *  获取UUID
 *
 *  @return 获取的UUID的值
 */
+ (NSString *)getDefaultsUdidCode
{

    if((![HGBExceptionTool getDefaultsWithKey:@"UUID"])){
        NSString*uuid = [HGBExceptionTool getUUID];
        [HGBExceptionTool saveDefaultsValue:uuid WithKey:@"UUID"];
        return uuid;
    }else{
        return [HGBExceptionTool getDefaultsWithKey:@"UUID"];
    }
}
+(NSString *)getUUID
{
    //    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"MyKeychainItem" accessGroup:nil];
    //    NSString *udidcode = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //    return udidcode;



    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;


}
#pragma mark defaults保存

/**
 *  Defaults保存
 *
 *  @param value   要保存的数据
 *  @param key   关键字
 *  @return 保存结果
 */
+(BOOL)saveDefaultsValue:(id)value WithKey:(NSString *)key{
    if((!value)||(!key)||key.length==0){
        return NO;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
    return YES;
}
/**
 *  Defaults取出
 *
 *  @param key     关键字
 *  return  返回已保存的数据
 */
+(id)getDefaultsWithKey:(NSString *)key{
    if(key==nil||key.length==0){
        return nil;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id  value=[defaults valueForKey:key];
    [defaults synchronize];
    return value;
}
/**
 *  Defaults删除 *
 *  @param key     关键字
 *  return  返回已保存的数据
 */
+(BOOL)deleteDefaultsWithKey:(NSString *)key{
    if(key==nil||key.length==0){
        return NO;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
    return YES;
}
@end
