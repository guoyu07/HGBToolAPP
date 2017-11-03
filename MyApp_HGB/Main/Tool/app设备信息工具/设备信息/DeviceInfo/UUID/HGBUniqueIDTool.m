//
//  HGBUniqueIDTool.m
//  获取唯一标识
//
//  Created by huangguangbao on 2017/6/7.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBUniqueIDTool.h"
#import <UIKit/UIKit.h>
#pragma mark adid
#import <AdSupport/AdSupport.h>
#pragma mark macadress
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#pragma mark UUID
#import <Security/Security.h>

static NSString *SFHFKeychainUtilsErrorDomain = @"SFHFKeychainUtilsErrorDomain";
static NSString * const BFUniqueIdentifierDefaultsKey = @"BFUniqueIdentifier";

@implementation HGBUniqueIDTool
#pragma mark 获取手机唯一标识
/**
 *  获取手机序列号
 *
 *  @return 获取的手机序列号
 */
+ (NSString *)getUniqueIdentifier{
    NSString *identifierNumber;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        identifierNumber = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        identifierNumber=[HGBUniqueIDTool getKeychainUUIDCode];
    }
    return identifierNumber;
}
#pragma mark 获取UUID
/**
 *  获取UUID-Keychain版
 *
 *  @return 获取的UUID的值
 */
+(NSString *)getKeychainUUIDCode
{

    NSString  *UUID;
    if(![HGBUniqueIDTool getKeychainStringWithKey:BFUniqueIdentifierDefaultsKey]){
        UUID = [HGBUniqueIDTool generateUUID];
        [HGBUniqueIDTool saveKeyChainForKeyWithKey:BFUniqueIdentifierDefaultsKey value:UUID];

    }else{
        UUID=[HGBUniqueIDTool getKeychainStringWithKey:BFUniqueIdentifierDefaultsKey];
    }
    return UUID;
}
#pragma mark 获取UUID
/**
 *  获取UUID-Defaults版
 *
 *  @return 获取的UUID的值
 */
+(NSString *)getDefaultsUUIDCode
{

    NSString  *UUID;
    if(![HGBUniqueIDTool getDefaultsWithKey:BFUniqueIdentifierDefaultsKey]){
        UUID = [HGBUniqueIDTool generateUUID];
        [HGBUniqueIDTool saveDefaultsValue:UUID WithKey:BFUniqueIdentifierDefaultsKey];

    }else{
        UUID=[HGBUniqueIDTool getDefaultsWithKey:BFUniqueIdentifierDefaultsKey];
    }
    return UUID;
}

+(NSString *)generateUUID
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
+(NSString *)generateUUID2{
    if(NSClassFromString(@"NSUUID")) { // only available in iOS >= 6.0
        return [[NSUUID UUID] UUIDString];
    }
    CFUUIDRef uuidRef =
    CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfuuid =
    CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [((__bridge NSString *)
                       cfuuid) copy];
    CFRelease(cfuuid);
    return uuid;
}

#pragma mark 获取广告标识
/**
 获取广告标识
 
 @return AdvertisingIdentifier
 */
+(NSString *)getAdvertisingIdentifier{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
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
#pragma mark keychain
//keychain存取
/**
 *  keychain取
 *
 *  @param key 对象的key值
 *
 *  @return 获取的对象
 */
+ (NSString *)getKeychainStringWithKey:(NSString *)key
{

    return [HGBUniqueIDTool getPasswordForUsername:key andServiceName:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] error:nil];
}
/**
 *  keychain存
 *
 *  @param key   要存的对象的key值
 *  @param value 要保存的value值
 */
+(void)saveKeyChainForKeyWithKey:(NSString *)key value:(NSString *)value
{

    [HGBUniqueIDTool storeUsername:key andPassword:value forServiceName:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] updateExisting:1 error:nil];
}
#pragma mark 存储于钥匙串

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000 && TARGET_IPHONE_SIMULATOR

+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
    if (!username || !serviceName) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        return nil;
    }

    SecKeychainItemRef item = [SFHFKeychainUtils getKeychainItemReferenceForUsername: username andServiceName: serviceName error: error];

    if (*error || !item) {
        return nil;
    }

    // from Advanced Mac OS X Programming, ch. 16
    UInt32 length;
    char *password;
    SecKeychainAttribute attributes[8];
    SecKeychainAttributeList list;

    attributes[0].tag = kSecAccountItemAttr;
    attributes[1].tag = kSecDescriptionItemAttr;
    attributes[2].tag = kSecLabelItemAttr;
    attributes[3].tag = kSecModDateItemAttr;

    list.count = 4;
    list.attr = attributes;

    OSStatus status = SecKeychainItemCopyContent(item, NULL, &list, &length, (void **)&password);

    if (status != noErr) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
        return nil;
    }

    NSString *passwordString = nil;

    if (password != NULL) {
        char passwordBuffer[1024];

        if (length > 1023) {
            length = 1023;
        }
        strncpy(passwordBuffer, password, length);

        passwordBuffer[length] = '\0';
        passwordString = [NSString stringWithCString:passwordBuffer];
    }

    SecKeychainItemFreeContent(&list, password);

    CFRelease(item);

    return passwordString;
}

