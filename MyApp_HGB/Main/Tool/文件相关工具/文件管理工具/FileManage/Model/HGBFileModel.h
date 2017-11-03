//
//  HGBFileModel.h
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 文件类型
 */
typedef enum HGBFileType
{
    HGBFileTypeUnknown,//未知
    HGBFileTypeDirectory,//文件夹
    HGBFileTypeText,//文本文件
    HGBFileTypeWord,//word文件
    HGBFileTypeExcel,//Excel文件
    HGBFileTypePowerPoint,//ppt文件
    HGBFileTypePDF,//PDF文件
    HGBFileTypeImage,//图片文件
    HGBFileTypeAudio,//音频文件
    HGBFileTypeVideo,//视频文件
    HGBFileTypeCompress,//压缩文件
    HGBFileTypeBundle,//资源文件
    HGBFileTypeNull//非文件
}HGBFileType;

/**
 文件类型
 */
typedef enum HGBFilePathType
{
    HGBFilePathTypeSandBox,//沙盒
    HGBFilePathTypeBundle,//app资源文件夹
    HGBFilePathTypeOther//其他文件夹

}HGBFilePathType;

@interface HGBFileModel : NSObject
/**
 文件名
 */
@property(strong,nonatomic)NSString *fileName;
/**
 文件大小
 */
@property(strong,nonatomic)NSString *fileSize;
/**
 文件简介
 */
@property(strong,nonatomic)NSString *fileAbout;
/**
 文件图片
 */
@property(strong,nonatomic)NSString *fileIcon;
/**
 文件路径
 */
@property(strong,nonatomic)NSString *filePath;
/**
 文件类型
 */
@property(assign,nonatomic)HGBFileType fileType;
/**
 是否可以编辑
 */
@property(assign,nonatomic)BOOL isEdit;
/**
 文件地址类型
 */
@property(assign,nonatomic)HGBFilePathType filePathType;
@end
