//
//  HGBTouchIDTool.m
//  指纹锁
//
//  Created by huangguangbao on 2017/6/23.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBTouchIDTool.h"
#import <sys/utsname.h>



#ifndef SYSTEM_VERSION
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
#endif

#ifndef KiOS6Later
#define KiOS6Later (SYSTEM_VERSION >= 6)
#endif

#ifndef KiOS7Later
#define KiOS7Later (SYSTEM_VERSION >= 7)
#endif

#ifndef KiOS8Later
#define KiOS8Later (SYSTEM_VERSION >= 8)
#endif

#ifndef KiOS9Later
#define KiOS9Later (SYSTEM_VERSION >= 9)
#endif

#ifndef KiOS10Later
#define KiOS10Later (SYSTEM_VERSION >= 10)
#endif

#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"
#define ReslutError @"ReslutError"

@interface HGBTouchIDTool ()
@end

@implementation HGBTouchIDTool


/**
 指纹解锁

 @param message 提示文本
 @param cancelTitle 取消按钮显示内容(此参数只有iOS10以上才能生效),默认显示：取消
 @param otherTitle 密码登录按钮显示内容(默认*密码登录*),如果传入空字符串@""/nil,则只会显示独立的取消按钮
 @param enabled 默认为NO点击密码使用系统解锁/YES时，自己操作点击密码登录
 @param resultBlock 返回结果
 */
+ (void)touchIDWithMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)otherTitle enabled:(BOOL)enabled andWithOperatingrResultBlock:(void(^)( HGBOperatingTouchIDResult result,NSDictionary *messageInfo))resultBlock{
    
    [HGBTouchIDTool validationTouchIDIsSupportWithBlock:^(BOOL isSupport, LAContext *context, NSInteger policy, NSDictionary *messageInfo) {
        context.localizedFallbackTitle = !otherTitle?@"":otherTitle;
        if(SYSTEM_VERSION>=10) context.localizedCancelTitle = cancelTitle;
        NSInteger policy2 = enabled?LAPolicyDeviceOwnerAuthenticationWithBiometrics:LAPolicyDeviceOwnerAuthentication;
        if (isSupport) {
            [context evaluatePolicy:policy2 localizedReason:message reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        resultBlock(HGBTouchIDResultTypeSucess,@{ReslutCode:@(HGBTouchIDResultTypeSucess),ReslutMessage:@"验证成功"});
                    });
                    return;
                }else if (error) {
                    switch (error.code) {
                        case LAErrorAuthenticationFailed:
                            resultBlock(HGBTouchIDResultTypeFailed,@{ReslutCode:@(HGBTouchIDResultTypeFailed),ReslutMessage:@"TouchID 验证失败",ReslutError:error});
                            break;
                        case LAErrorUserCancel:
                            resultBlock(HGBTouchIDResultTypeUserCancel,@{ReslutCode:@(HGBTouchIDResultTypeUserCancel),ReslutMessage:@"TouchID 被用户取消",ReslutError:error});
                            break;
                        case LAErrorSystemCancel:
                            resultBlock(HGBTouchIDResultTypeSystemCancel,@{ReslutCode:@(HGBTouchIDResultTypeSystemCancel),ReslutMessage:@"TouchID 被系统取消",ReslutError:error});
                            break;
                        case LAErrorAppCancel:
                            resultBlock(HGBTouchIDResultTypeAppCancel,@{ReslutCode:@(HGBTouchIDResultTypeAppCancel),ReslutMessage:@"当前软件被挂起并取消了授权(如App进入了后台等)",ReslutError:error});
                            if (enabled)[context evaluatePolicy:policy localizedReason:message reply:^(BOOL success, NSError * _Nullable error) {}];
                            break;
                        case LAErrorInvalidContext:
                            resultBlock(HGBTouchIDResultTypeAppCancel,@{ReslutCode:@(HGBTouchIDResultTypeAppCancel),ReslutMessage:@"当前软件被挂起并取消了授权(LAContext对象无效)",ReslutError:error});
                            if (enabled)[context evaluatePolicy:policy localizedReason:message reply:^(BOOL success, NSError * _Nullable error) {
                            }];
                            break;
                        case LAErrorUserFallback:
                            resultBlock(HGBTouchIDResultTypeInputPassword,@{ReslutCode:@(HGBTouchIDResultTypeInputPassword),ReslutMessage:@"手动输入密码",ReslutError:error});
                            break;
                        case LAErrorPasscodeNotSet:
                            resultBlock(HGBTouchIDResultTypePasswordNotSet,@{ReslutCode:@(HGBTouchIDResultTypePasswordNotSet),ReslutMessage:@"TouchID 无法启动,因为用户没有设置密码",ReslutError:error});
                            break;
                        case LAErrorTouchIDNotEnrolled:

                            resultBlock(HGBTouchIDResultTypeNotSet,@{ReslutCode:@(HGBTouchIDResultTypeNotSet),ReslutMessage:@"TouchID 无法启动,因为用户没有设置TouchID",ReslutError:error});
                            break;
                        case LAErrorTouchIDNotAvailable:
                            resultBlock(HGBTouchIDResultTypeNotAvailable,@{ReslutCode:@(HGBTouchIDResultTypeNotAvailable),ReslutMessage:@"TouchID 无效",ReslutError:error});
                            break;
                        case LAErrorTouchIDLockout:resultBlock(HGBTouchIDResultTypeLockout,@{ReslutCode:@(HGBTouchIDResultTypeLockout),ReslutMessage:@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码",ReslutError:error});
                            if (enabled)[context evaluatePolicy:policy localizedReason:message reply:^(BOOL success, NSError * _Nullable error) {}];
                            break;
                        default:
                            resultBlock(HGBTouchIDResultTyoeUnknown,@{ReslutCode:@(HGBTouchIDResultTyoeUnknown),ReslutMessage:@"未知情况",ReslutError:error});
                            if (enabled)[context evaluatePolicy:policy localizedReason:message reply:^(BOOL success, NSError * _Nullable error) {}];
                            break;
                    }
                }
            }];
        }else {
            NSError *error=messageInfo[ReslutError];
            
            if(error.code==-8||[error.localizedDescription isEqualToString:@"Biometry is locked out"]){
                resultBlock(HGBTouchIDResultTypeLockout,@{ReslutCode:@(HGBTouchIDResultTypeLockout),ReslutMessage:@"该设备TouchID已被系统锁定,请到设置界面TouchID与密码解锁",ReslutError:error});
        }else{
             resultBlock(HGBTouchIDResultTypeVersionNotSupport,@{ReslutCode:@(HGBTouchIDResultTypeVersionNotSupport),ReslutMessage:[NSString stringWithFormat:@"此设备不支持TouchID:\n设备操作系统:%@\n设备系统版本号:%@\n设备型号:%@", [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] systemName], [HGBTouchIDTool getDeviceModelName]],ReslutError:error});
        }
        }
        
   }];
    
}

