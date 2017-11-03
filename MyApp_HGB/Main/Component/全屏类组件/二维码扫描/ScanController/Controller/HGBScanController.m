//
//  HGBScanController.m
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/8.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBScanController.h"
#import "HGBScanHeader.h"
#import "HGBScanView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"


@interface HGBScanController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSTimer *_timer;//定时
    BOOL _isFoucePixel;//是否聚焦
    float _isIOS8AndFoucePixelLensPosition;//设备版本
    
    
    
}
@property(nonatomic,strong)AVCaptureDevice *device;//创建相机
@property(nonatomic,strong)AVCaptureDeviceInput *input;//创建输入设备
@property(nonatomic,strong)AVCaptureMetadataOutput *output;//创建输出设备
@property(nonatomic,strong)AVCaptureSession *session;//创建捕捉类
@property(strong,nonatomic)AVCaptureVideoPreviewLayer *preview;//视觉输出预览层
@property (assign, nonatomic) BOOL adjustingFocus;//是否正在对焦
/**
 屏幕方向
 */
@property(assign,nonatomic)BOOL orientationFlag;
/**
 屏幕方向
 */
@property(assign,nonatomic)UIInterfaceOrientation orientation;
/**
 提示图
 */
@property(strong,nonatomic)UIAlertView *alert;

@end

@implementation HGBScanController

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNativeView];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    _isFoucePixel=YES;
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
    
    AVCaptureDevice *camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags = NSKeyValueObservingOptionNew;
    //注册反差对焦通知（5s以下机型）
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    if (_isFoucePixel) {
        [camDevice addObserver:self forKeyPath:@"lensPosition" options:flags context:nil];
    }
    [self startScan];
    [self addOritationAction];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)name:UIApplicationDidBecomeActiveNotification object:nil];

    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除聚焦监听
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    if (_isFoucePixel) {
        [camDevice removeObserver:self forKeyPath:@"lensPosition"];
    }
    [self stopScan];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //    关闭定时器
    if(!_isFoucePixel){
        [_timer invalidate];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"HGBScanBundle.bundle/bg_Nav"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    NSMutableDictionary *attributesDic = [NSMutableDictionary dictionary];
        [attributesDic setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [attributesDic setObject:[UIFont systemFontOfSize:16.0] forKey:NSFontAttributeName];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attributesDic forState:(UIControlStateNormal)];
    
}
-(void)returnAction:(UIButton *)_b{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(scanDidCanceled:)]){
        [self.delegate scanDidCanceled:self];
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
        
        //        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        //
        //
        //        if (orientation == UIInterfaceOrientationPortrait)
        //        {
        //            self.style.whRatio = 1.587;
        //        }else if (orientation == UIInterfaceOrientationLandscapeRight) // home键靠右
        //        {
        //
        //             self.style.whRatio = 0.63;
        //
        //        }else if (
        //                  orientation ==UIInterfaceOrientationLandscapeLeft) // home键靠左
        //        {
        //             self.style.whRatio = 0.63;
        //        }else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
        //        {
        //             self.style.whRatio = 1.587;
        //        }
        
        
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        
        self.scanView = [[HGBScanView alloc]initWithFrame:rect style:self.style];
        
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
    [_session startRunning];
}
- (void)dealloc
{
    self.device = nil;
    [self.session stopRunning];
    self.session = nil;
    self.input = nil;
    self.output = nil;
    self.preview = nil;
    [self.scanView stopScanAnimation];
    self.scanView = nil;
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
        //        _isIOS8AndFoucePixelLensPosition =[[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    }
}
//从摄像头缓冲区获取图像
#pragma mark - AVCaptureSession delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    
    // 判断扫描结果的数据是否存在
    if ([metadataObjects count] >0){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1007);
        int i=0;
        for (i=0;i<metadataObjects.count;i++) {
            id obj=metadataObjects[i];
            // 判断检测到的对象类型
            if ([obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
                break;
            }
            
        }
        if(i!=metadataObjects.count){
            // 如果存在数据,停止扫描
            [self.session stopRunning];
            [self.scanView stopScanAnimation];
            // AVMetadataMachineReadableCodeObject是AVMetadataObject的具体子类定义的特性检测一维或二维条形码。
            // AVMetadataMachineReadableCodeObject代表一个单一的照片中发现机器可读的代码。这是一个不可变对象描述条码的特性和载荷。
            // 在支持的平台上,AVCaptureMetadataOutput输出检测机器可读的代码对象的数组
            AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
            // 获取扫描到的信息
            NSString *stringValue = metadataObject.stringValue;
            if(self.delegate&&[self.delegate respondsToSelector:@selector(scan:didFinishWithResult:)]){
                [self.delegate scan:self didFinishWithResult:stringValue];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            [self stopScan];
        }
        
    }
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
    
    // 下面的是比较重要的,也是最容易出现崩溃的原因,就是我们的输出流的类型
    // 1.这里可以设置多种输出类型,这里必须要保证session层包括输出流
    // 2.必须要当前项目访问相机权限必须通过,所以最好在程序进入当前页面的时候进行一次权限访问的判断
    if(![self JurisdictionAlert]){
        return;
    }
    
    //初始化基础"引擎"Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //初始化输入流 Input,并添加Device
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //初始化输出流Output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    //设置输出流的相关属性
    // 确定输出流的代理和所在的线程,这里代理遵循的就是上面我们在准备工作中提到的第一个代理,至于线程的选择,建议选在主线程,这样方便当前页面对数据的捕获.
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    NSLog(@"%f",self.style.whRatio);
    //设置扫描区域的大小 rectOfInterest  默认值是CGRectMake(0, 0, 1, 1) 按比例设置
    self.output.rectOfInterest = CGRectMake((((kHeight-64-(kWidth-2*self.style.xScanRetangleOffset)/self.style.whRatio))*0.5-self.style.centerUpOffset)/kHeight,self.style.xScanRetangleOffset/kWidth,(kWidth-2*self.style.xScanRetangleOffset)/self.style.whRatio/kHeight,(kWidth-2*self.style.xScanRetangleOffset)/kWidth);
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(self.style.xScanRetangleOffset,(((kHeight-64-(kWidth-2*self.style.xScanRetangleOffset)/self.style.whRatio))*0.5-self.style.centerUpOffset),(kWidth-2*self.style.xScanRetangleOffset),(kWidth-2*self.style.xScanRetangleOffset)/self.style.whRatio)];
        v.backgroundColor=[UIColor redColor];
