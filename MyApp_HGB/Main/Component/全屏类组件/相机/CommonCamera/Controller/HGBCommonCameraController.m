//
//  HGBCommonCameraController.m
//  CTTX
//
//  Created by huangguangbao on 2017/3/20.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCommonCameraController.h"
#import "HGBCommonCameraView.h"
#import "HGBCommonCameraHeader.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"


@interface HGBCommonCameraController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,HGBCommonCameraViewDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property(strong,nonatomic)HGBCommonCameraView *cameraView;
@property(assign,nonatomic)NSInteger flashId;
@property(assign,nonatomic)NSInteger navType;
@property(assign,nonatomic)BOOL deviceType;
@property(strong,nonatomic)NSMutableArray *promptViewArray;
@property(strong,nonatomic)NSMutableArray *promptViewCopyArray;

/**
 提示图
 */
@property(strong,nonatomic)UIAlertView *alert;
/**
 导航栏
 */
@property(strong,nonatomic)UIView *navView;
@end

@implementation HGBCommonCameraController
#pragma mark life
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _imagePicker.delegate=nil;
    _imagePicker=nil;
    _cameraView=nil;
    _promptViewArray=nil;
    _promptViewCopyArray=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.flashId=0;
    self.deviceType=YES;
    [self createNavigationItemWithType:1 andWithImageIndex:self.flashId];//导航栏
    [self viewSetUp];//ui
  
}
#pragma mark 导航栏
//导航栏  type 0:空白版本 1:普通-散光灯 2:普通-散光选择  idx  0自动 1打开散光灯 2关闭散光灯
-(void)createNavigationItemWithType:(NSInteger)type andWithImageIndex:(NSInteger)idx{
    self.navType=type;
    if([self.navView superview]){
        [self.navView removeFromSuperview];
    }
    self.navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    self.navView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.navView];
    if(type==0){
       
    }else if (type==1){
        
        UIButton *leftButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
        leftButton.frame=CGRectMake(20*wScale, 0, 40, 40);
        [leftButton addTarget:self action:@selector(flashButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
        if(idx==0){
            [leftButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_auto_pressed"] forState:(UIControlStateNormal)];
            [leftButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_auto_pressed"] forState:(UIControlStateHighlighted)];
           
        }else if (idx==2){
            [leftButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_off_normal"] forState:(UIControlStateNormal)];
            [leftButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_off_pressed"] forState:(UIControlStateHighlighted)];
        }else{
            [leftButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_on_normal"] forState:(UIControlStateNormal)];
            [leftButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_on_pressed"] forState:(UIControlStateHighlighted)];
        }
         [self.navView addSubview:leftButton];
        
    }else if (type==2){
        UIButton *leftButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
        leftButton.frame=CGRectMake(20*wScale, 0, 40, 40);
         [leftButton addTarget:self action:@selector(flashButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
        if(idx==0){
            [leftButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_auto_pressed"] forState:(UIControlStateNormal)];
            [leftButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_auto_pressed"] forState:(UIControlStateHighlighted)];
            
        }else if (idx==2){
            [leftButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_off_normal"] forState:(UIControlStateNormal)];
            [leftButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_off_pressed"] forState:(UIControlStateHighlighted)];
        }else{
            [leftButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_on_normal"] forState:(UIControlStateNormal)];
            [leftButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_on_pressed"] forState:(UIControlStateHighlighted)];
        }
        [self.navView addSubview:leftButton];
        
        UISegmentedControl *seg=[[UISegmentedControl alloc]initWithFrame:CGRectMake((kWidth-300*wScale)*0.5,8.5,300*wScale, 27)];
        seg.tintColor = [UIColor clearColor];
        
        NSDictionary *dic0=@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:[UIColor clearColor]};
        [seg setTitleTextAttributes:dic0 forState:UIControlStateNormal];
        
        NSDictionary *dic1=@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor yellowColor],NSBackgroundColorAttributeName:[UIColor clearColor]};
        [seg setTitleTextAttributes:dic1 forState:UIControlStateSelected];
        
        
        [seg insertSegmentWithTitle:[NSString stringWithFormat:@"自动"] atIndex:0 animated:YES];
       
        [seg insertSegmentWithTitle:[NSString stringWithFormat:@"打开"] atIndex:1 animated:YES];
         [seg insertSegmentWithTitle:[NSString stringWithFormat:@"关闭"] atIndex:2 animated:YES];
        [seg addTarget:self action:@selector(flashSegmentHandler:) forControlEvents:UIControlEventValueChanged];
        
        seg.selectedSegmentIndex=self.flashId;
        [self.navView addSubview:seg];
    }
}
#pragma mark navHandle
-(void)flashButtonHandle:(UIButton *)_b{
    if(self.navType==1){
        [self createNavigationItemWithType:2 andWithImageIndex:self.flashId];
    }else{
        [self createNavigationItemWithType:1 andWithImageIndex:self.flashId];
    }
}
-(void)flashSegmentHandler:(UISegmentedControl *)_s{
    self.flashId=_s.selectedSegmentIndex;
    [self createNavigationItemWithType:1 andWithImageIndex:self.flashId];
    [self commonCameraViewButtonDidClickWithIndex:self.flashId+40];
}
#pragma mark return
//返回
-(void)returnHandler{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(commonCameraDidCanceled:)]){

        [self.delegate commonCameraDidCanceled:self];
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

#pragma mark view
-(void)viewSetUp{
    
    if(![self.cameraView superview]){
        self.cameraView=[[HGBCommonCameraView alloc]initWithFrame:CGRectMake(0,44, kWidth, kHeight-44)];
        self.cameraView.delegate=self;
        self.cameraView.style=self.style;
        [self.view addSubview:self.cameraView];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            if(self.delegate&&[self.delegate respondsToSelector:@selector(commonCamera:didFailedWithError:)]){
                [self.delegate commonCamera:self didFailedWithError:@{ReslutCode:@(HGBCommonCameraErrorTypeAuthority),ReslutMessage:@"相机访问权限受限"}];
            }
            self.alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置”-“隐私”-“相机”功能中，找到“某某应用”打开相机访问权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置",nil];
            [self.alert show];
            return;
        }
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        //代理
        self.imagePicker.delegate = self;
        //类型
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        //隐藏系统相机操作
        self.imagePicker.showsCameraControls = NO;
        self.imagePicker.allowsEditing=YES;
        self.imagePicker.view.frame=self.cameraView.showView.frame;
        self.imagePicker.cameraOverlayView=self.cameraView.showView;
        
        [self.cameraView addSubview:self.imagePicker.view];
        [self addChildViewController:self.imagePicker];

    } else {
        if(self.delegate&&[self.delegate respondsToSelector:@selector(commonCamera:didFailedWithError:)]){
            [self.delegate commonCamera:self didFailedWithError:@{ReslutCode:@(HGBCommonCameraErrorTypeDevice),ReslutMessage:@"相机不可用"}];
        }
        self.alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"相机不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [self.alert show];
    }
    
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
        [self returnHandler];
    }
}
#pragma mark handle

/**
 添加提示图

 @param promptView 提示图
 */
-(void)addPromtView:(UIView *)promptView{
    [self.view addSubview:promptView];
    [self.promptViewArray addObject:promptView];
    UIView *v=[self duplicate:promptView];
    [self.promptViewCopyArray addObject:v];
}

-(void)addPromptViews{
    self.promptViewArray=[NSMutableArray array];
    for(NSInteger i=0;i<self.promptViewCopyArray.count;i++){
        UIView  *view = self.promptViewCopyArray[i];
        [self.view addSubview:view];
        [self.promptViewArray addObject:view];
        UIView *v=[self duplicate:view];
        [self.promptViewCopyArray replaceObjectAtIndex:i withObject:v];
    }
}
/**
 清空提示图
 */
-(void)removePromptView{
    for(UIView  *v in self.promptViewArray){
        [v removeFromSuperview];
    }
}

/**
 复制view
 */
- (UIView*)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}
#pragma mark viewDelegateAction
/**
 *  自定义相机界面及按钮事件
 *
 *  @param idx id
 *

 */
- (void)commonCameraViewButtonDidClickWithIndex:(NSInteger)idx{
    
    if (idx == 10) {
         [self cancelCameraTakePicture];
        
    } else if (idx == 20) {
        [self cameraTakePicture];
        NSLog(@"**%ld**",(long)self.flashId);
    } else if (idx == 30) {
        self.deviceType=!self.deviceType;
        [self setCameraDeviceWithType:self.deviceType];
    } else if (idx == 40||idx == 41||idx == 42) {
       [self setCameraFlashMode:idx-40];
    } else if (idx == 50) {
        NSLog(@"--%ld--",(long)self.flashId);
        [self viewSetUp];
        [self.cameraView retakePhoto];
        [self addPromptViews];
        if(self.delegate&&[self.delegate respondsToSelector:@selector(commonCameraDidRetake:)]){
            [self.delegate commonCameraDidRetake:self];
        }
        [self createNavigationItemWithType:1 andWithImageIndex:self.flashId];
        [self setCameraDeviceWithType:self.deviceType];
        [self commonCameraViewButtonDidClickWithIndex:self.flashId+40];
        
    }else if (idx == 60) {
        [self completeCameraTakePicture];
    }
}

/**
 *  设置闪光灯模式
 *  UIImagePickerControllerCameraFlashModeAuto 自动
 *  UIImagePickerControllerCameraFlashModeOn 打开
 *  UIImagePickerControllerCameraFlashModeOff 关闭
 *
 *  @param type 相机闪光灯模式 0关闭 1打开 2自动
 */
- (void)setCameraFlashMode:(NSInteger)type{
    if (type == 2) {
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
       
    } else if (type == 1) {
         self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        
    } else if (type == 0) {
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
}

/**
 *  设置摄像头模式
 *  UIImagePickerControllerCameraDeviceRear 后置摄像头
 *  UIImagePickerControllerCameraDeviceFront 前置摄像头
 *
 *  @param type 类型为相机的UIImagePickerController
 */
- (void)setCameraDeviceWithType:(BOOL )type{
    
    //前后置摄像头
    if (type) {
         self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    } else {
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
       
    }
    
}

/**
 *  拍照
 *
 */
- (void)cameraTakePicture {
    [self.imagePicker takePicture];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(commonCameraDidTakePhoto:)]){
        [self.delegate commonCameraDidTakePhoto:self];
    }
}

/**
 *  取消拍照
 */
- (void)cancelCameraTakePicture {
    [self removePromptView];

    [self returnHandler];
    
}

/**
 *  完成拍照
 */
- (void)completeCameraTakePicture {
    UIImage *image;
    if(self.style.isEdit){
        UIGraphicsBeginImageContext(self.cameraView.editView.bounds.size);
        CGContextRef context=UIGraphicsGetCurrentContext();
        
        [self.cameraView.editView.layer renderInContext:context];
        
        image=UIGraphicsGetImageFromCurrentImageContext();
        image=[self cropImage:image WithRect:self.cameraView.editCropView.frame];
    }else{
        image=self.cameraView.editImageView.image;
    }
    
    if(self.delegate&&[self.delegate respondsToSelector:@selector(commonCamera: didFinishWithImage:)]){
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate commonCamera:self  didFinishWithImage:image];
        }];
        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 图片剪切

 @param srcImage 图片
 @param rect 剪切尺寸
 @return 图片
 */
-(UIImage*)cropImage:(UIImage*)srcImage WithRect:(CGRect)rect
{
    CGImageRef cr = CGImageCreateWithImageInRect(srcImage.CGImage, rect);
    UIImage* cropped = [UIImage imageWithCGImage:cr];
    
    CGImageRelease(cr);
    return cropped;
}
#pragma mark 隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    
    if(self.style.isEdit){
        [self createNavigationItemWithType:0 andWithImageIndex:self.flashId];
        [self.cameraView takePhotoSucess];
        
        
        self.cameraView.origeImage=originalImage;
        self.cameraView.editImageView.image=originalImage;
       [self.imagePicker.view removeFromSuperview];
       [self.imagePicker removeFromParentViewController];
        [self removePromptView];
    }else{
        [self createNavigationItemWithType:0 andWithImageIndex:self.flashId];
        [self.cameraView takePhotoSucess];
        
        self.cameraView.origeImage=originalImage;
        self.cameraView.editImageView.image=originalImage;
        [self.imagePicker.view removeFromSuperview];
        [self.imagePicker removeFromParentViewController];
        [self removePromptView];
//        if(self.delegate&&[self.delegate respondsToSelector:@selector(commonCameraImage:)]){
//            [self.delegate commonCameraImage:originalImage];
//        }
//        [self returnHandler];
    }
    if(originalImage.size.height<originalImage.size.width){
        CGFloat height=kWidth/kHeight*kWidth;
        self.cameraView.editImageView.frame=CGRectMake(0, (self.cameraView.editView.frame.size.height-height)*0.5, kWidth, height);
    }
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(commonCameraDidCanceled:)]){
        [self.delegate commonCameraDidCanceled:self];
    }
}
#pragma mark get
-(HGBCommonCameraStyle *)style{
    if(_style==nil){
        _style=[[HGBCommonCameraStyle alloc]init];
        _style.isEdit=NO;
        _style.cropSize=CGSizeMake(kWidth, kWidth);
    }
    return _style;
}
-(NSMutableArray *)promptViewArray{
    if(_promptViewArray==nil){
        _promptViewArray=[NSMutableArray array];
    }
    return _promptViewArray;
}
-(NSMutableArray *)promptViewCopyArray{
    if(_promptViewCopyArray==nil){
        _promptViewCopyArray=[NSMutableArray array];
    }
    return _promptViewCopyArray;
}
@end
