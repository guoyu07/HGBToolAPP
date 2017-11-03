//
//  HGBAlertTool.m
//  测试
//
//  Created by huangguangbao on 2017/8/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBAlertTool.h"

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

@interface HGBAlertTool()<UIAlertViewDelegate,UIActionSheetDelegate>
@property(strong,nonatomic)HGBAlertClickBlock clickBlock;
/**
 标题文字大小
 */
@property(assign,nonatomic)CGFloat titleFontSize;
/**
 标题文字大小改变标志
 */
@property(assign,nonatomic)BOOL titleFontFlag;
/**
 标题颜色
 */
@property(strong,nonatomic)UIColor *titleColor;

/**
 副标题文字大小
 */
@property(assign,nonatomic)CGFloat subTitleFontSize;
/**
 副标题文字大小改变标志
 */
@property(assign,nonatomic)BOOL subTitleFontFlag;
/**
 按钮标题颜色
 */
@property(strong,nonatomic)UIColor *subTitleColor;
/**
 按钮标题文字大小
 */
@property(assign,nonatomic)CGFloat buttonTitleFontSize;
/**
 按钮标题文字大小改变标志
 */
@property(assign,nonatomic)BOOL buttonTitleFontFlag;
/**
 按钮标题颜色
 */
@property(strong,nonatomic)UIColor *buttonTitleColor;
@end

@implementation HGBAlertTool
#pragma mark init
static HGBAlertTool *instance=nil;
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBAlertTool alloc]init];
    }
    return instance;
}
#pragma mark 设置
/**
 配置标题颜色

 @param titleColor 标题颜色
 */
+(void)setTitleColor:(UIColor *)titleColor{
    [HGBAlertTool shareInstance];
    instance.titleColor=titleColor;
}
/**
 配置标题字体大小

 @param titleFontSize 标题字体大小
 */
+(void)setTitleFontSize:(CGFloat)titleFontSize{
     [HGBAlertTool shareInstance];
    instance.titleFontSize=titleFontSize;

    if(titleFontSize!=0){
        instance.titleFontFlag=YES;
    }else{
        instance.titleFontFlag=NO;
    }
}

/**
 配置副标题颜色

 @param subTitleColor 副标题颜色
 */
+(void)setSubTitleColor:(UIColor *)subTitleColor{
     [HGBAlertTool shareInstance];
    instance.subTitleColor=subTitleColor;
    
    

}
/**
 配置副标题字体大小

 @param subTitleFontSize 副标题字体大小
 */
+(void)setSubTitleFontSize:(CGFloat)subTitleFontSize{
     [HGBAlertTool shareInstance];
    instance.subTitleFontSize=subTitleFontSize;
    if(subTitleFontSize!=0){
        instance.subTitleFontFlag=YES;
    }else{
        instance.subTitleFontFlag=NO;
    }
}
/**
 配置按钮标题颜色

 @param buttonTitleColor 按钮标题颜色
 */
+(void)setButtonTitleColor:(UIColor *)buttonTitleColor{
     [HGBAlertTool shareInstance];
    instance.buttonTitleColor=buttonTitleColor;
}
/**
 配置按钮标题字体大小

 @param buttonTitleFontSize 按钮标题字体大小
 */
+(void)setButtonTitleFontSize:(CGFloat)buttonTitleFontSize{
     [HGBAlertTool shareInstance];
    instance.buttonTitleFontSize=buttonTitleFontSize;
    if(buttonTitleFontSize!=0){
        instance.buttonTitleFontFlag=YES;
    }else{
        instance.buttonTitleFontFlag=NO;
    }
}
#pragma mark 统一配置

/**
 alertController统一配置

 @param alertController alertController
 */
+(void)setAlertControllerSettings:(UIAlertController *)alertController{
    [HGBAlertTool shareInstance];
    if(!alertController){
        return;
    }
    if(instance.titleColor||instance.titleFontFlag){
        //改变title的大小和颜色
        NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:alertController.title];

        if(instance.titleFontFlag){
            [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:instance.titleFontSize] range:NSMakeRange(0,alertController.title.length)];
        }
        if(instance.titleColor){
            [titleAtt addAttribute:NSForegroundColorAttributeName value:instance.titleColor range:NSMakeRange(0, alertController.title.length)];

        }
        [alertController setValue:titleAtt forKey:@"attributedTitle"];
    }
    if(instance.subTitleFontFlag||instance.subTitleColor){
        NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:alertController.message];
        //改变message的大小和颜色
        if(instance.subTitleFontFlag){
            [messageAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:instance.subTitleFontSize] range:NSMakeRange(0,alertController.message.length)];
        }
        if(instance.subTitleColor){
            [messageAtt addAttribute:NSForegroundColorAttributeName value:instance.subTitleColor range:NSMakeRange(0, alertController.message.length)];
        }
        [alertController setValue:messageAtt forKey:@"attributedMessage"];

    }
    if(instance.buttonTitleColor){
        alertController.view.tintColor=instance.buttonTitleColor;
    }

}
/**
 alertView统一配置

 @param alertView alertView
 */
