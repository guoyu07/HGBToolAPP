//
//  HGBWeexPluginConfigParser.h
//  CordovaAndWeexBase
//
//  Created by huangguangbao on 2017/7/5.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBWeexPluginConfigParser : NSObject<NSXMLParserDelegate>
{
    NSString* featureName;
}

@property (nonatomic, readonly, strong) NSMutableDictionary* pluginsDict;
@property (nonatomic, readonly, strong) NSMutableDictionary* settings;
@property (nonatomic, readonly, strong) NSMutableArray* pluginNames;

@end
