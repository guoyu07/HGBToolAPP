//
//  HGBAPPInfoTool.m
//  设备相关信息
//
//  Created by huangguangbao on 2017/6/7.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBAPPInfoTool.h"

@implementation HGBAPPInfoTool

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



/**
 获取app的名字

 @return app的名字
 */
+(NSString*) getAppName

{
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    return appName;
    
}
/**
 获取app图标
 
 @return app图标
 */
+(UIImage *)getAppImage{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    
    UIImage* image = [UIImage imageNamed:icon];
    return image;
}
/**
 获取app启动页图片
 
 @return 启动页图片
 */
+(UIImage *)getLanuchImage
{
    UIImage    *lauchImage  = nil;
    NSString    *viewOrientation = nil;
    CGSize     viewSize  = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation orientation  = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
        viewOrientation = @"Landscape";
        
    } else {
        
        viewOrientation = @"Portrait";
    }
    
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary) {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    
    return lauchImage;
}
/**
 获取app的infoPlist内容
 
 @return 内容
 */
+(NSDictionary *)getInfoPlist{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    return info;
    
}
@end
