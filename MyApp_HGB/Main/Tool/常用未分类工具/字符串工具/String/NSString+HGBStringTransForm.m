//
//  NSString+HGBStringTransForm.m
//  测试app
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "NSString+HGBStringTransForm.h"

@implementation NSString (HGBStringTransForm)
#pragma mark 字符串-十六进制字符串转化
/**
 十六进制转换为普通字符串的
 @return 普通字符串
 */
- (NSString *)stringFromHexString{ //
    
    char *myBuffer = (char *)malloc((int)[self length] / 2 + 1);
    bzero(myBuffer, [self length] / 2 + 1);
    for (int i = 0; i < [self length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [self substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr] ;
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
    
    
}



/**
 普通字符串转换为十六进制的

 @return 十六进制字符串
 */
- (NSString *)hexString{
    NSData *myD = [self dataUsingEncoding:NSUTF8StringEncoding];
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
#pragma mark 转换类
/**
 *  身份证号码转生日
 *
 *
 *  @return 生日
 */
-(NSString *)idCardNumTransToBirthday{
    if(self==nil){
        return nil;
    }
    if(self.length!=15&&self.length!=18){
        return nil;
    }
    if(self.length==18){
        NSRange r;
        r.location=6;
        r.length=8;
        NSString *birthStr=[self substringWithRange:r];
        return birthStr;
    }else{
        NSRange r;
        r.location=6;
        r.length=6;
        NSString *birthStr=[NSString stringWithFormat:@"19%@",[self substringWithRange:r]];
        return birthStr;
    }
}
@end
