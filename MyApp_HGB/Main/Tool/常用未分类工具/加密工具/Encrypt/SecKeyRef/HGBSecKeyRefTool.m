//
//  HGBSecKeyRefTool.m
//  测试
//
//  Created by huangguangbao on 2017/9/11.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBSecKeyRefTool.h"

#define PrivateKeyFlag @"PrivateKey"
#define PublicKeyFlag @"PublicKey"

@implementation HGBSecKeyRefTool
#pragma mark加密密钥生成
/**
 加密密钥生成

 @param keySize 密钥大小
 @param reslut 结果
 */
+(void)generateEncryptKeyWithKeySize:(NSInteger)keySize andWithReslut:(void(^)(SecKeyRef publicKey,SecKeyRef privateKey,NSString *stringPublicKey,NSString *stringprivateKey))reslut{
    [HGBSecKeyRefTool generateEncryptKeyWithKeySize:keySize andWithEncyptType:(HGBEncryptKeyTypeRSA) andWithReslut:reslut];
}
/**
 加密密钥生成

 @param keySize 密钥大小
 @param keyType 密钥类型
 @param reslut 结果
 */
+(void)generateEncryptKeyWithKeySize:(NSInteger)keySize andWithEncyptType:(HGBEncryptKeyType)keyType andWithReslut:(void(^)(SecKeyRef publicKey,SecKeyRef privateKey,NSString *stringPublicKey,NSString *stringprivateKey))reslut{
    OSStatus ret = 0;
    SecKeyRef publicKeyRef; //公钥
    SecKeyRef privateKeyRef;//私钥

    ret = SecKeyGeneratePair((CFDictionaryRef)@{(id)kSecAttrKeyType:(id)kSecAttrKeyTypeRSA,(id)kSecAttrKeySizeInBits:@(keySize)}, &publicKeyRef, &privateKeyRef);
    NSAssert(ret==errSecSuccess, @"密钥对生成失败：%d",ret);

    NSLog(@"%@",publicKeyRef);
    NSLog(@"%@",privateKeyRef);
    NSLog(@"max size:%lu",SecKeyGetBlockSize(privateKeyRef));

    NSString *publicKeyString,*privateKeyString;
    if(publicKeyRef){
        publicKeyString=[HGBSecKeyRefTool getKeyBitsFromKey:publicKeyRef];
    }


    reslut(publicKeyRef,privateKeyRef,@"",@"");
}
+(NSString *)getKeyBitsFromKey:(SecKeyRef)givenKey {

    static const uint8_t publicKeyIdentifier[] = "com.your.company.publickey";
    NSData *publicTag = [[NSData alloc] initWithBytes:publicKeyIdentifier length:sizeof(publicKeyIdentifier)];



    OSStatus sanityCheck = noErr;
    NSData * keyData = nil;

    NSMutableDictionary * queryKey = [[NSMutableDictionary alloc] init];
    [queryKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

    // Temporarily add key to the Keychain, return as data:
    NSMutableDictionary * attributes = [queryKey mutableCopy];
    [attributes setObject:(__bridge id)givenKey forKey:(__bridge id)kSecValueRef];
    [attributes setObject:@YES forKey:(__bridge id)kSecReturnData];
    CFTypeRef result;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) attributes, &result);
    if (sanityCheck == errSecSuccess) {
        keyData = CFBridgingRelease(result);

        // Remove from Keychain again:
        (void)SecItemDelete((__bridge CFDictionaryRef) queryKey);
    }
    keyData = [keyData base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
    return ret;
}
#pragma mark 读取密钥
/**
 从x509 cer证书中读取公钥
 */
+ (SecKeyRef )publicKeyFromCerFile:(NSString *)cerFilePath
{
    OSStatus            err;
    NSData *            certData;
    SecCertificateRef   cert;
    SecPolicyRef        policy;
    SecTrustRef         trust;
    SecTrustResultType  trustResult;
    SecKeyRef           publicKeyRef;

    certData = [NSData dataWithContentsOfFile:cerFilePath];
    cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) certData);
    policy = SecPolicyCreateBasicX509();
    err = SecTrustCreateWithCertificates(cert, policy, &trust);
    NSAssert(err==errSecSuccess,@"证书加载失败");
    err = SecTrustEvaluate(trust, &trustResult);
    NSAssert(err==errSecSuccess,@"公钥加载失败");
    publicKeyRef = SecTrustCopyPublicKey(trust);

    CFRelease(policy);
    CFRelease(cert);
    return publicKeyRef;
}