+(void)setAlertViewSettings:(UIAlertView *)alertView{

    [HGBAlertTool shareInstance];
    if(!alertView){
        return;
    }
    if(instance.titleColor||instance.titleFontFlag){
        //改变title的大小和颜色
        NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:alertView.title];
        UILabel *titleLabel = [alertView valueForKey:@"_titleLabel"];


        if(instance.titleFontFlag){
            titleLabel.font = [UIFont fontWithName:@"Arial" size:instance.titleFontSize];
            [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:instance.titleFontSize] range:NSMakeRange(0,alertView.title.length)];
        }
        if(instance.titleColor){
            [titleAtt addAttribute:NSForegroundColorAttributeName value:instance.titleColor range:NSMakeRange(0, alertView.title.length)];
            [titleLabel setTextColor:instance.titleColor];

        }
        @try {
            [alertView setValue:titleAtt forKey:@"attributedTitle"];
        } @catch (NSException *exception) {

        } @finally {
        }



    }
    if(instance.subTitleFontFlag||instance.subTitleColor){
        NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:alertView.message];
        UILabel *body = [alertView valueForKey:@"_bodyTextLabel"];

        //改变message的大小和颜色
        if(instance.subTitleFontFlag){
            body.font = [UIFont fontWithName:@"Arial" size:instance.subTitleFontSize];

            [messageAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:instance.subTitleFontSize] range:NSMakeRange(0,alertView.message.length)];
        }
        if(instance.subTitleColor){
            [messageAtt addAttribute:NSForegroundColorAttributeName value:instance.subTitleColor range:NSMakeRange(0, alertView.message.length)];
            [body setTextColor:instance.subTitleColor];
        }
        @try {
           [alertView setValue:messageAtt forKey:@"attributedMessage"];
        } @catch (NSException *exception) {

        } @finally {
        }


    }




    if(instance.buttonTitleColor){
        [[UIView appearanceWhenContainedIn:[UIAlertView class], nil] setTintColor:[UIColor redColor]];
    }

}
/**
 actionSheet统一配置

 @param actionSheet actionSheet
 */
+(void)setActionSheetSettings:(UIActionSheet *)actionSheet{
    [HGBAlertTool shareInstance];
    if(!actionSheet){
        return;
    }
    if(instance.titleColor||instance.titleFontFlag){
        //改变title的大小和颜色
        NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:actionSheet.title];
        UILabel *titleLabel = [actionSheet valueForKey:@"_titleLabel"];
       
        if(instance.titleFontFlag){
            [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:instance.titleFontSize] range:NSMakeRange(0,actionSheet.title.length)];
            titleLabel.font = [UIFont fontWithName:@"Arial" size:instance.titleFontSize];

        }
        if(instance.titleColor){
            [titleAtt addAttribute:NSForegroundColorAttributeName value:instance.titleColor range:NSMakeRange(0, actionSheet.title.length)];
            [titleLabel setTextColor:instance.titleColor];

        }
        @try {
            [actionSheet setValue:titleAtt forKey:@"attributedTitle"];
        } @catch (NSException *exception) {

        } @finally {
        }
    }
    if(instance.buttonTitleColor){
        actionSheet.tintColor=instance.buttonTitleColor;
    }

}
#pragma mark alert单键
/**
 *  单键-提示
 *
 *  @param prompt     提示详情
 *
 *  @param parent 父控件
 */

+(void)alertWithPrompt:(NSString *)prompt InParent:(UIViewController *)parent{
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [HGBAlertTool setAlertControllerSettings:alert];
    [parent presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:prompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [HGBAlertTool setAlertViewSettings:alertview];
    [alertview show];

#endif
}


/**
 *  单键－带标题提示
 *
 *  @param title    提示标题
 *  @param prompt     提示详情
 *
 *  @param parent 父控件
 */
+(void)alertPromptWithTitle:(NSString *)title andWithPrompt:(NSString *)prompt  InParent:(UIViewController *)parent
{
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action1];
    [HGBAlertTool setAlertControllerSettings:alert];
    [parent presentViewController:alert animated:YES completion:nil];

#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:prompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [HGBAlertTool setAlertViewSettings:alertview];
    [alertview show];
#endif
}
/**
 *  单键－带标题提示-点击事件
 *
 *  @param title    提示标题
 *  @param prompt     提示详情
 *
 *  @param clickBlock 点击事件
 *  @param parent 父控件
 */