/**
 验证设备是否支持指纹解锁

 @param block block
 @return 返回结果
 */
+ (BOOL)validationTouchIDIsSupportWithBlock:(void(^)(BOOL isSupport,LAContext *context, NSInteger policy, NSDictionary *messageInfo))block{
    LAContext* context = [[LAContext alloc] init];
#ifdef KiOS9Later
#else
    context.maxBiometryFailures = @(3);//最大的错误次数,9.0后失效
#endif
    NSInteger policy = SYSTEM_VERSION<9.0&&SYSTEM_VERSION>=8.0?LAPolicyDeviceOwnerAuthenticationWithBiometrics:LAPolicyDeviceOwnerAuthentication;
    NSError *error = nil;
    BOOL isSupport = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];//实测中发现如果使用LAPolicyDeviceOwnerAuthentication,则每次返回的结果都是true,使用LAPolicyDeviceOwnerAuthenticationWithBiometrics则可以返回真实的结果
    NSString *promptstr;
     if(error.code==-8||[error.localizedDescription isEqualToString:@"Biometry is locked out"]){
         promptstr=@"该设备TouchID已被系统锁定,请到设置界面TouchID与密码解锁";
     }else{
          promptstr=@"此设备不支持TouchID";
     }
    if(promptstr&&error){
        block(isSupport, context, policy,@{ReslutMessage:promptstr,ReslutError:error});
    }else if(promptstr){
        block(isSupport, context, policy,@{ReslutMessage:promptstr});
    }else if(error){
        block(isSupport, context, policy,@{ReslutError:error});
    }else{
        block(isSupport, context, policy,@{});
    }
    return isSupport;
}

#pragma mark ---获取设备型号
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
@end
