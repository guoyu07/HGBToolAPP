//
//  HGBStringTool.m
//  测试app
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBStringTool.h"

@implementation HGBStringTool
#pragma mark 字符串处理
/**
 删除字符串两端空格
 
 @param string 字符串
 @return 处理后字符串
 */
+(NSString *)trimWithString:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
/**
 删除字符串空格
 
 @param string 字符串
 @return 处理后字符串
 */
+(NSString *)deleteSpaceWithString:(NSString *)string
{
    NSString *str=string;
    while ([str containsString:@" "]){
        str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return str;
}
/**
 汉字转拼音
 
 @param string 汉字字符串
 @return 拼音字符串
 */
+(NSString *) transToPinYinWithString:(NSString *)string
{
    NSMutableString *source = [string mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);//翻译普通话为拉丁文
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);//去除变音符
    return source;
}
/**
 *  获取数字字符串
 *
 *  @param string 原str
 *
 *  @return 字符串中的数字字符串
 */
+(NSString *)getNumberStringFromString:(NSString *)string{
    NSString *numStr=string;
    NSArray *numArr=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSRange r;
    for(int i=0;i<string.length;i++){
        r.length=1;
        r.location=i;
        NSString *sub=[string substringWithRange:r];
        if(![numArr containsObject:sub]){
            numStr=[numStr stringByReplacingCharactersInRange:r withString:@"-"];
        }
    }
    while ([numStr containsString:@"-"]) {
        numStr=[numStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    return numStr;
}


/**
 *  url字符处理
 *
 *  @param urlString 原url
 *
 *  @return 新url
 */
+(NSString *)urlFormatString:(NSString *)urlString{
    return [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

/**
 把Json对象转化成json字符串
 
 @param object 对象
 @return json字符串
 */
+ (NSString *)JSONString:(id)object
{
    if(!([object isKindOfClass:[NSDictionary class]]||[object isKindOfClass:[NSArray class]]||[object isKindOfClass:[NSString class]])){
        return @"";
    }
    if([object isKindOfClass:[NSString class]]){
        return object;
    }
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return myString;
}
/**
 把Json字符串转化成json对象
 
 @param jsonString json字符串
 @return json对象
 */
+ (id)JSOObject:(NSString *)jsonString{
    if(![jsonString isKindOfClass:[NSString class]]){
        return @"";
    }
    jsonString=[HGBStringTool jsonStringHandle:jsonString];
    NSLog(@"%@",jsonString);
    NSError *error = nil;
    NSData  *data=[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if(jsonString.length>0&&[[jsonString substringToIndex:1] isEqualToString:@"{"]){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(error){
            NSLog(@"%@",error);
            return jsonString;
        }else{
            return dic;
        }
    }else if(jsonString.length>0&&[[jsonString substringToIndex:1] isEqualToString:@"["]){
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(error){
            NSLog(@"%@",error);
            return jsonString;
        }else{
            return array;
        }
    }else{
        return jsonString;
    }
}
/**
 json字符串处理
 
 @param jsonString 字符串处理
 @return 处理后字符串
 */
+(NSString *)jsonStringHandle:(NSString *)jsonString{
    NSString *string=jsonString;
    //大括号
    
    //中括号
    while ([string containsString:@"【"]) {
        string=[string stringByReplacingOccurrencesOfString:@"【" withString:@"]"];
    }
    while ([string containsString:@"】"]) {
        string=[string stringByReplacingOccurrencesOfString:@"】" withString:@"]"];
    }
    
    //小括弧
    while ([string containsString:@"（"]) {
        string=[string stringByReplacingOccurrencesOfString:@"（" withString:@"("];
    }
    
    while ([string containsString:@"）"]) {
        string=[string stringByReplacingOccurrencesOfString:@"）" withString:@")"];
    }
    
    
    while ([string containsString:@"("]) {
        string=[string stringByReplacingOccurrencesOfString:@"(" withString:@"["];
    }
    
    while ([string containsString:@")"]) {
        string=[string stringByReplacingOccurrencesOfString:@")" withString:@"]"];
    }
    
    
    //逗号
    while ([string containsString:@"，"]) {
        string=[string stringByReplacingOccurrencesOfString:@"，" withString:@","];
    }
    while ([string containsString:@";"]) {
        string=[string stringByReplacingOccurrencesOfString:@";" withString:@","];
    }
    while ([string containsString:@"；"]) {
        string=[string stringByReplacingOccurrencesOfString:@"；" withString:@","];
    }
    //引号
    while ([string containsString:@"“"]) {
        string=[string stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    }
    while ([string containsString:@"”"]) {
        string=[string stringByReplacingOccurrencesOfString:@"”" withString:@"\""];
    }
    while ([string containsString:@"‘"]) {
        string=[string stringByReplacingOccurrencesOfString:@"‘" withString:@"\""];
    }
    while ([string containsString:@"'"]) {
        string=[string stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    }
    //冒号
    while ([string containsString:@"："]) {
        string=[string stringByReplacingOccurrencesOfString:@"：" withString:@":"];
    }
    //等号
    while ([string containsString:@"="]) {
        string=[string stringByReplacingOccurrencesOfString:@"=" withString:@":"];
    }
    while ([string containsString:@"="]) {
        string=[string stringByReplacingOccurrencesOfString:@"=" withString:@":"];
    }
    return string;
    
}
/**
 字符串编码
 
 @param string 原字符串
 @return 编码后字符串
 */
+ (NSString *)stringEncodingWithString:(NSString *)string
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return encodedString;
}
#pragma mark  验证字符串类型
/**
 *  验证字符是否是数字
 *
 *  @param string string
 *
 *  @return  结果
 */
+(BOOL)isNumString:(NSString *)string{
    NSString *idStr=@"^[0-9]+$";
    NSPredicate*regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",idStr];
    
    if([regextestmobile evaluateWithObject:string]==YES){
        return YES;
    }else{
        return NO;
    }
}


/**
 *  验证字符是否是字母
 *
 *  @param string string
 *
 *  @return  结果
 */
+(BOOL)isWordString:(NSString *)string{
    NSString *idStr=@"^[A-Za-z]+$";;
    NSPredicate*regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",idStr];
    
    if([regextestmobile evaluateWithObject:string]==YES){
        return YES;
    }else{
        return NO;
    }
}
/**
 *  验证字符是否是汉字
 *
 *  @param string string
 *
 *  @return  结果
 */
+(BOOL)isChineseString:(NSString *)string{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}
/**
 *  检验字符是否是字母或数字
 *
 *  @param string 字符串
 *
 *  @return 字符串合法性
 */
+(BOOL)isNumOrWordString:(NSString *)string
{
    NSString *idStr=@"^[A-Za-z0-9]+$";
    NSPredicate*regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",idStr];
    
    if([regextestmobile evaluateWithObject:string]==YES){
        return YES;
    }else{
        return NO;
    }
}
#pragma mark 字符串-十六进制字符串转化
/**
 十六进制转换为普通字符串的
 
 @param hexString 16进制字符串
 @return 普通字符串
 */
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr] ;
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
    
    
}



/**
 普通字符串转换为十六进制的
 
 @param string 普通字符串
 @return 十六进制字符串
 */
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
#pragma mark 常用校验
/**
 *  校验字符串
 *
 *  @param string 字符串
 *  @param length 字符串长度
 *  @param type 0 数字 1字母 2字母数字 3汉字
 *
 *  @return 是否是纯数字字符串
 */
+(BOOL)checkCodeString:(NSString *)string WithLength:(int)length andWithType:(int)type{
    if (string==nil||string.length!=length) {
        return NO;
    }
    if(type==0){
        if([HGBStringTool isNumString:string]){
            return YES;
        }else{
            return NO;
        }
    }else if (type==1){
        if([HGBStringTool isWordString:string]){
            return YES;
        }else{
            return NO;
        }
    }else if (type==2){
        if([HGBStringTool isNumOrWordString:string]){
            return YES;
        }else{
            return NO;
        }
    }else if (type==3){
        if([HGBStringTool isChineseString:string]){
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

/**
 *  手机号验证－宽松
 *
 *  @param phoneNum 手机号
 *
 *  @return 是否是手机号
 */
+ (BOOL)isMobileNumber:(NSString *)phoneNum
{
    //手机号码
    NSString *mobel =
    @"^(1[3|4|5|7|8][0-9])\\d{8}$";
    
    NSPredicate *mobelPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobel];
    
    if([mobelPre evaluateWithObject:phoneNum] == YES)
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
 *  @param phoneNum 手机号
 *
 *  @return 是否是手机号
 */
+ (BOOL)isStrictMobileNumber:(NSString *)phoneNum{
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
    
    if(([xinMobelPre evaluateWithObject:phoneNum] == YES)
       ||([regextestmobile evaluateWithObject:phoneNum] ==YES)
       || ([regextestcm evaluateWithObject:phoneNum] ==YES)
       || ([regextestct evaluateWithObject:phoneNum] ==YES)
       || ([regextestcu evaluateWithObject:phoneNum] ==YES))
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
 *  @param IdCardNum 身份证号码
 *
 *  @return 是否正确
 */
+(BOOL)isIDCardNum:(NSString *)IdCardNum{
    NSString *idStr=@"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate*regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",idStr];
    if([regextestmobile evaluateWithObject:IdCardNum]==YES){
        return YES;
    }else{
        return NO;
    }
}
/**
 *  身份证验证-严格
 *
 *  @param IdCardNum 身份证号码
 *
 *  @return 是否正确
 */
+(BOOL)isStritIDCardNum:(NSString *)IdCardNum{
    if(IdCardNum.length!=15){
        if (IdCardNum.length != 18) return NO;
        // 正则表达式判断基本 身份证号是否满足格式
        NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
        NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        //如果通过该验证，说明身份证格式正确，但准确性还需计算
        if(![identityStringPredicate evaluateWithObject:IdCardNum]) return NO;
        
        //** 开始进行校验 *//
        //将前17位加权因子保存在数组里
        NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++) {
            NSInteger subStrIndex = [[IdCardNum substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            idCardWiSum+= subStrIndex * idCardWiIndex;
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        //得到最后一位身份证号码
        NSString *idCardLast= [IdCardNum substringWithRange:NSMakeRange(17, 1)];
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
        if([regextestmobile evaluateWithObject:IdCardNum]==YES){
            return YES;
        }else{
            return NO;
        }
    }
}
/**
 *  性别判断
 *
 *  @param idCardNum 身份证号
 *
 *  @return 性别
 */
+(BOOL)isAWomanWithIdCardNum:(NSString *)idCardNum{
    if(![HGBStringTool isStritIDCardNum:idCardNum]){
        return NO;
    }
    NSString *idSubStr;
    if(idCardNum.length==18){
        idSubStr=[idCardNum substringFromIndex:idCardNum.length-2];
        idSubStr=[idSubStr substringToIndex:1];
    }else{
        idSubStr=[idCardNum substringFromIndex:idCardNum.length-1];
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
 *  @param email 邮箱
 *
 *  @return 是否正确
 */
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
/**
 *  邮编验证
 *
 *  @param zipCode 邮编号码
 *
 *  @return 是否正确
 */
+(BOOL)isZipCodeNum:(NSString *)zipCode{
    NSString *mobel =
    @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *zipPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobel];
    
    if([zipPre evaluateWithObject:zipCode] == YES)
    {
        return YES;
    }else
    {
        return NO;
    }
}
#pragma mark 转换类
/**
 *  身份证号码转生日
 *
 *  @param idCardNum 身份证号码
 *
 *  @return 生日
 */
+(NSString *)idCardNumTransToBirthday:(NSString *)idCardNum{
    if(idCardNum==nil){
        return nil;
    }
    idCardNum=[HGBStringTool deleteSpaceWithString:idCardNum];
    if(idCardNum.length!=15&&idCardNum.length!=18){
        return nil;
    }
    if(idCardNum.length==18){
        NSRange r;
        r.location=6;
        r.length=8;
        NSString *birthStr=[idCardNum substringWithRange:r];
        return birthStr;
    }else{
        NSRange r;
        r.location=6;
        r.length=6;
        NSString *birthStr=[NSString stringWithFormat:@"19%@",[idCardNum substringWithRange:r]];
        return birthStr;
    }
}
@end