//        [self.view addSubview:v];
    
    /*
     // AVCaptureSession 预设适用于高分辨率照片质量的输出
     AVF_EXPORT NSString *const AVCaptureSessionPresetPhoto NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     // AVCaptureSession 预设适用于高分辨率照片质量的输出
     AVF_EXPORT NSString *const AVCaptureSessionPresetHigh NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     // AVCaptureSession 预设适用于中等质量的输出。 实现的输出适合于在无线网络共享的视频和音频比特率。
     AVF_EXPORT NSString *const AVCaptureSessionPresetMedium NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     // AVCaptureSession 预设适用于低质量的输出。为了实现的输出视频和音频比特率适合共享 3G。
     AVF_EXPORT NSString *const AVCaptureSessionPresetLow NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     */
    
    // 初始化session
    self.session = [[AVCaptureSession alloc]init];
    // 设置session类型,AVCaptureSessionPresetHigh 是 sessionPreset 的默认值。
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //将输入流和输出流添加到session中
    // 添加输入流
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    // 添加输出流
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
        
        //扫描格式
        NSMutableArray *metadataObjectTypes = [NSMutableArray array];
        [metadataObjectTypes addObjectsFromArray:@[
                                                   AVMetadataObjectTypeQRCode,
                                                   AVMetadataObjectTypeEAN13Code,
                                                   AVMetadataObjectTypeEAN8Code,
                                                   AVMetadataObjectTypeCode128Code,
                                                   AVMetadataObjectTypeCode39Code,
                                                   AVMetadataObjectTypeCode93Code,
                                                   AVMetadataObjectTypeCode39Mod43Code,
                                                   AVMetadataObjectTypePDF417Code,
                                                   AVMetadataObjectTypeAztecCode,
                                                   AVMetadataObjectTypeUPCECode,
                                                   ]];
        
        // >= ios 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code,
                                                       AVMetadataObjectTypeITF14Code,
                                                       AVMetadataObjectTypeDataMatrixCode]];
        }
        //设置扫描格式
        self.output.metadataObjectTypes= metadataObjectTypes;
    }
    
    
    //设置输出展示平台AVCaptureVideoPreviewLayer
    // 初始化
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    // 设置Video Gravity,顾名思义就是视频播放时的拉伸方式,默认是AVLayerVideoGravityResizeAspect
    // AVLayerVideoGravityResizeAspect 保持视频的宽高比并使播放内容自动适应播放窗口的大小。
    // AVLayerVideoGravityResizeAspectFill 和前者类似，但它是以播放内容填充而不是适应播放窗口的大小。最后一个值会拉伸播放内容以适应播放窗口.
    // 因为考虑到全屏显示以及设备自适应,这里我们采用fill填充
    self.preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    // 设置展示平台的frame
    self.preview.frame = CGRectMake(0, 0, kWidth, kHeight-64);
    // 因为 AVCaptureVideoPreviewLayer是继承CALayer,所以添加到当前view的layer层
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    //开始
    [self.session startRunning];
    
}
-(BOOL)JurisdictionAlert{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus ==AVAuthorizationStatusRestricted|| authStatus ==AVAuthorizationStatusDenied){
        [self stopScan];
        if(self.delegate&&[self.delegate respondsToSelector:@selector(scan:didFailedWithError:)]){
            [self.delegate scan:self didFailedWithError:@{ReslutCode:@"1",ReslutMessage:@"相机访问权限受限"}];
        }
       self.alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置”-“隐私”-“相机”功能中，找到“某某应用”打开相机访问权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置",nil];
        [self.alert show];
        return NO;
    }
    return YES;
}
#pragma mark --alertdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }else{
        [self returnAction:nil];
    }
}
#pragma mark - - - 扫描提示声
/** 播放音效文件 */
- (void)playSoundEffect:(NSString *)name{
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    // 如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}

/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    NSLog(@"播放完成...");
}
#pragma mark get
-(HGBScanViewStyle *)style{
    if(_style==nil){
        //设置扫码区域参数
        HGBScanViewStyle *style = [[HGBScanViewStyle alloc]init];
        style.centerUpOffset = 20 * hScale;
        style.photoframeAngleStyle = HGBScanViewPhotoframeAngleStyle_On;
        style.photoframeLineW = 5;
        style.photoframeAngleW = 25;
        style.photoframeAngleH = 25;
        style.isNeedShowRetangle = YES;
        //        style.promptImage=[UIImage imageNamed:@"icon_erweima"];
        style.HorizontalScan=NO;
        style.anmiationStyle = HGBScanViewAnimationStyle_NetGrid;
        
        //矩形框离左边缘及右边缘的距离
        style.xScanRetangleOffset =94*wScale;
        
        //使用的支付宝里面网格图片
        UIImage *imgPartNet = [UIImage imageNamed:@"HGBScanBundle.bundle/qrcode_scan_part_net"];
        
        style.whRatio = 0.63;
        
        
        style.animationImage = imgPartNet;
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        
        if (orientation == UIInterfaceOrientationPortrait)
        {
            style.whRatio = 1.587;
        }else if (orientation == UIInterfaceOrientationLandscapeRight) // home键靠右
        {
            
            style.whRatio = 0.63;
            
        }else if (
                  orientation ==UIInterfaceOrientationLandscapeLeft) // home键靠左
        {
            style.whRatio = 0.63;
        }else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            style.whRatio = 1.587;
        }
        style.whRatio = 1;
        _style=style;
        
    }
    return _style;
}

@end
