//
//  NSString+HGBString.m
//  CTTX
//
//  Created by huangguangbao on 16/5/28.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import "NSString+HGBString.h"

@implementation NSString (HGBString)
#pragma mark 删除两端空格
-(NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
#pragma mark 删除空格
-(NSString *)deleteSpace
{
    NSString *str=self;
    while ([str containsString:@" "]){
        str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return str;
}
//删除空格
+(NSString *)returnFormatString:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@" "withString:@" "];
}
#pragma mark 汉字转拼音
-(NSString *) transToPinYin
{
    NSMutableString *source = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);//翻译普通话为拉丁文
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);//去除变音符
    return source;
}

/**
 *  获取数字字符串
 *
 *
 *  @return 字符串中的数字字符串
 */
-(NSString *)getNumberString{
    NSString *numStr=self;
    NSArray *numArr=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSRange r;
    for(int i=0;i<self.length;i++){
        r.length=1;
        r.location=i;
        NSString *sub=[self substringWithRange:r];
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
 *
 *  @return 新url
 */
-(NSString *)urlFormatString{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

/**
 字符串编码
 @return 编码后字符串
 */
-(NSString *)stringEncoding
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return encodedString;
}

@end
