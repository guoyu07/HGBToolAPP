//
//  HGBCustomKeyBord.h
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBCustomKeyBordHeader.h"

@class HGBCustomKeyBord;
/**
 键盘按钮代理
 */
@protocol HGBCustomKeyBordDelegate <NSObject>
@required
-(void)customKeybord:(HGBCustomKeyBord *)keybord didReturnMessage:(NSString *)message;
@end

/**
 加密键盘
 */
@interface HGBCustomKeyBord : UIView

@property(assign,nonatomic)id<HGBCustomKeyBordDelegate>delegate;
/**
 标题
 */
@property(strong,nonatomic)NSString *titleString;
/**
 键盘类型
 */
@property(assign,nonatomic)HGBCustomKeyBordType keybordType;
/**
 键盘显示类型
 */
@property(assign,nonatomic)HGBCustomKeyBordShowType keybordShowType;
/**
 键盘加密类型
 */
@property(assign,nonatomic)HGBCustomKeyBordEncryptType keybordEncryptType;
/**
 键盘加密密钥-为空不加密
 */
@property(strong,nonatomic)NSString *encryptKey;

/*** 如果设置YES,键盘随机排布 **/
/**
 是否随机 default is NO;
 */
@property (nonatomic, assign) BOOL random;
/**
 创建
 */
+(instancetype)instance;
/**
 弹出键盘
 @param parent 父控制器
 */
-(void)popKeyBordInParent:(UIViewController *)parent;
/**
 键盘消失

 @param completeBlock 消失
 */
- (void)disappearSwitchBtnClickWithBlock:(CompleteBlock)completeBlock;

@end
