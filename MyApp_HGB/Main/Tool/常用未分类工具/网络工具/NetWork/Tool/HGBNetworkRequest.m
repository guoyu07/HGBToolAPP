//
//  HGBNetworkRequest.m
//  网络框架
//
//  Created by huangguangbao on 2017/6/8.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBNetworkRequest.h"
#import "AFNetworking.h"
#import <AFNetworking.h>

@interface HGBNetworkRequest ()
/**
 网络请求管理类
 */
@property (nonatomic,strong)AFURLSessionManager *manager;


/**
 成功回调
 */
@property (nonatomic,copy)NetworkRequestSuccess successBlock;
/**
 失败回调
 */
@property (nonatomic,copy)NetworkRequestFailed failedBlock;
/**
 *	@brief	是否需要https.
 */
@property (nonatomic,assign) BOOL isHttps;


/**
 双向认证证书时的双向认证
 */
@property (nonatomic, copy) NSString *cerFilePath;
/**
 双向认证证书密码
 */
@property (nonatomic,copy) NSString *cerFilePassword;

@end
@implementation HGBNetworkRequest
#pragma mark init
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        self.manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
        self.requestUrl = [NSString stringWithFormat:@"%@",@""];
        self.requestMethod = @"POST";
        self.sendFormat =DATA_SEND_FORMAT_NO ;
        self.mineType=@"image/jpeg";
        self.updateName=@"uploadFile";
    }
    return self;
}
#pragma mark 证书
/**
 *	@brief	双向认证设置证书.
 *  证书为P12.
 *
 *	@param 	cerFilePath 	证书路径.
 *  @param  cerPassword     证书密码.
 */
- (void)setHttpsBidirectionalAuthCertificateFilePath:(NSString *)cerFilePath cerPassword:(NSString *)cerPassword
{
    self.cerFilePath = cerFilePath;
    self.cerFilePassword = cerPassword;
    if (self.cerFilePath) {
        //         准备：将证书的二进制读取，放入set中
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:self.cerFilePath ofType:nil];
        NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
        NSSet *set = [[NSSet alloc] initWithObjects:cerData, nil];
        self.manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:set]; // 关键语句1
        self.manager.securityPolicy.allowInvalidCertificates = YES; // 关键语句2
    }
}
#pragma mark 参数
/**
 *	@brief	添加请求body标准(":")格式参数.
 *
 *	@param 	parma 	参数名.
 *	@param 	value 	参数数据值.
 */
- (void)appendFormatBodyParma:(NSString *)parma value:(id)value
{
    if (!_bodyParams) {
        _bodyParams = [NSString stringWithFormat:@"%@:%@",parma,value];
    }else{
        _bodyParams = [_bodyParams stringByAppendingFormat:@"&%@:%@",parma,value];
    }
}
/**
 *	@brief	添加请求body"="格式参数.
 *
 *	@param 	parma 	参数名.
 *	@param 	value 	参数数据值.
 */
- (void)appendEqualBodyParma:(NSString *)parma value:(id)value
{
    if (!_bodyParams) {
        _bodyParams = [NSString stringWithFormat:@"%@=%@",parma,value];
    }else{
        _bodyParams = [_bodyParams stringByAppendingFormat:@"&%@=%@",parma,value];
    }
}
/**
 *	@brief	添加请求body自定义格式参数.
 *
 *	@param 	parma 	参数字符串
 */
- (void)appendBodyParma:(id)parma
{
    if (!_bodyParams) {
        _bodyParams = [NSString stringWithFormat:@"%@",parma];
    }else{
        _bodyParams = [_bodyParams stringByAppendingFormat:@"%@",parma];
    }
}

#pragma mark - block机制支持
/**
 *	@brief	设置回调block
 *
 *	@param 	successBlock 	成功block
 *	@param 	failedBlock 	失败block
 */
