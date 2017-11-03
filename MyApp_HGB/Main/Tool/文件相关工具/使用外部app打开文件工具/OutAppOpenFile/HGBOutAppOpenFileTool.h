//
//  HGBOutAppOpenFileTool.h
//  HelloCordova
//
//  Created by huangguangbao on 2017/7/19.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



/**
 错误类型
 */
typedef enum HGBOutAppOpenFileToolErrorType
{
    HGBOutAppOpenFileToolErrorTypePath//路径错误

}HGBOutAppOpenFileToolErrorType;

@class HGBOutAppOpenFileTool;

/**
 快速预览
 */
@protocol HGBOutAppOpenFileToolDelegate <NSObject>
@optional
/**
 打开成功

 @param outLook outLook
 */
-(void)outLookDidOpenSucessed:(HGBOutAppOpenFileTool *)outLook;
/**
 打开失败

 @param outLook outLook
 */
-(void)outLook:(HGBOutAppOpenFileTool *)outLook didOpenFailedWithError:(NSDictionary *)errorInfo;
/**
 取消快速预览

 @param outLook outLook
 */
-(void)outLookDidCanceled:(HGBOutAppOpenFileTool *)outLook;
/**
 关闭快速预览

 @param outLook outLook
 */
-(void)outLookDidClose:(HGBOutAppOpenFileTool *)outLook;

@end

@interface HGBOutAppOpenFileTool : NSObject
#pragma mark 设置
/**
 设置代理

 @param delegate 代理
 */
+(void)setQuickLookDelegate:(id<HGBOutAppOpenFileToolDelegate>)delegate;
/**
 设置失败提示

 @param withoutFailPrompt 失败提示标志
 */
+(void)setQuickLookWithoutFailPrompt:(BOOL)withoutFailPrompt;
#pragma mark open
/**
 快速浏览文件

 @param path 路径
 @param parent 父控制器
 */
+(void)lookFileAtPath:(NSString *)path inParent:(UIViewController *)parent;


/**
 快速浏览文件

 @param url 路径
 @param parent 父控制器
 */
+(void)lookFileAtUrl:(NSString *)url inParent:(UIViewController *)parent;
@end