+ (void) storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error {
    if (!username || !password || !serviceName) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        return;
    }

    OSStatus status = noErr;

    SecKeychainItemRef item = [SFHFKeychainUtils getKeychainItemReferenceForUsername: username andServiceName: serviceName error: error];

    if (*error && [*error code] != noErr) {
        return;
    }

    *error = nil;

    if (item) {
        status = SecKeychainItemModifyAttributesAndData(item,
                                                        NULL,
                                                        strlen([password UTF8String]),
                                                        [password UTF8String]);

        CFRelease(item);
    }
    else {
        status = SecKeychainAddGenericPassword(NULL,
                                               strlen([serviceName UTF8String]),
                                               [serviceName UTF8String],
                                               strlen([username UTF8String]),
                                               [username UTF8String],
                                               strlen([password UTF8String]),
                                               [password UTF8String],
                                               NULL);
    }

    if (status != noErr) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
    }
}

+ (void) deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
    if (!username || !serviceName) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: 2000 userInfo: nil];
        return;
    }

    *error = nil;

    SecKeychainItemRef item = [SFHFKeychainUtils getKeychainItemReferenceForUsername: username andServiceName: serviceName error: error];

    if (*error && [*error code] != noErr) {
        return;
    }

    OSStatus status;

    if (item) {
        status = SecKeychainItemDelete(item);

        CFRelease(item);
    }

    if (status != noErr) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
    }
}

+ (void) purgeItemsForServiceName:(NSString *) serviceName error: (NSError **) error {
    if (!serviceName) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: 2000 userInfo: nil];
        return;
    }

    NSMutableDictionary *searchData = [NSMutableDictionary new];
    [searchData setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [searchData setObject:serviceName forKey:(__bridge id)kSecAttrService];

    OSStatus status = SecItemDelete((__bridge_retained CFDictionaryRef)searchData);

    if (error != nil && status != noErr)
    {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
    }
}

+ (SecKeychainItemRef) getKeychainItemReferenceForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
    if (!username || !serviceName) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        return nil;
    }

    *error = nil;

    SecKeychainItemRef item;

    OSStatus status = SecKeychainFindGenericPassword(NULL,
                                                     strlen([serviceName UTF8String]),
                                                     [serviceName UTF8String],
                                                     strlen([username UTF8String]),
                                                     [username UTF8String],
                                                     NULL,
                                                     NULL,
                                                     &item);

    if (status != noErr) {
        if (status != errSecItemNotFound) {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
        }

        return nil;
    }

    return item;
}

#else

+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
    if (!username || !serviceName) {
        if (error != nil) {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        }
        return nil;
    }

    if (error != nil) {
        *error = nil;
    }

    // Set up a query dictionary with the base query attributes: item type (generic), username, and service

    NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClassGenericPassword, username, serviceName, nil];

    NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];

    // First do a query for attributes, in case we already have a Keychain item with no password data set.
    // One likely way such an incorrect item could have come about is due to the previous (incorrect)
    // version of this code (which set the password as a generic attribute instead of password data).

    NSMutableDictionary *attributeQuery = [query mutableCopy];
    [attributeQuery setObject: (id) kCFBooleanTrue forKey:(__bridge_transfer id) kSecReturnAttributes];
    CFTypeRef attrResult = NULL;
    OSStatus status = SecItemCopyMatching((__bridge_retained CFDictionaryRef) attributeQuery, &attrResult);
    //NSDictionary *attributeResult = (__bridge_transfer NSDictionary *)attrResult;

    if (status != noErr) {
        // No existing item found--simply return nil for the password
        if (error != nil && status != errSecItemNotFound) {
            //Only return an error if a real exception happened--not simply for "not found."
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
        }

        return nil;
    }

    // We have an existing item, now query for the password data associated with it.

    NSMutableDictionary *passwordQuery = [query mutableCopy];
    [passwordQuery setObject: (id) kCFBooleanTrue forKey: (__bridge_transfer id) kSecReturnData];
    CFTypeRef resData = NULL;
    status = SecItemCopyMatching((__bridge_retained CFDictionaryRef) passwordQuery, (CFTypeRef *) &resData);
    NSData *resultData = (__bridge_transfer NSData *)resData;

    if (status != noErr) {
        if (status == errSecItemNotFound) {
            // We found attributes for the item previously, but no password now, so return a special error.
            // Users of this API will probably want to detect this error and prompt the user to
            // re-enter their credentials.  When you attempt to store the re-entered credentials
            // using storeUsername:andPassword:forServiceName:updateExisting:error
            // the old, incorrect entry will be deleted and a new one with a properly encrypted
            // password will be added.
            if (error != nil) {
                *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -1999 userInfo: nil];
            }
        }
        else {
            // Something else went wrong. Simply return the normal Keychain API error code.
            if (error != nil) {
                *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
            }
        }

        return nil;
    }

    NSString *password = nil;

    if (resultData) {
        password = [[NSString alloc] initWithData: resultData encoding: NSUTF8StringEncoding];
    }
    else {
        // There is an existing item, but we weren't able to get password data for it for some reason,
        // Possibly as a result of an item being incorrectly entered by the previous code.
        // Set the -1999 error so the code above us can prompt the user again.
        if (error != nil) {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -1999 userInfo: nil];
        }
    }

    return password;
}

