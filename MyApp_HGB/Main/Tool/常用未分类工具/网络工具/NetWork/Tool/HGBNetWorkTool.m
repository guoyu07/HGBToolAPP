//
//  HGBNetWorkTool.m
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBNetWorkTool.h"
#import "HGBNetworkRequest.h"

@interface HGBNetWorkTool()
/**
 *	@brief	数据报文格式(默认FORMAT_NO).
 */
@property (nonatomic, assign) DATA_SEND_FORMAT  sendFormat;
/**
 是否设置了报文格式
 */
@property(assign,nonatomic)BOOL isSetSendFormat;
/**
 *  快捷设置报文请求头ContentType数据格式
 */
@property (nonatomic , assign)DATA_SEND_CONTENTTYPE quickContentType;
/**
 是否设置了快捷设置报文请求头ContentType数据格式
 */
@property(assign,nonatomic)BOOL isSetQuickContentType;
/**
 *	@brief	是否保存Cookie
 */
@property (nonatomic,assign) BOOL isSaveCookie;

/**
 是否是https请求
 */
@property(assign,nonatomic)BOOL isHttps;
/**
 双向认证证书时的双向认证
 */
@property (nonatomic, copy) NSString *cerFilePath;
/**
 双向认证证书密码
 */
@property (nonatomic,copy) NSString *cerFilePassword;

/**
 请求头
 */
@property(strong,nonatomic)NSDictionary *headers;
@end
@implementation HGBNetWorkTool
static HGBNetWorkTool *instance=nil;
#pragma mark init
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBNetWorkTool alloc]init];
    }
    return instance;
}
#pragma mark 设置
/**
 设置请求报文格式

 @param sendFormat 报文格式
 */
+(void)setNetWorkDataSendFormat:(DATA_SEND_FORMAT)sendFormat{
    [HGBNetWorkTool shareInstance];
    instance.sendFormat=sendFormat;
    instance.isSetSendFormat=YES;
}
/**
 快捷设置报文ContentType数据格式

 @param quickContentType ContentType
 */
+(void)setNetWorkDataQuickContentType:(DATA_SEND_CONTENTTYPE)quickContentType{
    [HGBNetWorkTool shareInstance];
    instance.quickContentType=quickContentType;
    instance.isSetQuickContentType=YES;
}
/**
 设置请求头

 @param headers 请求头
 */
+(void)setNetWorkHeaders:(NSDictionary *)headers{
    [HGBNetWorkTool shareInstance];
    instance.headers=headers;
}
/**
 设置http请求

 @param isSaveCookie 是否保存Cookie
 */
+(void)setIsSaveCookie:(BOOL)isSaveCookie{
    [HGBNetWorkTool shareInstance];
    instance.isSaveCookie=isSaveCookie;
}
/**
 设置http请求

 @param isHttps 是否是https
 */
+(void)setIsHttps:(BOOL)isHttps{
    [HGBNetWorkTool shareInstance];
    instance.isHttps=isHttps;
}
/**
 *	@brief	双向认证设置证书.
 *  证书为P12.
 *
 *	@param 	cerFilePath 	证书路径.
 *  @param  cerPassword     证书密码.
 */
