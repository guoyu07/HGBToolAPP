//
//  HGBQROrBarCodeTool.m
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBQROrBarCodeTool.h"

@implementation HGBQROrBarCodeTool

#pragma mark 二维码生成-普通
/**
 *   二维码生成－普通
 *
 *  @param codeString    字符串
 *
 *  return          二维码
 */
+(UIImage *)createQRCodeImageWithString:(NSString *)codeString{
    return [HGBQROrBarCodeTool createQRCodeImageWithString:codeString andWithWidth:200 andWithHeight:200];
}
/**
 * 二维码生成－普通-自定义尺寸

 @param codeString 字符串
 @param width 宽度
 @param height 高度
 @return 图片
 */
+(UIImage *)createQRCodeImageWithString:(NSString *)codeString andWithWidth:(CGFloat)width andWithHeight:(CGFloat)height{

    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:[codeString dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //4.获取生成的图片
    CIImage *codeImage=filter.outputImage;
    //放大ciImg,默认生产的图片很小

    //5.设置二维码的前景色和背景颜色
    CIFilter *colorFilter=[CIFilter filterWithName:@"CIFalseColor"];
    //5.1设置默认值
    [colorFilter setDefaults];
    [colorFilter setValue:codeImage forKey:@"inputImage"];
    [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor0"];
    [colorFilter setValue:[CIColor colorWithRed:1 green:1 blue:1] forKey:@"inputColor1"];
    //5.3获取生存的图片
    codeImage=colorFilter.outputImage;


    // 消除模糊
    CGFloat scaleX = width / codeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / codeImage.extent.size.height;
    CIImage *transformedImage = [codeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];

    return [HGBQROrBarCodeTool createNonInterpolatedUIImageFormCIImage:transformedImage withSize:200];
}
#pragma mark 二维码生成-logo
/**
 *   二维码生成-logo
 *
 *  @param codeString    字符串
 *  @param logoImage  二维码中间logo
 *
 *  return             带logo二维码
 */
+(UIImage *)createQRCodeImageWithString:(NSString *)codeString andWithLogoImage:(UIImage *)logoImage{

    return [HGBQROrBarCodeTool createQRCodeImageWithString:codeString andWithLogoImage:logoImage andWithWidth:200 andWithHeight:200];
}
/**
 *   二维码生成-logo-自定义尺寸
 *
 *  @param codeString    字符串
 *  @param logoImage  二维码中间logo
 *
 *  return             带logo二维码
 */
+(UIImage *)createQRCodeImageWithString:(NSString *)codeString andWithLogoImage:(UIImage *)logoImage  andWithWidth:(CGFloat)width andWithHeight:(CGFloat)height{
    UIImage *image = [HGBQROrBarCodeTool createQRCodeImageWithString:codeString andWithWidth:width andWithHeight:height];

    // 为二维码加自定义图片

    // 开启绘图, 获取图片 上下文<图片大小>
    UIGraphicsBeginImageContext(image.size);
    // 将二维码图片画上去
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 将小图片画上去
    UIImage *smallImage ;
    if(!logoImage){
        smallImage= [UIImage imageNamed:@"icon_desktop"];
    }else{
        smallImage=logoImage;
    }
    [smallImage drawInRect:CGRectMake((image.size.width-image.size.width*0.25)*0.5, (image.size.width - image.size.height*0.25) *0.5, image.size.width*0.25,image.size.height*0.25)];
    // 获取最终的图片
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return finalImage;
}
#pragma mark 二维码识别
/**
 *   二维码识别
 *
 *  @param image    二维码图片
 *
 *  return          二维码
 */
+(NSString *)identifyQRCodeImage:(UIImage *)image{
    // 开启绘图, 获取图片 上下文<图片大小>
    UIGraphicsBeginImageContext(image.size);
    // 将二维码图片画上去
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 将小图片画上去
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    //监测到的结果数组
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:finalImage.CGImage]];
    if (features.count >=1) {
        /**结果对象 */
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *result = feature.messageString;
        return result;
    }
    return nil;
    
}
#pragma mark 条形码生成

/**
 条形码生成

 @param codeString 字符串
 @return 图片
 */
+(UIImage*)createBarCodeWithString:(NSString*)codeString{
   return  [HGBQROrBarCodeTool createBarCodeWithString:codeString andWithWidth:200 andWithHeight:120];
}
/**
 条形码生成-自定义尺寸

 @param codeString 字符串
 @param width 宽度
 @param height 高度
 @return 图片
 */
+(UIImage*)createBarCodeWithString:(NSString*)codeString andWithWidth:(CGFloat)width andWithHeight:(CGFloat)height
{
    // 生成二维码图片
    CIImage *codeImage;
    NSData *data = [codeString dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];


    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    // 设置生成的条形码的上，下，左，右的margins的值
    [filter setValue:[NSNumber numberWithInteger:0] forKey:@"inputQuietSpace"];
    codeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / codeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / codeImage.extent.size.height;
    CIImage *transformedImage = [codeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [HGBQROrBarCodeTool createNonInterpolatedUIImageFormCIImage:transformedImage withSize:200];
    
}

# pragma mark 处理条形码二维码模糊不清的操作
+(UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    //设置比例
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap（位图）;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}
#pragma mark 获取app图标
/**
 获取app图标

 @return app图标
 */
+(UIImage *)getAppImage{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];

    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];

    UIImage* image = [UIImage imageNamed:icon];
    return image;
}
@end
