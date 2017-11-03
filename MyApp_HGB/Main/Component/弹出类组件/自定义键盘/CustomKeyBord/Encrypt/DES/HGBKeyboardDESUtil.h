//
//  HGBKeyboardDESUtil.h
//  HelloCordova
//
//  Created by huangguangbao on 2017/8/9.
//
//

#import <Foundation/Foundation.h>


/**
 DES加密
 */
@interface HGBKeyboardDESUtil : NSObject{

}

/**
 加密方法

 @param plainText 原始字符串
 @param key key
 @return 加密字符串
 */
+ (NSString*)encrypt:(NSString*)plainText WithKey:(NSString *)key;


/**
 解密方法

 @param encryptText  加密字符串
 @param key key
 @return 解密字符串
 */
+ (NSString*)decrypt:(NSString*)encryptText WithKey:(NSString *)key;


@end
