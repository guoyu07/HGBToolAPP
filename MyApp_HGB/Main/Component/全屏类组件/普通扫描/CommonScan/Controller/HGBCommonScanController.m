//
//  HGBCommonScanController.m
//  CTTX
//
//  Created by huangguangbao on 17/1/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCommonScanController.h"
#import "HGBCommonScanView.h"
#import "HGBCommonScanHeader.h"
#import <sys/sysctl.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>


#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"

@interface HGBCommonScanController ()<AVCaptureVideoDataOutputSampleBufferDelegate,UIAlertViewDelegate>
{
    UIImage *captureImage;//图片
    
    NSTimer *_timer;//定时
    AVCaptureDevice *_device;//当前摄像设备
    BOOL _isFoucePixel;//是否聚焦
    int _maxCount;//最大次数
    float _isIOS8AndFoucePixelLensPosition;//设备版本
    
    
    
}

@property (assign, nonatomic) BOOL adjustingFocus;//是否正在对焦

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDeviceInput *captureInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
/**
 屏幕方向
 */
@property(assign,nonatomic)BOOL orientationFlag;;
/**
 屏幕方向
 */
@property(assign,nonatomic)UIInterfaceOrientation orientation;
/**
 提示图
 */
@property(strong,nonatomic)UIAlertView *alert;
@end

@implementation HGBCommonScanController

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNativeView];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    _maxCount = 4;//最大连续检边次数
    
    
    //初始化相机
    [self initialize];
    
    
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //建立view
    [self drawScanView];
    if(!_isFoucePixel){//如果不支持相位对焦，开启自定义对焦
        //定时器 开启连续对焦
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(fouceMode) userInfo:nil repeats:YES];
    }
    
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags = NSKeyValueObservingOptionNew;
    //注册反差对焦通知（5s以下机型）
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    if (_isFoucePixel) {
        [camDevice addObserver:self forKeyPath:@"lensPosition" options:flags context:nil];
    }
    [self.session startRunning];
    [self addOritationAction];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)name:UIApplicationDidBecomeActiveNotification object:nil];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除聚焦监听
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    if (_isFoucePixel) {
        [camDevice removeObserver:self forKeyPath:@"lensPosition"];
    }
    [self.session stopRunning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //关闭定时器
    if(!_isFoucePixel){
        [_timer invalidate];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self stopScan];
}