+(void)alertWithTitle:(NSString *)title andWithPrompt:(NSString *)prompt andWithClickBlock:(HGBAlertClickBlock)clickBlock InParent:(UIViewController *)parent
{
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        clickBlock(0);
    }];
    [alert addAction:action1];
    [HGBAlertTool setAlertControllerSettings:alert];
    [parent presentViewController:alert animated:YES completion:nil];

#else
    instance.clickBlock=clickBlock;
    [HGBAlertTool shareInstance];
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:prompt delegate:instance cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [HGBAlertTool setAlertViewSettings:alertview];
    [alertview show];

#endif




}
/**
 *  单键-带标题提示-点击按钮功能及标题
 *
 *  @param title    提示标题
 *  @param prompt     提示详情
 *  @param confirmButtonTitle  按钮标题
 *  @param clickBlock 点击事件
 *  @param parent 父控件
 */
+(void)alertWithTitle:(NSString *)title andWithPrompt:(NSString *)prompt  andWithConfirmButtonTitle:(NSString *)confirmButtonTitle andWithClickBlock:(HGBAlertClickBlock)clickBlock InParent:(UIViewController *)parent{
    if(confirmButtonTitle==nil&&confirmButtonTitle.length==0){
        confirmButtonTitle=@"确定";
    }
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:confirmButtonTitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        clickBlock(0);
    }];
    [alert addAction:action1];
    [HGBAlertTool setAlertControllerSettings:alert];
    [parent presentViewController:alert animated:YES completion:nil];
#else
    instance.clickBlock=clickBlock;
    [HGBAlertTool shareInstance];
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:prompt delegate:instance cancelButtonTitle:confirmButtonTitle otherButtonTitles:nil];
    [HGBAlertTool setAlertViewSettings:alertview];
    [alertview show];

#endif
}
#pragma mark alert双键
/**
 *  双键-功能－标题提示
 *
 *  @param title    提示标题
 *  @param prompt     提示详情
 *  @param confirmButtonTitle  确认按钮名称
 *  @param cancelButtonTitle   取消按钮名称
 *
 *  @param clickBlock 点击事件
 *  @param parent 父控件
 */
+(void)alertWithTitle:(NSString *)title andWithPrompt:(NSString *)prompt andWithConfirmButtonTitle:(NSString *)confirmButtonTitle andWithCancelButtonTitle:(NSString *)cancelButtonTitle  andWithClickBlock:(HGBAlertClickBlock)clickBlock InParent:(UIViewController *)parent
{
    if(confirmButtonTitle==nil&&confirmButtonTitle.length==0){
        confirmButtonTitle=@"确定";
    }
    if(cancelButtonTitle==nil&&cancelButtonTitle.length==0){
         cancelButtonTitle=@"取消";
    }
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:confirmButtonTitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        clickBlock(0);
    }];
    [alert addAction:action1];
    UIAlertAction *action2=[UIAlertAction actionWithTitle:cancelButtonTitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        clickBlock(1);
    }];
    [alert addAction:action2];
    [HGBAlertTool setAlertControllerSettings:alert];
    [parent presentViewController:alert animated:YES completion:nil];
#else
    [HGBAlertTool shareInstance];
    instance.clickBlock =clickBlock;
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:prompt delegate:instance cancelButtonTitle:confirmButtonTitle otherButtonTitles:cancelButtonTitle,nil];
    [HGBAlertTool setAlertViewSettings:alertview];
    [alertview show];

#endif

}
#pragma mark alert多键
/**
 *   多键-功能－标题提示
 *
 *  @param title    提示标题
 *  @param prompt     提示详情
 *  @param buttonTitles  按钮名称集合
 *
 *  @param clickBlock 点击事件
 *  @param parent 父控件
 */
+(void)alertWithTitle:(NSString *)title andWithPrompt:(NSString *)prompt andWithButtonTitles:(NSArray<NSString *>*)buttonTitles andWithClickBlock:(HGBAlertClickBlock)clickBlock InParent:(UIViewController *)parent{
    if(buttonTitles==nil&&buttonTitles.count==0){
        buttonTitles=@[@"确定"];
    }


#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:prompt preferredStyle:(UIAlertControllerStyleAlert)];

    for(int i=0;i<buttonTitles.count;i++){
        NSString *buttonTitle=buttonTitles[i];
        UIAlertAction *action=[UIAlertAction actionWithTitle:buttonTitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            clickBlock(i);
        }];
        [alert addAction:action];
    }
    [HGBAlertTool setAlertControllerSettings:alert];
    [parent presentViewController:alert animated:YES completion:nil];