- (void)requestWithSuccessBlock:(NetworkRequestSuccess)successBlock failedBlock:(NetworkRequestFailed)failedBlock
{
    
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;


    self.requestUrl=[HGBNetworkRequest transToUrlFormatString:self.requestUrl];

    if([self.requestUrl containsString:@"https://"]){
        self.isHttps=YES;
    }else{
        self.isHttps=NO;
    }

    if(self.quickContentType!=CONTENTTYPE_FILEDATA){
        if(self.pramDic&&[self.pramDic allKeys].count>0){
            self.bodyParams=[HGBNetworkRequest ObjectToJSONString:self.pramDic];
        }
    }

    /*-----------------报文发送格式---------------------*/
    if (self.sendFormat == DATA_SEND_FORMAT_NO) {
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }else if (self.sendFormat == DATA_SEND_FORMAT_JSON){
        /*
         - `application/json`
         - `text/json`
         - `text/javascript`
         */
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }else if (self.sendFormat == DATA_SEND_FORMAT_XML){
        /*
         - `application/xml`
         - `text/xml`
         */
        self.manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    }


    /*-----------------请求协议类型---------------------*/
    if (self.isHttps) {
        if(self.cerFilePath==nil||self.cerFilePath.length==0||self.cerFilePassword==nil||self.cerFilePassword.length==0){
            self.manager.securityPolicy.validatesDomainName = NO;
            self.manager.securityPolicy.allowInvalidCertificates = YES;
        }else{
            if(![HGBNetworkRequest isExitAtFilePath:self.cerFilePath]){
                self.manager.securityPolicy.validatesDomainName = NO;
                self.manager.securityPolicy.allowInvalidCertificates = YES;
            }
        }
    }
    NSLog(@"%@",self.requestUrl);
    NSLog(@"%@",self.bodyParams);



    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.requestUrl] cachePolicy:(NSURLRequestReloadIgnoringLocalAndRemoteCacheData) timeoutInterval:120];
    
    request.HTTPMethod = self.requestMethod;
    

    /*-----------------请求方式---------------------*/
    if ([self.requestMethod isEqualToString:@"GET"]) {
    }else{
        if(self.quickContentType==CONTENTTYPE_NO){
            self.bodyParams = [HGBNetworkRequest stringEncodingWithStr:self.bodyParams];
        }
        [request setHTTPBody:[self.bodyParams dataUsingEncoding:NSUTF8StringEncoding]];
    }
    /*-----------------报文格式---------------------*/
    if (self.quickContentType==CONTENTTYPE_RAW){
        //设置Content-Type
        NSString *strContentType = [NSString stringWithFormat:@"application/raw;charset=utf-8"];
        [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
    }else if (self.quickContentType==CONTENTTYPE_X_W_FORMUNENCODE){
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
    }else if (self.quickContentType==CONTENTTYPE_FORMAT){
        [request setValue:@"application/form-data" forHTTPHeaderField:@"Content-Type"];
    }else if(self.quickContentType==CONTENTTYPE_FILEDATA){
        //文件上传数据
        if (self.fileData.length > 0) {
            request.HTTPBody = self.fileData;
            NSLog(@"%@-%@-%@",self.fileName,self.updateName,self.mineType);
            
            request=[[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:self.requestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                if(self.mineType&&self.mineType.length!=0){
                    [formData appendPartWithFileData:self.fileData name:self.updateName fileName:self.fileName mimeType:self.mineType];
                }else{
                    [formData appendPartWithFormData:self.fileData name:self.updateName];
                    
                }
                if(self.pramDic&&[self.pramDic allKeys].count>0){
                    NSArray *keys=[self.pramDic allKeys];
                    for(NSString *key in keys){
                        NSString *obj=[self.pramDic objectForKey:key];
                        [formData appendPartWithFormData:[obj dataUsingEncoding:NSUTF8StringEncoding] name:key];
                    }
                }
            } error:nil];
            return;
        }
    }

    /*-----------------请求头---------------------*/
    NSArray *keyArr = [self.headParms allKeys];
    if ([keyArr count] > 0) {
        for (NSString *key in keyArr) {
            [request setValue:[self.headParms objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if(self.isSaveCookie){
            [HGBNetworkRequest saveCookieTolocal];
        }
        if (error) {
            NSLog(@"Error: %@", error.description);
            failedBlock(error);
            if(error.code==-1009||[error.localizedDescription containsString:@"断开"]){
                
            }
            
        } else {
            NSLog(@"%@",responseObject);
            successBlock(responseObject);
        }
    }];
    [dataTask resume];
    
}
#pragma mark 工具
/**
 把Json对象转化成json字符串
 
 @param object json对象
 @return json字符串
 */
+ (NSString *)ObjectToJSONString:(id)object
{
    if(!([object isKindOfClass:[NSDictionary class]]||[object isKindOfClass:[NSArray class]]||[object isKindOfClass:[NSString class]])){
        return @"";
    }
    if([object isKindOfClass:[NSString class]]){
        return object;
    }
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return myString;
}
/**
 字符串编码

 @param str 原字符串
 @return 编码后字符串
 */
+(NSString *)stringEncodingWithStr:(NSString *)str
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return encodedString;
}
/**
 *  url空格处理
 *
 *  @param urlStr 原url
 *
 *  @return 新url
 */
+(NSString *)transToUrlFormatString:(NSString *)urlStr{
    return [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

/**
 *  把cookie保存到本地
 */
+ (void)saveCookieTolocal
{
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookieArray addObject:cookie.name];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
        [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
        [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[NSNumber numberWithInteger:cookie.version] forKey:NSHTTPCookieVersion];
        
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
        
        [[NSUserDefaults standardUserDefaults] setValue:cookieProperties forKey:cookie.name];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:cookieArray forKey:@"cookieArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 文档是否存在

 @param filePath 文件路径
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
