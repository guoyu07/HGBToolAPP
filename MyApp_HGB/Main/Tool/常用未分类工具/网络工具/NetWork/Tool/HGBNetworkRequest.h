//
//  HGBNetworkRequest.h
//  网络框架
//
//  Created by huangguangbao on 2017/6/8.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBNetworkRequestHeader.h"

/**
 网络请求基类
 */
@interface HGBNetworkRequest : NSObject
#pragma mark 请求配置
/**
 请求链接
 */
@property (nonatomic, copy) NSString      *requestUrl;

/**
 *  请求方法 默认Post Get
 */
@property (nonatomic , assign)NSString *requestMethod;


/**
 *	@brief	数据报文格式(默认FORMAT_NO).
 */
@property (nonatomic, assign) DATA_SEND_FORMAT  sendFormat;
/**
 *  快捷设置报文请求头ContentType数据格式
 */
@property (nonatomic , assign)DATA_SEND_CONTENTTYPE quickContentType;

/**
 *  请求头设置
 */
@property (nonatomic,strong)NSMutableDictionary *headParms;

/**
 请求体设置
 */
@property (nonatomic,strong)NSString *bodyParams;


/**
 *	@brief	是否保存Cookie
 */
@property (nonatomic,assign) BOOL isSaveCookie;


#pragma mark 文件上传参数设置
/**
 *  文件上传数据
 */
@property (nonatomic,strong)NSData *fileData;
/**
 *  上传文件名
 */
@property (nonatomic,strong)NSString *fileName;

/**
 *  上传服务名
 */
@property (nonatomic,strong)NSString *updateName;

/**
 上传文件类型
 */
@property(strong,nonatomic)NSString *mineType;

#pragma mark 一般网络请求参数设置
/**
 参数
 */
@property (nonatomic,strong)NSDictionary *pramDic;


/**
 *	@brief	添加请求body标准(":")格式参数.
 *
 *	@param 	parma 	参数名.
 *	@param 	value 	参数数据值.
 */
- (void)appendFormatBodyParma:(NSString *)parma value:(id)value;

/**
 *	@brief	添加请求body"="格式参数.
 *
 *	@param 	parma 	参数名.
 *	@param 	value 	参数数据值.
 */
- (void)appendEqualBodyParma:(NSString *)parma value:(id)value;
/**
 *	@brief	添加请求body自定义格式参数.
 *
 *	@param 	parma 	参数字符串
 */
- (void)appendBodyParma:(id)parma;

#pragma mark 通用方法设置


/**
 *	@brief	双向认证设置证书.
 *  证书为P12.
 *
 *	@param 	cerFilePath 	证书路径.
 *  @param  cerPassword     证书密码.
 */
- (void)setHttpsBidirectionalAuthCertificateFilePath:(NSString *)cerFilePath cerPassword:(NSString *)cerPassword;

#pragma mark - block机制支持
/**
 *	@brief	设置回调block
 *
 *	@param 	successBlock 	成功block
 *	@param 	failedBlock 	失败block
 */
- (void)requestWithSuccessBlock:(NetworkRequestSuccess)successBlock failedBlock:(NetworkRequestFailed)failedBlock;
#pragma mark 工具性方法
/**
 把Json对象转化成json字符串
 
 @param object json对象
 @return json字符串
 */
+ (NSString *)ObjectToJSONString:(id)object;
/**
 *  url空格处理
 *
 *  @param urlStr 原url
 *
 *  @return 新url
 */
+(NSString *)transToUrlFormatString:(NSString *)urlStr;
/**
 字符串编码
 
 @param str 原字符串
 @return 编码后字符串
 */
+ (NSString *)stringEncodingWithStr:(NSString *)str;
@end
