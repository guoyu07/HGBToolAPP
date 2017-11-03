//
//  HGBSystemContactTool.m
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBSystemContactTool.h"
#import <MessageUI/MessageUI.h>
#import <Messages/Messages.h>
#import <UIKit/UIKit.h>

#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"




#ifndef SYSTEM_VERSION
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
#endif

#ifndef KiOS6Later
#define KiOS6Later (SYSTEM_VERSION >= 6)
#endif

#ifndef KiOS7Later
#define KiOS7Later (SYSTEM_VERSION >= 7)
#endif

#ifndef KiOS8Later
#define KiOS8Later (SYSTEM_VERSION >= 8)
#endif

#ifndef KiOS9Later
#define KiOS9Later (SYSTEM_VERSION >= 9)
#endif

#ifndef KiOS10Later
#define KiOS10Later (SYSTEM_VERSION >= 10)
#endif



@interface HGBSystemContactTool()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
/**
 信息
 */
@property(assign,nonatomic)HGBSystemContactReslutBlock messageBlock;
/**
 邮件
 */
@property(assign,nonatomic)HGBSystemContactReslutBlock emailBlock;
@end
@implementation HGBSystemContactTool

static HGBSystemContactTool *instance=nil;
#pragma mark init 
+(instancetype)shareInstance{
    if(instance==nil){
        instance=[[HGBSystemContactTool alloc]init];
    }
    return instance;
}
#pragma mark 打电话
/**
 打电话
 
 @param phoneNum 电话号码
 */
+(BOOL)callPhone:(NSString *)phoneNum{
    phoneNum=[HGBSystemContactTool deleteSpace:phoneNum];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    if([[UIApplication sharedApplication] canOpenURL:url]){
#ifdef KiOS10Later
        static BOOL sucessFlag=YES;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            sucessFlag=success;
            //发出已完成的信号
            dispatch_semaphore_signal(semaphore);
        }];


        //等待执行，不会占用资源
        dispatch_semaphore_wait(semaphore, 20);
        return sucessFlag;
#else
        return [[UIApplication sharedApplication]openURL:url];
#endif
    }else{
        return NO;
    }
    
}
#pragma mark 发短信
/**
 发送短信
 
 @param messgage 信息
 @param recivePhoneNums 接收人
 @param reslutBlock 返回
 @param parent 父控制器
 */
+(BOOL)sendMessage:(NSString *)messgage WithRecivePhoneNums:(NSArray<NSString *> *)recivePhoneNums withReslutBlock:(HGBSystemContactReslutBlock)reslutBlock inParent:(UIViewController *)parent{
    [HGBSystemContactTool shareInstance];
    if(recivePhoneNums==nil&&recivePhoneNums.count==0){
        return NO;
    }
    
    MFMessageComposeViewController *msgCVC=[[MFMessageComposeViewController alloc]init];
    
    //3:创建接受者
    msgCVC.recipients=recivePhoneNums;
    //4:设置发送消息的内容
    msgCVC.body=messgage;
    //5:设置代理(当取消发送，发送完成，发送失败的时候调用代理的方法)
    msgCVC.messageComposeDelegate=instance;
    //6:切换至发送界面
    [parent presentViewController:msgCVC animated:YES completion:nil];
    instance.messageBlock=reslutBlock;
    return YES;
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSString *prompt;
    BOOL flag=NO;
    switch(result){
        case MessageComposeResultCancelled:
            prompt=@"发送取消了";
            flag=NO;
            break;
        case MessageComposeResultSent:
            prompt=@"发送成功";
            flag=YES;
            NSLog(@"发送成功");
            break;
        case MessageComposeResultFailed:
            prompt=@"发送失败";
            flag=NO;
            break;
        default:
            prompt=@"发送失败";
            flag=NO;
        break;}
    self.messageBlock(flag, @{ReslutCode:@(result),ReslutMessage:prompt});
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 发邮件
/**
 发动邮件
 
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
+(BOOL)sendEmailToRecives:(NSArray<NSString *>*)recives andWithCopyRecives:(NSArray<NSString *> *)copyRecives andWithSecretCopyRecives:(NSArray<NSString *> *)secretCopyRecives andWithSubject:(NSString *)subject andWithBody:(NSString *)body andWithFileData:(NSData *)fileData andWithFileType:(NSString *)fileType andWithFileName:(NSString *)fileName  withReslutBlock:(HGBSystemContactReslutBlock)reslutBlock inParent:(UIViewController *)parent
{
    [HGBSystemContactTool shareInstance];
    if(recives==nil&&recives.count==0){
        return NO;
    }
    if(subject==nil||subject.length==0){
        return NO;
    }
    
    //2.创建控制器对象
    MFMailComposeViewController *mailC=[[MFMailComposeViewController alloc]init];
    if (!mailC) {
        // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
        return NO;
    }
    //3.设置接收者
    [mailC setToRecipients:recives];
    //4.主题
    [mailC setSubject:subject];
    if(copyRecives&&copyRecives.count!=0){
        //5.设置抄送
        [mailC setCcRecipients:copyRecives];
    }
    if(secretCopyRecives&&secretCopyRecives.count!=0){
        //6.设置秘密抄送
        [mailC setBccRecipients:secretCopyRecives];
    }
    if(body&&body.length!=0){
        //7.设置内容
        [mailC setMessageBody:body isHTML:NO];
    }
    //8.设置附件
    if(fileData&&fileType&&fileType.length!=0&&fileName&&fileName.length!=0){
        [mailC addAttachmentData:fileData mimeType:fileType fileName:fileName];
    }
    
    //9.设置代理
    mailC.mailComposeDelegate=instance;
    //10.切换到发送邮件控制器
    [parent presentViewController:mailC animated:YES completion:nil];
    instance.emailBlock=reslutBlock;
    return YES;
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *prompt;
    BOOL flag=NO;
    switch (result) {
        case  MFMailComposeResultCancelled:
            prompt=@"发送取消了";
            flag=NO;
            break;
        case  MFMailComposeResultSaved:
            prompt=@"邮件已保存到草稿箱";
            flag=NO;
            break;
        case  MFMailComposeResultSent:
            prompt=@"发送成功";
            flag=YES;
            break;
        case  MFMailComposeResultFailed:
            prompt=@"发送失败";
            flag=NO;
            
            break;
            
        default:
            prompt=@"发送失败";
            flag=NO;
            break;
    }
    self.emailBlock(flag,@{ReslutCode:@(result),ReslutMessage:prompt});
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark 其他
+(NSString *)deleteSpace:(NSString *)string
{
    if(string==nil){
        return nil;
    }
    while ([string containsString:@" "]){
        string=[string stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return string;
}
@end
