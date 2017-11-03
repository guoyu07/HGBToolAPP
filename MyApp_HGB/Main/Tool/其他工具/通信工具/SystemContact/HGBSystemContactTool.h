//
//  HGBSystemContactTool.h
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


typedef void (^HGBSystemContactReslutBlock)(BOOL status,NSDictionary *returnMessage);


@interface HGBSystemContactTool : NSObject
/**
 打电话

 @param phoneNum 电话号码
 */
+(BOOL)callPhone:(NSString *)phoneNum;

/**
 发送短信

 @param messgage 信息
 @param recivePhoneNums 接收人
 @param reslutBlock 返回
 @param parent 父控制器
 */
+(BOOL)sendMessage:(NSString *)messgage WithRecivePhoneNums:(NSArray<NSString *> *)recivePhoneNums withReslutBlock:(HGBSystemContactReslutBlock)reslutBlock inParent:(UIViewController *)parent;


/**
 发送邮件

 @param recives 收件人
 @param copyRecives 抄送人
 @param secretCopyRecives 秘密抄送人
 @param subject 邮件主题
 @param body 邮件内容
 @param fileData 附件
 @param fileType 附件类型
 @param fileName 附件名
 @param reslutBlock 返回
 @param parent 父控制器
 @return 结果
 */
+(BOOL)sendEmailToRecives:(NSArray<NSString *>*)recives andWithCopyRecives:(NSArray<NSString *> *)copyRecives andWithSecretCopyRecives:(NSArray<NSString *> *)secretCopyRecives andWithSubject:(NSString *)subject andWithBody:(NSString *)body andWithFileData:(NSData *)fileData andWithFileType:(NSString *)fileType andWithFileName:(NSString *)fileName  withReslutBlock:(HGBSystemContactReslutBlock)reslutBlock inParent:(UIViewController *)parent;

@end