-(void)applicationDidBecomeActive{
    if(![self JurisdictionAlert]){
        return;
    }
}
#pragma mark 导航栏
- (void)setupNativeView
{
    self.navigationItem.title = @"扫描";
    NSMutableDictionary *titleAttributesDic = [NSMutableDictionary dictionary];
        [titleAttributesDic setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttributesDic];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"HGBCommonScanBundle.bundle/bg_Nav"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    NSMutableDictionary *attributesDic = [NSMutableDictionary dictionary];
    [attributesDic setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [attributesDic setObject:[UIFont systemFontOfSize:16.0] forKey:NSFontAttributeName];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attributesDic forState:(UIControlStateNormal)];
    
}
-(void)returnAction:(UIButton *)_b{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(commonScanDidCanceled:)]){
        [self.delegate commonScanDidCanceled:self];
    }
    if(self.navigationController){
        NSArray *vcs=self.navigationController.viewControllers;
        if(self==vcs[0]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }

    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark 绘制扫描区域
- (void)drawScanView
{
    if (!_scanView)
    {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        
        self.scanView = [[HGBCommonScanView alloc]initWithFrame:rect style:self.style];
        
        [self.view addSubview:_scanView];
        
    }
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
    
    
    //     [_scanView startDeviceReadyingWithText:@"相机启动中"];
}
#pragma mark 扫描
//停止
-(void)stopScan{
    [_scanView stopDeviceReadying];
    [_scanView stopScanAnimation];
    [_session stopRunning];
}
-(void)startScan{
    [_scanView stopDeviceReadying];
    [_scanView startScanAnimation];
}
#pragma mark 适配
-(void)addOritationAction{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChangeHandle) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self orientationChangeHandle];
}
- (void)orientationChangeHandle
{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect bounds = self.view.bounds;
    if(!bounds.size.width || !bounds.size.height){
        return;
    }
    CGFloat angle = 0.0;
    if(self.orientation!=orientation){
        if(orientation==UIInterfaceOrientationPortrait){
            if(self.orientation==UIInterfaceOrientationLandscapeLeft){
                angle=M_PI_2;
            }else if(self.orientation==UIInterfaceOrientationPortraitUpsideDown){
                angle=M_PI;
            }else if (self.orientation==UIInterfaceOrientationLandscapeRight){
                angle=-M_PI_2;
            }
        }else if(orientation==UIInterfaceOrientationLandscapeLeft){
            if(self.orientation==UIInterfaceOrientationPortrait){
                angle=-M_PI_2;
            }else if (self.orientation==UIInterfaceOrientationPortraitUpsideDown){
                angle=M_PI_2;
            }else if (self.orientation==UIInterfaceOrientationLandscapeRight){
                angle=M_PI;
            }
            
        }else if(orientation==UIInterfaceOrientationPortraitUpsideDown){
            if(self.orientation==UIInterfaceOrientationPortrait){
                angle=M_PI;
            }else if (self.orientation==UIInterfaceOrientationLandscapeLeft){
                angle=-M_PI_2;
            }else if (self.orientation==UIInterfaceOrientationLandscapeRight){
                angle=M_PI_2;
            }
            
        }else if(orientation==UIInterfaceOrientationLandscapeRight){
            if(self.orientation==UIInterfaceOrientationPortrait){
                angle=M_PI_2;
            }else if (self.orientation==UIInterfaceOrientationLandscapeLeft){
                angle=M_PI;
            }else if (self.orientation==UIInterfaceOrientationPortraitUpsideDown){
                angle=-M_PI_2;
            }
            
        }
    }
    
    self.view.frame=CGRectMake(0,self.view.frame.origin.y,kHeight-64, kWidth);
    
    if (orientation == UIInterfaceOrientationPortrait)
    {
        if(!self.orientationFlag){
            self.preview.transform=CATransform3DRotate(self.preview.transform,0, 0, 0, 1);
        }else{
            self.preview.transform=CATransform3DRotate(self.preview.transform,angle, 0, 0, 1);
        }
        self.preview.frame=CGRectMake(0, 0, kWidth, kHeight-64);
    }else if (orientation == UIInterfaceOrientationLandscapeRight) // home键靠右
    {
        if(!self.orientationFlag){
            self.preview.transform=CATransform3DRotate(self.preview.transform,-M_PI_2, 0, 0, 1);
        }else{
            self.preview.transform=CATransform3DRotate(self.preview.transform,angle, 0, 0, 1);
        }
        self.preview.frame=CGRectMake(0, 0, kWidth, kHeight-64);
        
        
    }else if (
              orientation ==UIInterfaceOrientationLandscapeLeft) // home键靠左
    {
        if(!self.orientationFlag){
            self.preview.transform=CATransform3DRotate(self.preview.transform,M_PI_2, 0, 0, 1);
        }else{
            self.preview.transform=CATransform3DRotate(self.preview.transform,angle, 0, 0, 1);
        }
        
        self.preview.frame=CGRectMake(0, 0, kWidth, kHeight-64);
    }else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        if(!self.orientationFlag){
            self.preview.transform=CATransform3DRotate(self.preview.transform,M_PI_2, 0, 0, 1);
        }else{
            self.preview.transform=CATransform3DRotate(self.preview.transform,angle, 0, 0, 1);
        }
        self.preview.frame=CGRectMake(0, 0, kWidth, kHeight-64);
    }
    self.orientation=orientation;
    self.orientationFlag=YES;
}
#pragma mark 聚焦
//监听对焦
-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if([keyPath isEqualToString:@"adjustingFocus"]){
        self.adjustingFocus =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
        //对焦中
    }
    if([keyPath isEqualToString:@"lensPosition"]){
        _isIOS8AndFoucePixelLensPosition =[[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    }
}
//从摄像头缓冲区获取图像
#pragma mark - AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    //获取当前帧数据
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    
    int width = (int)CVPixelBufferGetWidth(imageBuffer);
    int height = (int)CVPixelBufferGetHeight(imageBuffer);
    CGSize imageSize;
    imageSize.width = width;
    imageSize.height = height;
    captureImage = [self imageFromSampleBuffer:sampleBuffer];
    captureImage=[self fixOrientationWithImage:captureImage];
    
    CGFloat scale_w=(kWidth-self.style.xScanRetangleOffset*2)/kWidth;
    CGFloat scale_h=((kWidth-self.style.xScanRetangleOffset*2)/self.style.whRatio)/(kHeight-64);
    CGFloat scale_centerUp=self.style.centerUpOffset/(kHeight-64);
    
    
    CGFloat cropSize_w=scale_w*imageSize.width;
    CGFloat cropSize_h=scale_h*imageSize.height;
    CGFloat x=(imageSize.width-cropSize_w)*0.5;
    CGFloat y=(imageSize.height-cropSize_h-scale_centerUp*imageSize.height)*0.5;
    CGRect cropRect;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait)
    {
        cropRect=CGRectMake(x, y,cropSize_w,cropSize_h);
        
    }else if (orientation == UIInterfaceOrientationLandscapeRight) // home键靠右
    {
        cropRect=CGRectMake(x, y,cropSize_w,cropSize_h);
        
    }else if (
              orientation ==UIInterfaceOrientationLandscapeLeft) // home键靠左
    {
        y=(imageSize.height-cropSize_h-scale_centerUp*imageSize.height)*0.5+scale_centerUp*imageSize.height;
        cropRect=CGRectMake(x, y,cropSize_w,cropSize_h);
    }else {
        y=(imageSize.height-cropSize_h-scale_centerUp*imageSize.height)*0.5+scale_centerUp*imageSize.height;
        cropRect=CGRectMake(x, y,cropSize_w,cropSize_h);
    }

    captureImage=[self cropImage:captureImage WithRect:cropRect];
    
    if(self.delegate&&[self.delegate respondsToSelector:@selector(commonScan: didReturnImage:andWithSize:)]){
        [self.delegate commonScan:self didReturnImage:captureImage andWithSize:imageSize];
    }
    
    
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
}
#pragma mark 截图图片
-(UIImage*)cropImage:(UIImage*)srcImage WithRect:(CGRect)rect
{
    CGImageRef cr = CGImageCreateWithImageInRect(srcImage.CGImage, rect);
    UIImage* cropped = [UIImage imageWithCGImage:cr];
    
    CGImageRelease(cr);
    return cropped;
}
#pragma mark 从图片缓存图片获取
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height,8,bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    CGImageRelease(quartzImage);
    
    return (image);
}