+(void)setHttpsCertificateFilePath:(NSString *)cerFilePath cerPassword:(NSString *)cerPassword{
    [HGBNetWorkTool shareInstance];
    instance.cerFilePath=cerFilePath;
    instance.cerFilePassword=cerPassword;
}
#pragma mark 服务
/**
 *  GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数-字典或字符串格式
 *  @param successBlock 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failedBlock 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)get:(NSString *)url params:(id)params andWithSuccessBlock:(NetworkRequestSuccess)successBlock failedBlock:(NetworkRequestFailed)failedBlock{
    [HGBNetWorkTool shareInstance];


    HGBNetworkRequest *request = [[HGBNetworkRequest alloc]init];

    //请求配置
    request.requestMethod = @"GET";
    if(instance.isSetSendFormat){
        request.sendFormat=instance.sendFormat;
    }else{
        request.sendFormat=DATA_SEND_FORMAT_JSON;
    }
    if(instance.isSetQuickContentType){
        request.quickContentType=instance.quickContentType;
    }else{
        request.quickContentType=CONTENTTYPE_RAW;
    }

    //请求链接
    NSString *urlStr=url;
    if([params isKindOfClass:[NSDictionary class]]){
        NSDictionary *paramsDic=(NSDictionary *)params;
        if(paramsDic&&[paramsDic allKeys].count!=0){
            NSArray *keys=[paramsDic allKeys];
            int i=0;
            for(NSString *key in keys){
                id value=[paramsDic objectForKey:key];
                if(value==nil){
                    continue;
                }
                if(![value isKindOfClass:[NSString class]]){
                    value=[HGBNetworkRequest ObjectToJSONString:value];
                }
                if(i==0){
                    urlStr=[NSString stringWithFormat:@"%@?%@=%@",urlStr,key,value];
                }else{
                    urlStr=[NSString stringWithFormat:@"%@&%@=%@",urlStr,key,value];
                }
                
            }
        }
    }else if([params isKindOfClass:[NSString class]]){
        NSString *paramsString=(NSString *)params;
        if([[paramsString substringToIndex:1] isEqualToString:@"?"]){
            url=[NSString stringWithFormat:@"%@%@",url,paramsString];
        }else{
            url=[NSString stringWithFormat:@"%@?%@",url,paramsString];
        }

    }else{
        NSError *error=[[NSError alloc]initWithDomain:@"错误" code:1999 userInfo:@{@"error":@"参数格式错误"}];
         failedBlock(error);
        return;
    }
    request.requestUrl=urlStr;


    //请求
    [request requestWithSuccessBlock:^(id responseObject) {
        successBlock(responseObject);
    
    } failedBlock:^(NSError *error) {
        failedBlock(error);
    }];
}
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数-字典或字符串格式
 *  @param successBlock 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failedBlock 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)post:(NSString *)url params:(id)params andWithSuccessBlock:(NetworkRequestSuccess)successBlock failedBlock:(NetworkRequestFailed)failedBlock{
    [HGBNetWorkTool shareInstance];

    if(params==nil){
        params=@{};
    }
    
    HGBNetworkRequest *request = [[HGBNetworkRequest alloc]init];

    //请求链接
    request.requestUrl=url;

    //请求配置
    request.requestMethod = @"POST";

    if(instance.isSetSendFormat){
        request.sendFormat=instance.sendFormat;
    }else{
        request.sendFormat=DATA_SEND_FORMAT_NO;
    }
    if(instance.isSetQuickContentType){
        request.quickContentType=instance.quickContentType;
    }else{
        request.quickContentType=CONTENTTYPE_RAW;
    }
    if(instance.headers&&[instance.headers allKeys].count!=0){
        request.headParms=[NSMutableDictionary dictionaryWithDictionary:instance.headers];
    }

    NSString *jsonString;
    //请求参数
    if([params isKindOfClass:[NSDictionary class]]){
        NSDictionary *paramsDic=(NSDictionary *)params;

        jsonString=[HGBNetworkRequest ObjectToJSONString:paramsDic];

    }else if([params isKindOfClass:[NSString class]]){
        jsonString=(NSString *)params;
    }else{
        NSError *error=[[NSError alloc]initWithDomain:@"错误" code:1999 userInfo:@{@"error":@"参数格式错误"}];
        failedBlock(error);
        return;
    }
    [request appendBodyParma:jsonString];

    //请求
    [request requestWithSuccessBlock:^(id responseObject) {
        successBlock(responseObject);
        
    } failedBlock:^(NSError *error) {
        failedBlock(error);
    }];
}

/**
 *  文件上传请求
 *
 *  @param url     请求路径
 *  @param fileData  文件数据
 *  @param fileName  文件名
 *  @param successBlock 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failedBlock 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+(void)uploadFileWithUrl:(NSString *)url WithData:(NSData *)fileData fileName:(NSString *)fileName andWithSuccessBlock:(NetworkRequestSuccess)successBlock failedBlock:(NetworkRequestFailed)failedBlock{
    
    
    HGBNetworkRequest *request = [[HGBNetworkRequest alloc]init];

    //请求链接
    request.requestUrl = url;


    //请求配置
    request.requestMethod = @"POST";
    request.quickContentType=CONTENTTYPE_FILEDATA;

    //请求参数
    request.updateName=@"uploadFile";
    request.fileData=fileData;
    request.fileName=fileName;
    if((!fileData)||fileName.length==0||fileName==nil){
        failedBlock(nil);
        return;
    }
    //请求
    [request requestWithSuccessBlock:^(id responseObject) {
        successBlock(responseObject);
        
    } failedBlock:^(NSError *error) {
        failedBlock(error);
        
    }];
}
/**
 *  图片上传请求
 *
 *  @param url     请求路径
 *  @param image   图片
 *  @param fileName  文件名
 *  @param successBlock 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failedBlock 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+(void)uploadImageWithUrl:(NSString *)url WithImage:(UIImage *)image fileName:(NSString *)fileName andWithSuccessBlock:(NetworkRequestSuccess)successBlock failedBlock:(NetworkRequestFailed)failedBlock{
    [HGBNetWorkTool shareInstance];


    //参数转换
    NSData *fileData = UIImageJPEGRepresentation(image,0);
    UIImage *fileImage=image;
    while ((fileData.length / 1024) > 1000) {
        fileImage = [HGBNetWorkTool scaleImage:fileImage toScale:0.5];
        fileData = UIImageJPEGRepresentation(fileImage, 1);
    }


    HGBNetworkRequest *request = [[HGBNetworkRequest alloc]init];
    //请求链接
    request.requestUrl = url;

    //请求配置
    request.requestMethod = @"POST";

    request.quickContentType=CONTENTTYPE_FILEDATA;

    //请求参数
    request.updateName=@"uploadFile";
    request.fileData=fileData;
    request.fileName=fileName;
    if((!fileData)||fileName.length==0||fileName==nil){
        failedBlock(nil);
        return;
    }

    //请求
    [request requestWithSuccessBlock:^(id responseObject) {
        successBlock(responseObject);
        
    } failedBlock:^(NSError *error) {
        failedBlock(error);
        
    }];
}
/**
 *  下载文件
 *
 *  @param url          图片下载地址
 *  @param SuccessBlock 成功返回
 *  @param failedBlock  失败返回
 */
- (void)downloadFileWithUrl:(NSString *)url SuccessBlock:(void (^)(NSString *filePath))SuccessBlock failedBlock:(NetworkRequestFailed)failedBlock{
    [HGBNetWorkTool shareInstance];

    
    HGBNetworkRequest *request = [[HGBNetworkRequest alloc]init];

    //请求链接
    request.requestUrl = [url stringByAppendingFormat:@"?time=%@",[HGBNetWorkTool getTimeStr]];
    //请求配置
    request.requestMethod = @"GET";

    //请求
    [request requestWithSuccessBlock:^(id responseObject) {
        SuccessBlock(responseObject);
    } failedBlock:^(NSError *error) {
        failedBlock(error);
        
    }];
}
#pragma mark 工具类
/**
 图片压缩

 @param image image
 @param scaleSize 比例
 @return 图片
 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
/**
 获取时间搓

 @return 时间搓
 */
+ (NSString *)getTimeStr
{
    NSDate* dat = [NSDate date];
    NSTimeInterval a=[dat timeIntervalSince1970];  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
    NSString *timeStr = [NSString stringWithFormat:@"%lf",[timeString doubleValue]*1000000];
    
    return [timeStr substringToIndex:16];
}

@end
