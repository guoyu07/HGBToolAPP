//
//  HGBRSAEncrytor.m
//  测试app
//
//  Created by huangguangbao on 2017/7/6.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBRSAEncrytor.h"
#import <security/Security.h>

@implementation HGBRSAEncrytor
static HGBRSAEncrytor *instance=nil;
#pragma mark init
/**
 单例

 @return 实体
 */
+(instancetype)shareInstance
{
    if(instance==nil){
        instance=[[HGBRSAEncrytor alloc]init];
    }
    return instance;
}

#pragma mark base64
/**
 base64编码

 @param data 数据流
 @return 编码后字符串
 */
static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

/**
 base64解码

 @param str 字符串
 @return 数据流
 */
static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}
#pragma mark 加密解密方法
/**
 公钥加密

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)publicKeyEncryptString:(NSString *)string{
    [HGBRSAEncrytor shareInstance];
    if(!instance.useStringKey){
        if(instance.publicKeyPath==nil||instance.publicKeyPath.length==0){
            NSLog(@"公钥文件路径不能为空");
            return nil;
        }
        NSString *path=[HGBRSAEncrytor getCompletePathFromSimplifyFilePath:instance.publicKeyPath];
        if(![HGBRSAEncrytor isExitAtFilePath:path]){
            NSLog(@"公钥文件不存在");
            return nil;
        }
        SecKeyRef secKeyRef=[HGBRSAEncrytor getPublicKeyRefWithContentsOfFile:path];
        if(secKeyRef){
            return [HGBRSAEncrytor encryptString:string withPublicKeyRef:secKeyRef];
        }else{
            return nil;
        }

    }else{
        if(instance.publicKey==nil||instance.publicKey.length==0){
            NSLog(@"公钥不能为空");
            return nil;
        }
        NSData *data = [HGBRSAEncrytor encryptData:[string dataUsingEncoding:NSUTF8StringEncoding] withPublicKey:instance.publicKey];
        if(data){
            NSString *ret = base64_encode_data(data);
            return ret;
        }else{
            return nil;
        }
    }
    return nil;
}

/**
 私钥解密

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)privateKeyDecryptStringString:(NSString *)string{
    [HGBRSAEncrytor shareInstance];
    if(!instance.useStringKey){
        if(instance.privateKeyPath==nil||instance.privateKeyPath.length==0){
            NSLog(@"私钥文件路径不能为空");
            return nil;
        }
        if(instance.privateKeyPassword==nil||instance.privateKeyPassword.length==0){
            NSLog(@"私钥文件密钥不能为空");
            return nil;
        }
        NSString *path=[HGBRSAEncrytor getCompletePathFromSimplifyFilePath:instance.privateKeyPath];
        if(![HGBRSAEncrytor isExitAtFilePath:path]){
            NSLog(@"私钥文件不存在");
            return nil;
        }
        SecKeyRef secKeyRef=[HGBRSAEncrytor getPrivateKeyRefWithContentsOfFile:path password:instance.privateKeyPassword];
        if(secKeyRef){
            return [HGBRSAEncrytor decryptString:string withPrivateKeyRef:secKeyRef];
        }else{
            return nil;
        }
    }else{
        if(instance.privateKey==nil||instance.privateKey.length==0){
            NSLog(@"私钥不能为空");
            return nil;
        }
        NSData *data = [HGBRSAEncrytor decryptData:[string dataUsingEncoding:NSUTF8StringEncoding] withPrivateKey:instance.privateKey];
        if(data){
            NSString *ret = base64_encode_data(data);
            return ret;
        }else{
            return nil;
        }
    }
    return nil;
}

/**
 私钥加密

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)privateKeyEncryptString:(NSString *)string{
    [HGBRSAEncrytor shareInstance];
    if(!instance.useStringKey){
        if(instance.privateKeyPath==nil||instance.privateKeyPath.length==0){
            NSLog(@"私钥文件路径不能为空");
            return nil;
        }
        if(instance.privateKeyPassword==nil||instance.privateKeyPassword.length==0){
            NSLog(@"私钥文件密钥不能为空");
            return nil;
        }
        NSString *path=[HGBRSAEncrytor getCompletePathFromSimplifyFilePath:instance.privateKeyPath];
        if(![HGBRSAEncrytor isExitAtFilePath:path]){
            NSLog(@"私钥文件不存在");
            return nil;
        }
        SecKeyRef secKeyRef=[self getPrivateKeyRefWithContentsOfFile:path password:instance.privateKeyPassword];
        if(secKeyRef){
            return [HGBRSAEncrytor encryptString:string withPrivateKeyRef:secKeyRef];
        }else{
            return nil;
        }
    }else{
        if(instance.privateKey==nil||instance.privateKey.length==0){
            NSLog(@"私钥不能为空");
            return nil;
        }
        NSData *data = [HGBRSAEncrytor encryptData:[string dataUsingEncoding:NSUTF8StringEncoding] withPrivateKey:instance.privateKey];
        if(data){
            NSString *ret = base64_encode_data(data);
            return ret;
        }else{
            return nil;
        }
    }
    return nil;
}


/**
 公钥解密

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)publicKeyDecryptStringString:(NSString *)string{
    [HGBRSAEncrytor shareInstance];
    if(!instance.useStringKey){
        if(instance.publicKeyPath==nil||instance.publicKeyPath.length==0){
            NSLog(@"公钥文件路径不能为空");
            return nil;
        }
        NSString *path=[HGBRSAEncrytor getCompletePathFromSimplifyFilePath:instance.publicKeyPath];
        if(![HGBRSAEncrytor isExitAtFilePath:path]){
            NSLog(@"公钥文件不存在");
            return nil;
        }
        SecKeyRef secKeyRef=[HGBRSAEncrytor getPublicKeyRefWithContentsOfFile:path];
        if(secKeyRef){
            return [HGBRSAEncrytor decryptString:string withPublicKeyRef:secKeyRef];
        }else{
            return nil;
        }
    }else{
        if(instance.publicKey==nil||instance.publicKey.length==0){
            NSLog(@"公钥不能为空");
            return nil;
        }
        NSData *data = [HGBRSAEncrytor decryptData:[string dataUsingEncoding:NSUTF8StringEncoding] withPublicKey:instance.publicKey];
        if(data){
            NSString *ret = base64_encode_data(data);
            return ret;
        }else{
            return nil;
        }
    }
    return nil;
}
#pragma mark 公钥加密 私钥解密-密钥字符串
/**
 使用公钥字符串加密数据流

 @param data 数据流
 @param pubKey 公钥字符串
 @return 加密后数据流
 */
