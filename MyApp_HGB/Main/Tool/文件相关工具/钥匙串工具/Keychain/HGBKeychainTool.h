//
//  HGBKeychainTool.h
//  测试
//
//  Created by huangguangbao on 2017/9/15.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 钥匙串保存
 */
@interface HGBKeychainTool : NSObject

/**
 *  keychain存
 *
 *  @param key   要存的对象的key值
 *  @param string 要保存的value值
 *  @return 保存结果
 */
+ (BOOL)saveKeyChainForKeyWithKey:(NSString *)key value:(NSString *)string;
/**
 *  keychain取
 *
 *  @param key 对象的key值
 *
 *  @return 获取的对象
 */

+ (NSString *)getKeychainStringWithKey:(NSString *)key;
/**
 *  keychain删除
 *
 *  @param key   要存的对象的key值
 *  @return 保存结果
 */
+ (BOOL)deleteKeyChainForKeyWithKey:(NSString *)key;
@end
