//
//  HGBNetworkRequestHeader.h
//  HelloCordova
//
//  Created by huangguangbao on 2017/8/24.
//
//

#ifndef HGBNetworkRequestHeader_h
#define HGBNetworkRequestHeader_h

/**
 *	报文格式
 */
typedef enum
{
    DATA_SEND_FORMAT_NO,
    DATA_SEND_FORMAT_JSON,        //!< json格式报文 /
    DATA_SEND_FORMAT_XML,         //!< xml格式报文 */

}DATA_SEND_FORMAT;

/**
 *	报文ContentType数据格式快捷设置
 */
typedef enum
{
    CONTENTTYPE_NO,
    CONTENTTYPE_FORMAT,
    CONTENTTYPE_RAW,
    CONTENTTYPE_BINARY,
    CONTENTTYPE_X_W_FORMUNENCODE,
    CONTENTTYPE_FILEDATA,

}DATA_SEND_CONTENTTYPE;

/**
 *	@brief	请求成功时调用block.
 *
 *	@param 	responseObject 	请求成功后生成的数据对象.
 */
typedef void (^NetworkRequestSuccess)(id responseObject);

/**
 *	@brief	请求失败时调用的block.
 */
typedef void (^NetworkRequestFailed)(NSError *error);
#endif /* HGBNetworkRequestHeader_h */