+ (NSData *)encryptData:(NSData *)data withPublicKey:(NSString *)pubKey{
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    return [self encryptData:data withKeyRef:keyRef];
}
/**
  使用私钥字符串解密数据流

 @param data 数据流
 @param privKey 私钥字符串
 @return 数据流
 */
+ (NSData *)decryptData:(NSData *)data withPrivateKey:(NSString *)privKey{
    if(!data || !privKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPrivateKey:privKey];
    if(!keyRef){
        return nil;
    }
    return [self decryptData:data withKeyRef:keyRef];
}
#pragma mark 私钥加密 公钥解密-密钥字符串
/**
 使用私钥字符串加密数据流

 @param data 数据流
 @param privKey 私钥字符串
 @return 加密后数据流
 */
+ (NSData *)encryptData:(NSData *)data withPrivateKey:(NSString *)privKey{
    if(!data || !privKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPrivateKey:privKey];
    if(!keyRef){
        return nil;
    }
    return [self encryptData:data withKeyRef:keyRef];
}
/**
 使用公钥字符串解密数据流

 @param data 数据流
 @param pubKey 公钥字符串
 @return 数据流
 */
+ (NSData *)decryptData:(NSData *)data withPublicKey:(NSString *)pubKey{
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    return [self decryptData:data withKeyRef:keyRef];
}
#pragma mark 公钥加密 私钥解密-密钥

/**
 公钥加密

 @param string 字符串
 @param publicKeyRef 公钥
 @return 加密后字符串
 */
+ (NSString *)encryptString:(NSString *)string withPublicKeyRef:(SecKeyRef)publicKeyRef{
    if(![string dataUsingEncoding:NSUTF8StringEncoding]){
        return nil;
    }
    if(!publicKeyRef){
        return nil;
    }
    NSData *data = [self encryptData:[string dataUsingEncoding:NSUTF8StringEncoding] withKeyRef:publicKeyRef];
    NSString *ret = base64_encode_data(data);
    return ret;
}
/**
 私钥解密

 @param string 字符串
 @param privKeyRef 私钥
 @return 解密后字符串
 */
+ (NSString *)decryptString:(NSString *)string withPrivateKeyRef:(SecKeyRef)privKeyRef{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self decryptData:data withKeyRef:privKeyRef];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

#pragma mark 私钥加密 公钥解密-密钥
/**
 私钥加密

 @param string 字符串
 @param privKeyRef 私钥
 @return 加密后字符串
 */
