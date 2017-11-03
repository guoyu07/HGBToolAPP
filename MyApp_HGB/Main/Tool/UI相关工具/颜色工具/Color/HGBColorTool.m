//
//  HGBColorTool.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/28.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBColorTool.h"
#import <UIKit/UIKit.h>
@implementation HGBColorTool
/**
 十六进制色值转为颜色

 @param hexString 色值
 @return color
 */
+ (UIColor *)ColorWithHexString:(NSString *)hexString{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red = [HGBColorTool colorComponentFrom:colorString start:0 length:1];
            green = [HGBColorTool colorComponentFrom:colorString start:1 length:1];
            blue = [HGBColorTool colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [HGBColorTool colorComponentFrom:colorString start:0 length:1];
            red = [HGBColorTool colorComponentFrom:colorString start:1 length:1];
            green = [HGBColorTool colorComponentFrom:colorString start:2 length:1];
            blue = [HGBColorTool colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red = [HGBColorTool colorComponentFrom:colorString start:0 length:2];
            green = [HGBColorTool colorComponentFrom:colorString start:2 length:2];
            blue = [HGBColorTool colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [HGBColorTool colorComponentFrom:colorString start:0 length:2];
            red = [HGBColorTool colorComponentFrom:colorString start:2 length:2];
            green = [HGBColorTool colorComponentFrom:colorString start:4 length:2];
            blue = [HGBColorTool colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            return nil;
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];

    return hexComponent / 255.0;
}
@end