/**
 从 p12 文件中读取私钥，一般p12都有密码
 */
+ (SecKeyRef )privateKeyFromP12File:(NSString *)p12FilePath password:(NSString *)password

{
    NSData *            pkcs12Data;
    CFArrayRef          imported;
    NSDictionary *      importedItem;
    SecIdentityRef      identity;
    OSStatus            err;
    SecKeyRef           privateKeyRef;

    pkcs12Data = [NSData dataWithContentsOfFile:p12FilePath];
    err = SecPKCS12Import((__bridge CFDataRef)pkcs12Data,(__bridge CFDictionaryRef) @{(__bridge NSString *)kSecImportExportPassphrase:password}, &imported);
    NSAssert(err==errSecSuccess,@"p12加载失败");
    importedItem = (__bridge NSDictionary *) CFArrayGetValueAtIndex(imported, 0);
    identity = (__bridge SecIdentityRef) importedItem[(__bridge NSString *) kSecImportItemIdentity];

    err = SecIdentityCopyPrivateKey(identity, &privateKeyRef);
    NSAssert(err==errSecSuccess,@"私钥加载失败");
    CFRelease(imported);


    return privateKeyRef;
}


+ (SecKeyRef )publicKeyFromPemFile:(NSString *)pemFilePath keySize:(size_t )keySize
{
    SecKeyRef pubkeyref;
    NSError *readFErr = nil;
    CFErrorRef errref = noErr;
    NSString *pemStr = [NSString stringWithContentsOfFile:pemFilePath encoding:NSASCIIStringEncoding error:&readFErr];
    NSAssert(readFErr==nil, @"pem文件加载失败");
    pemStr = [pemStr stringByReplacingOccurrencesOfString:@"-----BEGIN PUBLIC KEY-----" withString:@""];
    pemStr = [pemStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    pemStr = [pemStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    pemStr = [pemStr stringByReplacingOccurrencesOfString:@"-----END PUBLIC KEY-----" withString:@""];
    NSData *dataPubKey = [[NSData alloc]initWithBase64EncodedString:pemStr options:0];

    NSMutableDictionary *dicPubkey = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dicPubkey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [dicPubkey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)kSecAttrKeyClass];
    [dicPubkey setObject:@(keySize) forKey:(__bridge id)kSecAttrKeySizeInBits];

    pubkeyref = SecKeyCreateWithData((__bridge CFDataRef)dataPubKey, (__bridge CFDictionaryRef)dicPubkey, &errref);

    NSAssert(errref==noErr, @"公钥加载错误");

    return pubkeyref;
}

+ (SecKeyRef )privaKeyFromPemFile:(NSString *)pemFilePath keySize:(size_t )keySize
{
    SecKeyRef prikeyRef;
    NSError *readFErr = nil;
    CFErrorRef err = noErr;

    NSString *pemStr = [NSString stringWithContentsOfFile:pemFilePath encoding:NSASCIIStringEncoding error:&readFErr];
    NSAssert(readFErr==nil, @"pem文件加载失败");
    pemStr = [pemStr stringByReplacingOccurrencesOfString:@"-----BEGIN RSA PRIVATE KEY-----" withString:@""];
    pemStr = [pemStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    pemStr = [pemStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    pemStr = [pemStr stringByReplacingOccurrencesOfString:@"-----END RSA PRIVATE KEY-----" withString:@""];
    NSData *pemData = [[NSData alloc]initWithBase64EncodedString:pemStr options:0];

    NSMutableDictionary *dicPrikey = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dicPrikey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [dicPrikey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)kSecAttrKeyClass];
    [dicPrikey setObject:@(keySize) forKey:(__bridge id)kSecAttrKeySizeInBits];

    prikeyRef = SecKeyCreateWithData((__bridge CFDataRef)pemData, (__bridge CFDictionaryRef)dicPrikey, &err);
    NSAssert(err==noErr, @"私钥加载错误");


    return prikeyRef;
}

@end