+ (NSString *)encryptString:(NSString *)string withPrivateKeyRef:(SecKeyRef)privKeyRef{
    if(![string dataUsingEncoding:NSUTF8StringEncoding]){
        return nil;
    }
    if(!privKeyRef){
        return nil;
    }
    NSData *data = [self encryptData:[string dataUsingEncoding:NSUTF8StringEncoding] withKeyRef:privKeyRef];
    NSString *ret = base64_encode_data(data);
    return ret;
}
/**
 公钥解密

 @param string 字符串
 @param publicKeyRef 公钥
 @return 解密后字符串
 */
+ (NSString *)decryptString:(NSString *)string withPublicKeyRef:(SecKeyRef)publicKeyRef {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self decryptData:data withKeyRef:publicKeyRef];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

#pragma mark 加密及解密实现-密钥


/**
 使用密钥加密数据流

 @param data 数据流
 @param keyRef 密钥
 @return 加密后数据流
 */
+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;

    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;

    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }

        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }

    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

/**
 解密数据

 @param data 数据流
 @param keyRef 钥匙
 @return 数据流
 */
+ (NSData *)decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;

    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;

    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }

        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)status);
            ret = nil;
            break;
        }else{
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }

            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}
#pragma mark 公钥
/**
 获取公钥

 @param filePath 公钥路径
 @return 公钥
 */
+ (SecKeyRef)getPublicKeyRefWithContentsOfFile:(NSString *)filePath{
    NSData *certData = [NSData dataWithContentsOfFile:filePath];
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (CFDataRef)certData);
    SecKeyRef key = NULL;
    SecTrustRef trust = NULL;
    SecPolicyRef policy = NULL;
    if (cert != NULL) {
        policy = SecPolicyCreateBasicX509();
        if (policy) {
            if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) == noErr) {
                SecTrustResultType result;
                if (SecTrustEvaluate(trust, &result) == noErr) {
                    key = SecTrustCopyPublicKey(trust);
                }
            }
        }
    }
    if (policy) CFRelease(policy);
    if (trust) CFRelease(trust);
    if (cert) CFRelease(cert);
    return key;
}

/**
 添加公钥

 @param key 公钥字符串
 @return 公钥
 */
+ (SecKeyRef)addPublicKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];

    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }

    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];

    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);

    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];

    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }

    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}
/**
 删除公钥头部

 @param d_key 公钥流
 @return 公钥流
 */
+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);

    unsigned long len = [d_key length];
    if (!len) return(nil);

    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 0;

    if (c_key[idx++] != 0x30) return(nil);

    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;

    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);

    idx += 15;

    if (c_key[idx++] != 0x03) return(nil);

    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;

    if (c_key[idx++] != '\0') return(nil);

    // Now make a new NSData from this buffer
    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}
#pragma mark 私钥
//获取私钥
+ (SecKeyRef)getPrivateKeyRefWithContentsOfFile:(NSString *)filePath password:(NSString*)password{

    NSData *p12Data = [NSData dataWithContentsOfFile:filePath];
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject: password forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);

    return privateKeyRef;
}

/**
 添加私钥

 @param key 私钥字符串
 @return 私钥
 */
+ (SecKeyRef)addPrivateKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];

    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPrivateKeyHeader:data];
    if(!data){
        return nil;
    }

    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PrivKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];

    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);

    // Add persistent version of the key to system keychain
    [privateKey setObject:data forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
     kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];

    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }

    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}
/**
 删除私钥头

 @param d_key 私钥流
 @return 钥匙流
 */
+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key{
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);

    unsigned long len = [d_key length];
    if (!len) return(nil);

    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 22; //magic byte at offset 22

    if (0x04 != c_key[idx++]) return nil;

    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }

    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}
#pragma mark 获取文件完整路径

/**
 将简化路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
+(NSString *)getCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    NSString *path=[simplifyFilePath copy];
    if(![HGBRSAEncrytor isExitAtFilePath:path]){
        path=[[HGBRSAEncrytor getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
        if(![HGBRSAEncrytor isExitAtFilePath:path]){
            path=[[HGBRSAEncrytor getDocumentFilePath] stringByAppendingPathComponent:simplifyFilePath];
            if(![HGBRSAEncrytor isExitAtFilePath:path]){
                path=[[HGBRSAEncrytor getMainBundlePath] stringByAppendingPathComponent:simplifyFilePath];
                if(![HGBRSAEncrytor isExitAtFilePath:path]){

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
