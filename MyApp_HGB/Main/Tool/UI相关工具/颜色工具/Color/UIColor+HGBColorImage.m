//
//  UIColor+HGBColorImage.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/28.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "UIColor+HGBColorImage.h"

@implementation UIColor (HGBColorImage)
#pragma mark 颜色转图片
/**
 颜色转图片

 @return 图片
 */
-(UIImage *)colorToImage
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