#else
    [HGBAlertTool shareInstance];
    instance.clickBlock =clickBlock;
    NSMutableArray *btnTitles=[NSMutableArray array];
    if(buttonTitles.count>1){
        btnTitles=[NSMutableArray arrayWithArray:buttonTitles];
        [btnTitles removeObjectAtIndex:0];
    }
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:prompt delegate:instance cancelButtonTitle:buttonTitles[0] otherButtonTitles:nil];
    [btnTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertview addButtonWithTitle:obj];
    }];
    [HGBAlertTool setAlertViewSettings:alertview];
    [alertview show];

#endif
}
#pragma mark sheet
/**
 *  sheet-功能
 *
 *  @param buttonTitles  按钮名称集合
 *
 *  @param clickBlock 点击事件
 *  @param parent 父控件
 */
+(void)sheetWithButtonTitles:(NSArray<NSString *>*)buttonTitles andWithClickBlock:(HGBAlertClickBlock)clickBlock InParent:(UIViewController *)parent{
    if(buttonTitles==nil&&buttonTitles.count==0){
        buttonTitles=@[@"取消"];
    }


#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];

    for(int i=0;i<buttonTitles.count;i++){
        NSString *buttonTitle=buttonTitles[i];
        UIAlertAction *action=[UIAlertAction actionWithTitle:buttonTitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            clickBlock(i);
        }];
        [alert addAction:action];
    }
    [HGBAlertTool setAlertControllerSettings:alert];
    [parent presentViewController:alert animated:YES completion:nil];
#else
    [HGBAlertTool shareInstance];
    instance.clickBlock =clickBlock;
    NSMutableArray *btnTitles=[NSMutableArray array];
    if(buttonTitles.count>1){
        btnTitles=[NSMutableArray arrayWithArray:buttonTitles];
        [btnTitles removeObjectAtIndex:0];
    }

    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:instance cancelButtonTitle:buttonTitles[0] destructiveButtonTitle:nil otherButtonTitles:nil];
    [btnTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [actionSheet addButtonWithTitle:obj];
    }];
    [HGBAlertTool setActionSheetSettings:actionSheet];
    [actionSheet showInView:parent.view];

#endif
}
/**
 *  sheet-功能－标题提示
 *
 *  @param title    提示标题
 *  @param prompt     提示详情
 *  @param buttonTitles  按钮名称集合
 *
 *  @param clickBlock 点击事件
 *  @param parent 父控件
 */
+(void)sheetWithTitle:(NSString *)title andWithPrompt:(NSString *)prompt andWithButtonTitles:(NSArray<NSString *>*)buttonTitles andWithClickBlock:(HGBAlertClickBlock)clickBlock InParent:(UIViewController *)parent{
    if(buttonTitles==nil&&buttonTitles.count==0){
        buttonTitles=@[@"取消"];
    }


#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:prompt preferredStyle:(UIAlertControllerStyleActionSheet)];

    for(int i=0;i<buttonTitles.count;i++){
        NSString *buttonTitle=buttonTitles[i];
        UIAlertAction *action=[UIAlertAction actionWithTitle:buttonTitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            clickBlock(i);
        }];
        [alert addAction:action];
    }
    [HGBAlertTool setAlertControllerSettings:alert];
    [parent presentViewController:alert animated:YES completion:nil];
#else
    [HGBAlertTool shareInstance];
    instance.clickBlock =clickBlock;
    NSMutableArray *btnTitles=[NSMutableArray array];
    if(buttonTitles.count>1){
        btnTitles=[NSMutableArray arrayWithArray:buttonTitles];
        [btnTitles removeObjectAtIndex:0];
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:instance cancelButtonTitle:buttonTitles[0] destructiveButtonTitle:nil otherButtonTitles:nil];
    [btnTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [actionSheet addButtonWithTitle:obj];
    }];
    [HGBAlertTool setActionSheetSettings:actionSheet];
    [actionSheet showInView:parent.view];

#endif
}
#pragma mark delegate
#ifdef KiOS8Later

#else
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(instance.clickBlock){
        instance.clickBlock(buttonIndex);
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(instance.clickBlock){
        instance.clickBlock(buttonIndex);
    }
}
#endif

@end
