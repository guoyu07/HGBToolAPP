//
//  HGBImageTool.m
//  CTTX
//
//  Created by huangguangbao on 16/10/4.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import "HGBImageTool.h"

@implementation HGBImageTool
#pragma mark 颜色转图片
/**
 颜色转图片

 @param color 颜色
 @return 图片
 */
+(UIImage *)imageFromColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark  剪切图片
/**
 *   剪切图片
 *
 *  @param srcImage    原图片
 *  @param rect        剪切尺寸
 *
 *  return             剪切后图片
 */
+(UIImage*)cropImage:(UIImage*)srcImage withRect:(CGRect)rect
{
    CGImageRef cr = CGImageCreateWithImageInRect(srcImage.CGImage, rect);
    UIImage* croppedImage = [UIImage imageWithCGImage:cr];
    
    CGImageRelease(cr);
    return croppedImage;
}
#pragma mark 图片尺寸变换
/**
 *   图片尺寸变换
 *
 *  @param image    原图片
 *  @param scaleSize       变换比例
 *
 *  return             变换后图片
 */
+ (UIImage *)configureImage:(UIImage *)image withScale:(CGFloat)scaleSize
{
    image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
/**
 *   图片尺寸-将UIImage压缩到固定的宽度，高度也随之改变，而不变形
 *
 *  @param image    图片
 *  @param width    图片宽度
 *
 *  return             变换后图片
 */
+ (UIImage *)configureImage:(UIImage *)image withWidth:(CGFloat)width{
    image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
    UIGraphicsBeginImageContext(CGSizeMake(width,width*image.size.height/image.size.width));
    [image drawInRect:CGRectMake(0, 0, width,width*image.size.height/image.size.width)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 *   图片尺寸-将UIImage压缩到固定的宽度，高度也随之改变，而不变形
 *
 *  @param height    图片高度
 *  @param image    图片
 *  return             变换后图片
 */
+ (UIImage *)configureImage:(UIImage *)image withHeight:(CGFloat)height{
    image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
    image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
    UIGraphicsBeginImageContext(CGSizeMake(height*image.size.width/image.size.height,height));
    [image drawInRect:CGRectMake(0, 0,height*image.size.width/image.size.height,height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
#pragma mark 图片大小压缩
/**
 *   图片大小压缩
 *
 *  @param bytes   字节
 *  @param image    图片
 *  return             变换后图片
 */
+ (UIImage *)configureImage:(UIImage *)image withBytes:(NSInteger)bytes{
    NSData *fileData = UIImageJPEGRepresentation(image,1);
    UIImage *fileImage=image;
    while (fileData.length  > bytes) {
        fileImage = [HGBImageTool configureImage:fileImage withScale:0.5];
        fileData = UIImageJPEGRepresentation(fileImage, 1);

    }
    return fileImage;
}
/**
 *   图片大小压缩-不失真
 *
 *  @param bytes   字节
 *  @param image    图片
 *  return             变换后图片
 */
+ (UIImage *)configureImageWithoutDistort:(UIImage *)image withBytes:(NSInteger)bytes{
    NSData *fileData = UIImageJPEGRepresentation(image,1);
    UIImage *fileImage=image;
    NSInteger orignaBytes=bytes;
    while (fileData.length >= bytes) {
        fileData = UIImageJPEGRepresentation(fileImage, 0.9);
        if(((NSInteger)fileData.length-orignaBytes)>=0){
            break;
        }
        orignaBytes=fileData.length;



    }
    fileImage=[UIImage imageWithData:fileData];
    return fileImage;
}
#pragma mark  图片旋转
/**
 *   图片旋转
 *
 *  @param image    原图片
 *  @param angle    变换角度
 *
 *  return             旋转后图片
 */
+ (UIImage *)rotateImage:(UIImage *)image withAngle:(CGFloat)angle{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image=image;
    imageView.transform =CGAffineTransformRotate(imageView.transform, angle / 180 * M_PI);
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    imageView.center=containerView.center;
    [containerView addSubview:imageView];
    UIGraphicsBeginImageContext(containerView.bounds.size);
    CGContextRef  context = UIGraphicsGetCurrentContext();
    [containerView.layer renderInContext:context];
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rotatedImage;
}
#pragma mark  获取圆形或椭圆图片
/**
 *   获取圆形或椭圆图片
 *
 *  @param image    原图片
 *
 *  return             旋转后图片
 */
+ (UIImage *)getRoundImage:(UIImage *)image{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image=image;
    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    //大小 底色(黑白) 大小变化
    //开始
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGRect rect=imageView.bounds;
    CGContextAddEllipseInRect(context,rect);
    CGContextClip(context);//裁剪
    [image drawInRect:rect];
    //从上下文获取图片
    UIImage *roundImage=UIGraphicsGetImageFromCurrentImageContext();
    //结束图片上下文
    UIGraphicsEndImageContext();
    return roundImage;
}
#pragma mark  图片方向大小-根据屏幕方向
/**
 *   图片方向大小-根据屏幕方向
 *
 *  @param image    原图片
 *  @param scaleSize       变换比例
 *
 *  return             旋转后图片
 */
+(UIImage *)rotateImage:(UIImage *)image withScale:(CGFloat)scaleSize{
    CGImageRef imRef = [image CGImage];
    
    UIImageOrientation orientation = [image imageOrientation];
    
    long texWidth = CGImageGetWidth(imRef);
    long texHeight = CGImageGetHeight(imRef);
    
    float imageScale =scaleSize;
    if(orientation == UIImageOrientationUp && texWidth < texHeight){
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationLeft];
    }else if((orientation == UIImageOrientationUp && texWidth > texHeight) || orientation == UIImageOrientationRight){
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationUp];
    }else if(orientation == UIImageOrientationDown){
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationDown];
    }else if(orientation == UIImageOrientationLeft){
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationUp];
    }
    return image;
}
#pragma mark 图片方向处理
/**
 拍照图片方向处理

 @return 图片
 */
+(UIImage *)fixOrientationWithImage:(UIImage *)image{

    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }

    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
