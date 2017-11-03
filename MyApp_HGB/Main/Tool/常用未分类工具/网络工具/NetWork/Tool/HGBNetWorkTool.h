//
//  HGBNetWorkTool.h
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGBNetworkRequestHeader.h"



@interface HGBNetWorkTool : NSObject
#pragma mark 设置
/**
 设置请求报文格式

 @param sendFormat 报文格式
 */
+(void)setNetWorkDataSendFormat:(DATA_SEND_FORMAT)sendFormat;
/**
 快捷设置报文请求头ContentType数据格式

 @param quickContentType ContentType
 */
+(void)setNetWorkDataQuickContentType:(DATA_SEND_CONTENTTYPE)quickContentType;

/**
 设置请求头

 @param headers 请求头
 */
+(void)setNetWorkHeaders:(NSDictionary *)headers;
/**
 设置http请求

 @param isSaveCookie 是否保存Cookie
 */
+(void)setIsSaveCookie:(BOOL)isSaveCookie;
/**
 设置http请求

 @param isHttps 是否是https
 */
+(void)setIsHttps:(BOOL)isHttps;
/**
 *	@brief	双向认证设置证书.
 *  证书为P12.
 *
 *	@param 	cerFilePath 	证书路径.
 *  @param  cerPassword     证书密码.
 */
+(void)setHttpsCertificateFilePath:(NSString *)cerFilePath cerPassword:(NSString *)cerPassword;
#pragma mark 服务
/**
 *  GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数-字典或字符串格式
 *  @param successBlock 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failedBlock 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)get:(NSString *)url params:(id)params andWithSuccessBlock:(NetworkRequestSuccess)successBlock failedBlock:(NetworkRequestFailed)failedBlock;
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数-字典或字符串格式
 *  @param successBlock 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failedBlock 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)post:(NSString *)url params:(id)params andWithSuccessBlock:(NetworkRequestSuccess)successBlock failedBlock:(NetworkRequestFailed)failedBlock;

/**
 *  文件上传请求
 *
 *  @param url     请求路径
 *  @param fileData  文件数据
 *  @param fileName  文件名
 *  @param successBlock 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failedBlock 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+(void)uploadFileWithUrl:(NSString *)url WithData:(NSData *)fileData fileName:(NSString *)fileName andWithSuccessBlock:(NetworkRequestSuccess)successBlock failedBlock:(NetworkRequestFailed)failedBlock;

/**
 *  图片上传请求
 *
 *  @param url     请求路径
 *  @param image   图片
 *  @param fileName  文件名
 *  @param successBlock 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failedBlock 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+(void)uploadImageWithUrl:(NSString *)url WithImage:(UIImage *)image fileName:(NSString *)fileName andWithSuccessBlock:(NetworkRequestSuccess)successBlock failedBlock:(NetworkRequestFailed)failedBlock;
/**
 *  下载文件
 *
 *  @param url          图片下载地址
 *  @param SuccessBlock 成功返回
 *  @param failedBlock  失败返回
 */
- (void)downloadFileWithUrl:(NSString *)url SuccessBlock:(void (^)(NSString *filePath))SuccessBlock failedBlock:(NetworkRequestFailed)failedBlock;
@end
