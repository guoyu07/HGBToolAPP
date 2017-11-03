//
//  NSString+HGBStringCheck.m
//  测试app
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "NSString+HGBStringCheck.h"

@implementation NSString (HGBStringCheck)
/**
 *  手机号验证－宽松
 *
 *
 *  @return 是否是手机号
 */
- (BOOL)isMobileNumber
{
    //手机号码
    NSString *mobel =
    @"^(1[3|4|5|7|8][0-9])\\d{8}$";
    
    NSPredicate *mobelPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobel];
    
    if([mobelPre evaluateWithObject:self] == YES)
    {
        return YES;
    }else
    {
        return NO;
    }
}
/**
 *  手机号验证－严谨
 *
 *  @return 是否是手机号
 */
- (BOOL)isStrictMobileNumber{
    //新增
    NSString *xinMobel = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
    
    //* 普通
    NSString*MOBILE=@"^(\\+86)?1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    //* 移动
    NSString*CM=@"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    //* 联通
    NSString*CU=@"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    //* 电信
    NSString*CT=@"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate*regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    NSPredicate*regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
    NSPredicate*regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
    NSPredicate*regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
    NSPredicate *xinMobelPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",xinMobel];
    
    if(([xinMobelPre evaluateWithObject:self] == YES)
       ||([regextestmobile evaluateWithObject:self] ==YES)
       || ([regextestcm evaluateWithObject:self] ==YES)
       || ([regextestct evaluateWithObject:self] ==YES)
       || ([regextestcu evaluateWithObject:self] ==YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *  身份证验证-宽松
 *
 *
 *  @return 是否正确
 */
-(BOOL)isIDCardNum{
    NSString *idStr=@"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate*regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",idStr];
    if([regextestmobile evaluateWithObject:self]==YES){
        return YES;
    }else{
        return NO;
    }
}
/**
 *  身份证验证-严格
 *
 *  @return 是否正确
 */
-(BOOL)isStritIDCardNum{
    if(self.length!=15){
        if (self.length != 18){
            return NO;
        }
        // 正则表达式判断基本 身份证号是否满足格式
        NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
        NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        //如果通过该验证，说明身份证格式正确，但准确性还需计算
        if(![identityStringPredicate evaluateWithObject:self]) return NO;
        
        //** 开始进行校验 *//
        //将前17位加权因子保存在数组里
        NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++) {
            NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            idCardWiSum+= subStrIndex * idCardWiIndex;
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        //得到最后一位身份证号码
        NSString *idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2) {
            if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
                return NO;
            }
        }
        else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
                return NO;
            }
        }
        return YES;
    }else{
        NSString *idStr=@"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
        NSPredicate*regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",idStr];
        if([regextestmobile evaluateWithObject:self]==YES){
            return YES;
        }else{
            return NO;
        }
    }
}
/**
 *  性别判断
 *
 *  @return 性别
 */
-(BOOL)isAWomanIdCardNum{
    
    if(![self isStritIDCardNum]){
        return NO;
    }
    NSString *idSubStr;
    if(self.length==18){
        idSubStr=[self substringFromIndex:self.length-2];
        idSubStr=[idSubStr substringToIndex:1];
    }else{
        idSubStr=[self substringFromIndex:self.length-1];
        idSubStr=[idSubStr substringToIndex:1];
    }
    NSInteger sexNum=idSubStr.integerValue%2;
    if(sexNum==0){
        return YES;
    }
    return NO;
}

/**
 *  邮箱验证
 *
 *  @return 是否正确
 */
-(BOOL)isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
/**
 *  邮编验证
 *
 *  @return 是否正确
 */
-(BOOL)isZipCodeNum{
    NSString *mobel =
    @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *zipPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobel];
    
    if([zipPre evaluateWithObject:self] == YES)
    {
        return YES;
    }else
    {
        return NO;
    }
}
@end