+ (BOOL) storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error
{
    if (!username || !password || !serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        }
        return NO;
    }

    // See if we already have a password entered for these credentials.
    NSError *getError = nil;
    NSString *existingPassword = [HGBUniqueIDTool getPasswordForUsername: username andServiceName: serviceName error:&getError];

    if ([getError code] == -1999)
    {
        // There is an existing entry without a password properly stored (possibly as a result of the previous incorrect version of this code.
        // Delete the existing item before moving on entering a correct one.

        getError = nil;

        [self deleteItemForUsername: username andServiceName: serviceName error: &getError];

        if ([getError code] != noErr)
        {
            if (error != nil)
            {
                *error = getError;
            }
            return NO;
        }
    }
    else if ([getError code] != noErr)
    {
        if (error != nil)
        {
            *error = getError;
        }
        return NO;
    }

    if (error != nil)
    {
        *error = nil;
    }

    OSStatus status = noErr;

    if (existingPassword)
    {
        // We have an existing, properly entered item with a password.
        // Update the existing item.

        if (![existingPassword isEqualToString:password] && updateExisting)
        {
            //Only update if we're allowed to update existing.  If not, simply do nothing.

            NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClass,
                             kSecAttrService,
                             kSecAttrLabel,
                             kSecAttrAccount,
                             nil];

            NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClassGenericPassword,
                                serviceName,
                                serviceName,
                                username,
                                nil];

            NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];

            status = SecItemUpdate((__bridge_retained CFDictionaryRef) query, (__bridge_retained CFDictionaryRef) [NSDictionary dictionaryWithObject: [password dataUsingEncoding: NSUTF8StringEncoding] forKey: (__bridge_transfer NSString *) kSecValueData]);
        }
    }
    else
    {
        // No existing entry (or an existing, improperly entered, and therefore now
        // deleted, entry).  Create a new entry.

        NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClass,
                         kSecAttrService,
                         kSecAttrLabel,
                         kSecAttrAccount,
                         kSecValueData,
                         nil];

        NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClassGenericPassword,
                            serviceName,
                            serviceName,
                            username,
                            [password dataUsingEncoding: NSUTF8StringEncoding],
                            nil];

        NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];

        status = SecItemAdd((__bridge_retained CFDictionaryRef) query, NULL);
    }

    if (error != nil && status != noErr)
    {
        // Something went wrong with adding the new item. Return the Keychain error code.
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];

        return NO;
    }

    return YES;
}

+ (BOOL) deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error
{
    if (!username || !serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        }
        return NO;
    }

    if (error != nil)
    {
        *error = nil;
    }

    NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClassGenericPassword, username, serviceName, kCFBooleanTrue, nil];

    NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];

    OSStatus status = SecItemDelete((__bridge_retained CFDictionaryRef) query);

    if (error != nil && status != noErr)
    {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];

        return NO;
    }

    return YES;
}

+ (BOOL) purgeItemsForServiceName:(NSString *) serviceName error: (NSError **) error {
    if (!serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        }
        return NO;
    }

    if (error != nil)
    {
        *error = nil;
    }

    NSMutableDictionary *searchData = [NSMutableDictionary new];
    [searchData setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [searchData setObject:serviceName forKey:(__bridge id)kSecAttrService];

    OSStatus status = SecItemDelete((__bridge_retained CFDictionaryRef)searchData);

    if (error != nil && status != noErr)
    {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];

        return NO;
    }

    return YES;
}

#endif


@end
