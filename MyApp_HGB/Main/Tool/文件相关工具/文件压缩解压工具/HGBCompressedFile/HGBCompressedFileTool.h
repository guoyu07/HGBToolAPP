//
//  HGBCompressedFileTool.h
//  HelloCordova
//
//  Created by huangguangbao on 2017/7/11.
//
//

#import <Foundation/Foundation.h>

/**
 错误类型
 */
typedef enum HGBCompressedFileToolReslut
{
    HGBCompressedFileToolReslutSucess,//成功
    HGBCompressedFileToolErrorTypePath,//路径错误
    HGBCompressedFileToolErrorCompress//解压或压缩错误

}HGBCompressedFileToolReslut;

typedef void(^HGBCompressedCompleteBlock)(BOOL status,NSDictionary *messageInfo);

@interface HGBCompressedFileTool : NSObject
/**
 解压
 @param filePath 文件路径
 @param password 密码
 @param destPath 目标地址
 @param completeBlock 结果
*/
+(void)unArchive: (NSString *)filePath andPassword:(NSString*)password toDestinationPath:(NSString *)destPath andWithCompleteBlock:(HGBCompressedCompleteBlock)completeBlock;
/**
  压缩
  @param filePaths 文件路径集合
  @param destPath 目标地址 
  @param completeBlock 结果
*/
+(void)archiveToZipWithFilePaths: (NSArray *)filePaths toDestinationPath:(NSString *)destPath andWithCompleteBlock:(HGBCompressedCompleteBlock)completeBlock;
@end