#pragma mark 相机
//获取摄像头位置
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == position)
        {
            return device;
        }
    }
    return nil;
}

//对焦
- (void)fouceMode{
    NSError *error;
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        if ([device lockForConfiguration:&error]) {
            CGPoint cameraPoint = [self.preview captureDevicePointOfInterestForPoint:self.view.center];
            [device setFocusPointOfInterest:cameraPoint];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        } else {
            NSLog(@"Error: %@", error);
        }
    }
}

#pragma mark 相机初始化
//初始化相机
- (void) initialize
{
    //如果是模拟器返回（模拟器获取不到摄像头）
    if (TARGET_IPHONE_SIMULATOR) {
        return;
    }
    if(![self JurisdictionAlert]){
        return;
    }
    //1.创建会话层
    self.session = [[AVCaptureSession alloc] init];
    //设置图片品质
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //2.创建、配置输入设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == AVCaptureDevicePositionBack)
        {
            _device = device;
            self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        }
    }
    [self.session addInput:self.captureInput];
    
    ///创建、配置预览输出设备
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    
    [self.session addOutput:captureOutput];
    
    //3.创建、配置输出
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.captureOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.captureOutput];
    
    //判断对焦方式
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        AVCaptureDeviceFormat *deviceFormat = _device.activeFormat;
        if (deviceFormat.autoFocusSystem == AVCaptureAutoFocusSystemPhaseDetection){
            _isFoucePixel = YES;
            _maxCount = 5;//最大连续检边次数
        }
    }
    
    //设置预览
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
    self.preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.preview];
    
    [self.session startRunning];
    
}
-(BOOL)JurisdictionAlert{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus ==AVAuthorizationStatusRestricted|| authStatus ==AVAuthorizationStatusDenied){
        [self stopScan];
        if(self.delegate&&[self.delegate respondsToSelector:@selector(commonScan:didFailedWithError:)]){
            [self.delegate commonScan:self didFailedWithError:@{ReslutCode:@(HGBCommonScanErrorTypeAuthority),ReslutMessage:@"相机访问权限受限"}];
        }
        self.alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置”-“隐私”-“相机”功能中，找到“某某应用”打开相机访问权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置",nil];
        [self.alert show];
        return NO;
    }
    return YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [self returnAction:nil];
    }else{
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }

}
#pragma mark 图片方向处理
/**
 拍照图片方向处理

 @return 图片
 */
-(UIImage *)fixOrientationWithImage:(UIImage *)image{

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
#pragma mark get
-(HGBCommonScanViewStyle *)style{
    if(_style==nil){
        //设置扫码区域参数
        HGBCommonScanViewStyle *style = [[HGBCommonScanViewStyle alloc]init];
        style.centerUpOffset = 20 * hScale;
        style.photoframeAngleStyle = HGBCommonScanViewPhotoframeAngleStyle_On;
        style.photoframeLineW = 5;
        style.photoframeAngleW = 25;
        style.photoframeAngleH = 25;
        style.isNeedShowRetangle = YES;
        //        style.promptImage=[UIImage imageNamed:@"icon_erweima"];
        style.HorizontalScan=NO;
        style.anmiationStyle = HGBCommonScanViewAnimationStyle_NetGrid;
        
        //矩形框离左边缘及右边缘的距离
        style.xScanRetangleOffset =94*hScale;
        
        //使用的支付宝里面网格图片
        UIImage *imgPartNet = [UIImage imageNamed:@"HGBCommonScanBundle.bundle/qrcode_scan_part_net"];
        
        style.whRatio = 1;
        
        
        style.animationImage = imgPartNet;
        _style=style;
    }
    return _style;
}
@end
