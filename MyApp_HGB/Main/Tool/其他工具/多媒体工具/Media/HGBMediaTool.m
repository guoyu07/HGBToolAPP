//
//  HGBMediaTool.m
//  测试
//
//  Created by huangguangbao on 2017/8/8.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBMediaTool.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <AVKit/AVKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "HGBMediaImageLookTool.h"
#import "HGBMediaFileQuickLookTool.h"



#ifndef SYSTEM_VERSION
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号

#endif

#ifndef KiOS6Later
#define KiOS6Later (SYSTEM_VERSION >= 6)
#endif

#ifndef KiOS7Later
#define KiOS7Later (SYSTEM_VERSION >= 7)
#endif

#ifndef KiOS8Later
#define KiOS8Later (SYSTEM_VERSION >= 8)
#endif

#ifndef KiOS9Later
#define KiOS9Later (SYSTEM_VERSION >= 9)
#endif

#ifndef KiOS10Later
#define KiOS10Later (SYSTEM_VERSION >= 10)
#endif


/**
 多媒体类型
 */
typedef enum HGBMediaType
{
    HGBMediaTypeTorchOn,//手电筒打开
    HGBMediaTypeTorchOff,//手电筒关闭
    HGBMediaTypeCamera,//拍照
    HGBMediaTypePhotoLibrary,//相册
    HGBMediaTypeVideo,//录像
    HGBMediaTypeAudio//录音

}HGBMediaType;


/**
 权限类型
 */
typedef enum HGBAuthorityType
{
    HGBAuthorityTypeCamera,//拍照
    HGBAuthorityTypePhotoLibrary,//相册
    HGBAuthorityTypeVideo,//录像
    HGBAuthorityTypeAudio//录音

}HGBAuthorityType;

#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"


@interface HGBMediaTool()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,HGBMediaImageLookToolDelegate,HGBMediaFileQuickLookToolDelegate,UIAlertViewDelegate>
/**
 父控制器
 */
@property (strong,nonatomic)UIViewController *parent;
/**
 代理
 */
@property (assign,nonatomic)id<HGBMediaToolDelegate>delegate;
/**
 媒体类型
 */
@property(assign,nonatomic)HGBMediaType mediaType;
/**
 设备
 */
@property (strong,nonatomic)AVCaptureDevice *device;
/**
 媒体:拍照-相册-录像支持
 */
@property(strong,nonatomic)UIImagePickerController *picker;

/**
 录音器:录音
 */
@property (strong, nonatomic)AVAudioRecorder *recorder;
/**
 录音路径
 */
@property (strong, nonatomic)NSString *recorderPath;
@end


@implementation HGBMediaTool
static HGBMediaTool *instance=nil;

#pragma mark init
/**
 单例

 @return 实例
 */
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBMediaToolDelegate>)delegate
{
    if (instance==nil) {
        instance=[[HGBMediaTool alloc]init];
        instance.delegate=delegate;
        instance.parent=parent;
    }
    return instance;
}
#pragma mark 媒体调用
/**
 启动媒体

 @param mediaType 媒体类型
 */
-(void)startMediaWithMediaType:(HGBMediaType)mediaType{
    if(mediaType==HGBMediaTypeTorchOn){
        [self startOnTorch];
    }else if (mediaType==HGBMediaTypeTorchOff){
        [self startOffTorch];
    }else if (mediaType==HGBMediaTypeCamera){
        [self startCamera];
    }else if (mediaType==HGBMediaTypePhotoLibrary){
        [self startPhotoAlbum];
    }else if (mediaType==HGBMediaTypeVideo){
        [self startVideo];
    }
}
#pragma mark 手电筒
/**
 打开手电筒
 */
-(BOOL)startOnTorch{
    //获取摄像头设备
    //AVMediaTypeVideo 视频设备
    instance.device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([instance.device hasTorch]){

        //加锁
        [self.device lockForConfiguration:nil];
        //开
        [self.device setTorchMode:AVCaptureTorchModeOn];
        //解锁
        [self.device unlockForConfiguration];
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidSucessed:)]){
            [self.delegate mediaToolDidSucessed:self];
        }
        return YES;
    }else{
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didFailedWithError:)]){
            [self.delegate mediaTool:self didFailedWithError:@{ReslutCode:@(HGBMediaToolErrorTypeDevice),ReslutMessage:@"无手电筒功能－相机闪光灯!"}];
        }
         [self alertWithPrompt:@"无手电筒功能－相机闪光灯!"];
        return NO;

    }

}
/**
 关闭手电筒
 */
-(BOOL)startOffTorch{
    //加锁
    [self.device lockForConfiguration:nil];
    //关
    [self.device setTorchMode:AVCaptureTorchModeOff];
    //解锁
    [self.device unlockForConfiguration];
    self.device=nil;
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidSucessed:)]){
        [self.delegate mediaToolDidSucessed:self];
    }
    return YES;

}
#pragma mark 调用相机
/**
 调用相机
 */
-(BOOL)startCamera{
    if([self.picker.view superview]){
        [self.picker dismissViewControllerAnimated:YES completion:nil];
    }
    self.mediaType=HGBMediaTypeCamera;

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didFailedWithError:)]){
            [self.delegate mediaTool:self didFailedWithError:@{ReslutCode:@(HGBMediaToolErrorTypeDevice),ReslutMessage:@"由于您的设备暂不支持摄像头，您无法使用该功能!"}];
        }
        [self alertWithPrompt:@"由于您的设备暂不支持摄像头，您无法使用该功能!"];
        return NO;
    }else{
        self.picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        self.picker.cameraDevice=UIImagePickerControllerCameraDeviceRear;
        //设置捕获模式
        self.picker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        self.picker.delegate=self;
        if(self.withoutEdit){
            self.picker.allowsEditing=NO;
        }else{
            self.picker.allowsEditing=YES;
        }
        [self.parent presentViewController:self.picker animated:YES completion:nil];




        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didFailedWithError:)]){
                [self.delegate mediaTool:self didFailedWithError:@{ReslutCode:@(HGBMediaToolErrorTypeAuthority),ReslutMessage:@"相机权限受限!"}];
            }
            NSString *errorStr = @"应用相机权限受限,请在设置中启用";
            [self alertAuthorityWithPrompt:errorStr andWithType:HGBAuthorityTypeCamera];
            return NO;
        }
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidSucessed:)]){
        [self.delegate mediaToolDidSucessed:self];
    }
    return YES;

}
#pragma mark 调用相册
/**
 调用相册
 */
-(BOOL)startPhotoAlbum{
    if([self.picker.view superview]){
        [self.picker dismissViewControllerAnimated:YES completion:nil];
    }
    self.mediaType=HGBMediaTypePhotoLibrary;

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didFailedWithError:)]){
            [self.delegate mediaTool:self didFailedWithError:@{ReslutCode:@(HGBMediaToolErrorTypeDevice),ReslutMessage:@"由于您的设备暂不支持相册，您无法使用该功能!"}];
        }
         [self alertWithPrompt:@"由于您的设备不支持相册，您无法使用该功能!"];
        return NO;
    }else{
        self.picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        self.picker.delegate=self;
        if(self.withoutEdit){
            self.picker.allowsEditing=NO;
        }else{
            self.picker.allowsEditing=YES;
        }
        [self.parent presentViewController:self.picker animated:YES completion:nil];


#ifdef KiOS9Later
#else
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];

        if (status == kCLAuthorizationStatusRestricted || status ==kCLAuthorizationStatusDenied)
        {
            if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didFailedWithError:)]){
                [self.delegate mediaTool:self didFailedWithError:@{ReslutCode:@(HGBMediaToolErrorTypeAuthority),ReslutMessage:@"应用相册权限受限!"}];
            }
            NSString *errorStr = @"应用相册权限受限,请在设置中启用";
            [self alertAuthorityWithPrompt:errorStr andWithType:HGBAuthorityTypePhotoLibrary];
            return NO;
        }
#endif



    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidSucessed:)]){
        [self.delegate mediaToolDidSucessed:self];
    }
    return YES;

}
#pragma mark 调用录像
/**
 调用录像
 */
-(BOOL)startVideo{
    if([self.picker.view superview]){
        [self.picker dismissViewControllerAnimated:YES completion:nil];
    }
    self.mediaType=HGBMediaTypeVideo;

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didFailedWithError:)]){
            [self.delegate mediaTool:self didFailedWithError:@{ReslutCode:@(HGBMediaToolErrorTypeDevice),ReslutMessage:@"由于您的设备暂不支持摄像头，您无法使用该功能!"}];
        }
        [self alertWithPrompt:@"由于您的设备暂不支持摄像头，您无法使用该功能!"];
        return NO;
    }else{
        self.picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        self.picker.delegate=self;
        //设置录像媒体类型
        self.picker.mediaTypes=@[(NSString *)kUTTypeMovie];
        //kUTTypeVideo 有视频没声音 movie有视频有声音
        self.picker.cameraDevice=UIImagePickerControllerCameraDeviceRear;
        //视频质量
        self.picker.videoQuality=UIImagePickerControllerQualityTypeMedium;
        //设置捕获方式为视频录制
        self.picker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;
        if(self.withoutEdit){
            self.picker.editing=NO;
        }else{
            self.picker.editing=YES;
        }
        [self.parent presentViewController:self.picker animated:YES completion:nil];




        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didFailedWithError:)]){
                [self.delegate mediaTool:self didFailedWithError:@{ReslutCode:@(HGBMediaToolErrorTypeAuthority),ReslutMessage:@"应用相机权限受限!"}];
            }
            NSString *errorStr = @"应用相机权限受限,请在设置中启用";
            [self alertAuthorityWithPrompt:errorStr andWithType:HGBAuthorityTypeVideo];
            return NO;

        }
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidSucessed:)]){
        [self.delegate mediaToolDidSucessed:self];
    }
    return YES;
}
#pragma mark 录音
/**
 开始录音
 */
-(BOOL)startRecording{
    //录音文件路径
    NSString *dirPath=[[HGBMediaTool getCacheFilePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"media/%@.caf",[HGBMediaTool getSecondTimeStringSince1970]]];
    self.recorderPath=dirPath;
//    NSString *path=[dirPath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",[HGBMediaTool getHomeFilePath]] withString:@""];
    //对录音机进行配置
    NSMutableDictionary *setting=[NSMutableDictionary dictionaryWithCapacity:4];
    //设置采样率
    [setting setObject:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    //设置声道数
    [setting setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //设置采样位数
    [setting setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //设置录音质量
    [setting setObject:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    //真迹调试需要添加
    AVAudioSession *as=[AVAudioSession sharedInstance];
    [as setCategory:AVAudioSessionCategoryRecord error:nil];
    [as setActive:YES error:nil];
    //
    NSError *error;
    self.recorder=[[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:dirPath] settings:setting error:&error];
    if(error)
    {
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didFailedWithError:)]){
            [self.delegate mediaTool:self didFailedWithError:@{ReslutCode:@(HGBMediaToolErrorTypeAuthority),ReslutMessage:@"录音功能权限受限!"}];
        }
        return NO;
    }
    if([self.recorder record]){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidSucessed:)]){
            [self.delegate mediaToolDidSucessed:self];
        }
        return YES;
    }else{
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didFailedWithError:)]){
            [self.delegate mediaTool:self didFailedWithError:@{ReslutCode:@(HGBMediaToolErrorTypeError),ReslutMessage:@"录音失败!"}];
        }
        return NO;
    }
}
/**
 暂停录音
 */
-(BOOL)parseRecording{
    if(self.recorderPath){
         [self.recorder pause];
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidSucessed:)]){
            [self.delegate mediaToolDidSucessed:self];
        }
        return YES;
    }else{
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didFailedWithError:)]){
            [self.delegate mediaTool:self didFailedWithError:@{ReslutCode:@(HGBMediaToolErrorTypeError),ReslutMessage:@"录音失败!"}];
        }

        return NO;
    }
}
/**
 结束录音
 */
-(BOOL)stopRecording{
    if(self.recorderPath){

        [self.recorder stop];
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidSucessed:)]){
            [self.delegate mediaToolDidSucessed:self];
        }
        NSString *path=[self.recorderPath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",[HGBMediaTool getHomeFilePath]] withString:@""];
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didSucessSaveToCachePath:)]){
            [self.delegate mediaTool:self didSucessSaveToCachePath:path];
        }
        self.recorderPath=nil;
        instance=nil;
        return YES;
    }else{
        self.recorderPath=nil;
        instance=nil;
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didFailedWithError:)]){
            [self.delegate mediaTool:self didFailedWithError:@{ReslutCode:@(HGBMediaToolErrorTypeError),ReslutMessage:@"录音失败!"}];
        }
        return NO;
    }
}
/**
 取消录音
 */
-(BOOL)cancelRecording{
    [HGBMediaTool removeFilePath:self.recorderPath];
    self.recorderPath=nil;
    instance=nil;
    return YES;
}
#pragma mark 打开图片
/**
 查看图片

 @param parent 父控制器
 @param path 路径
 */
-(void)lookImageAtPath:(NSString *)path inParent:(UIViewController *)parent{
    if(![HGBMediaTool isExitAtFilePath:path]){
        
    }
    [HGBMediaImageLookTool setWebLookDelegate:self];
    [HGBMediaImageLookTool lookFileAtPath:path inParent:parent];
}
/**
 查看图片

 @param parent 父控制器
 @param url URL
 */
-(void)lookImageAtUrl:(NSString *)url inParent:(UIViewController *)parent{
    [HGBMediaImageLookTool setWebLookDelegate:self];
    [HGBMediaImageLookTool lookFileAtUrl:url inParent:parent];
}
#pragma mark 播放录音
/**
 查看录音

 @param parent 父控制器
 @param path 路径
 */
-(void)lookAudioAtPath:(NSString *)path inParent:(UIViewController *)parent{
    [HGBMediaFileQuickLookTool setQuickLookDelegate:self];
    [HGBMediaFileQuickLookTool lookFileAtPath:path inParent:parent];
}
/**
 查看录音

 @param parent 父控制器
 @param url URL
 */
-(void)lookAudioAtUrl:(NSString *)url inParent:(UIViewController *)parent{
    [HGBMediaFileQuickLookTool setQuickLookDelegate:self];
    [HGBMediaFileQuickLookTool lookFileAtUrl:url inParent:parent];
}
#pragma mark 播放录像

/**
 查看视频

 @param parent 父控制器
 @param path 路径
 */
-(void)lookVideoAtPath:(NSString *)path inParent:(UIViewController *)parent{
    [HGBMediaFileQuickLookTool setQuickLookDelegate:self];
    [HGBMediaFileQuickLookTool lookFileAtPath:path inParent:parent];

}
/**
 查看视频

 @param parent 父控制器
 @param url URL
 */
-(void)lookVideoAtUrl:(NSString *)url inParent:(UIViewController *)parent{
    [HGBMediaFileQuickLookTool setQuickLookDelegate:self];
    [HGBMediaFileQuickLookTool lookFileAtUrl:url inParent:parent];
}
#pragma mark ImagePickerDelegate
//拿出图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //拍照及相册
    if(self.mediaType==HGBMediaTypeCamera||self.mediaType==HGBMediaTypePhotoLibrary){
        //在图片库中获取照片
        UIImage *image;
        if(self.withoutEdit){
            image=info[UIImagePickerControllerOriginalImage];
        }else{
            image=info[UIImagePickerControllerEditedImage];
        }
        //返回图片
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didReturnImage:)]){
            [self.delegate mediaTool:self didReturnImage:image];
        }
        if(self.isSaveToCache){
            [self saveImageToCaches:image];
        }

        //保存到相册
        if(self.isSaveToAlbum){
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }else if(self.mediaType==HGBMediaTypeVideo){
        NSURL *url=info[UIImagePickerControllerMediaURL];
        if(self.isSaveToCache){
            [self saveFileToCaches:[url path]];
        }

        if(self.isSaveToAlbum){
            UISaveVideoAtPathToSavedPhotosAlbum([url pathExtension], self, @selector(video:  didFinishSavingWithError: contextInfo:),NULL);

        }
        
    }
    //隐藏选取照片控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker=nil;
    instance=nil;

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidCanceled:)]){
        [self.delegate mediaToolDidCanceled:self];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker=nil;
    instance=nil;
}
#pragma mark 保存到缓存
/**
 文件保存到缓存

 @param filePath 文件路径
 */
-(void)saveFileToCaches:(NSString *)filePath{
    NSString *dirPath=[[HGBMediaTool getCacheFilePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"media/%@",[filePath lastPathComponent]]];
    NSString *path=[dirPath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",[HGBMediaTool getHomeFilePath]] withString:@""];
    NSString *directoryPath=[dirPath stringByDeletingLastPathComponent];
    if(![HGBMediaTool isExitAtFilePath:directoryPath]){
        [HGBMediaTool createDirectoryPath:directoryPath];
    }

    [HGBMediaTool copyFilePath:filePath ToPath:dirPath];
    if([HGBMediaTool isExitAtFilePath:dirPath]){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didSucessSaveToCachePath:)]){
            [self.delegate mediaTool:self didSucessSaveToCachePath:path];
        }
    }else{
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidFailToSaveToCache:)]){
            [self.delegate mediaToolDidFailToSaveToCache:self];
        }
    }
}
/**
 图片保存到缓存

 @param image 图片
 */
-(void)saveImageToCaches:(UIImage *)image{
    NSString *dirPath=[[HGBMediaTool getCacheFilePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"media/%@.png",[HGBMediaTool getSecondTimeStringSince1970]]];
    NSString *path=[dirPath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",[HGBMediaTool getHomeFilePath]] withString:@""];
    NSString *directoryPath=[dirPath stringByDeletingLastPathComponent];
    if(![HGBMediaTool isExitAtFilePath:directoryPath]){
        [HGBMediaTool createDirectoryPath:directoryPath];
    }
    NSData *data=UIImagePNGRepresentation(image);
    [data writeToFile:dirPath atomically:YES];

    if([HGBMediaTool isExitAtFilePath:dirPath]){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didSucessSaveToCachePath:)]){

            [self.delegate mediaTool:self didSucessSaveToCachePath:path];
        }
    }else{
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidFailToSaveToCache:)]){
            [self.delegate mediaToolDidFailToSaveToCache:self];
        }
    }
}
#pragma mark 保存相册结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error){

        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidFailToSaveToAlbum:)]){
            [self.delegate mediaToolDidFailToSaveToAlbum:self];
        }

    }else{
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidSucessToSaveToAlbum:)]){
            [self.delegate mediaToolDidSucessToSaveToAlbum:self];
        }

        NSLog(@"保存成功");
    }
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error){

        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidFailToSaveToAlbum:)]){
            [self.delegate mediaToolDidFailToSaveToAlbum:self];
        }

    }else{
        if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidSucessToSaveToAlbum:)]){
            [self.delegate mediaToolDidSucessToSaveToAlbum:self];
        }

        NSLog(@"保存成功");
    }
}
#pragma mark look delegate
-(void)imageLookDidOpenSucessed:(HGBMediaImageLookTool *)imageLook{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidSucessed:)]){
        [self.delegate mediaToolDidSucessed:self];
    }

}
-(void)imageLookDidClose:(HGBMediaImageLookTool *)imageLook{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidCanceled:)]){
        [self.delegate mediaToolDidCanceled:self];
    }
}
-(void)imageLookDidOpenFailed:(HGBMediaImageLookTool *)imageLook{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didFailedWithError:)]){
        [self.delegate mediaTool:self didFailedWithError:@{ReslutCode:@(HGBMediaToolErrorTypeError),ReslutMessage:@"图片打开失败!"}];
    }

}
-(void)quickLookDidClose:(HGBMediaFileQuickLookTool *)quickLook{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidCanceled:)]){
        [self.delegate mediaToolDidCanceled:self];
    }
}
-(void)quickLookDidOpenFailed:(HGBMediaFileQuickLookTool *)quickLook{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaTool:didFailedWithError:)]){
        [self.delegate mediaTool:self didFailedWithError:@{ReslutCode:@(HGBMediaToolErrorTypeError),ReslutMessage:@"文件打开失败!"}];
    }
}
-(void)quickLookDidOpenSucessed:(HGBMediaFileQuickLookTool *)quickLook{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(mediaToolDidSucessed:)]){
        [self.delegate mediaToolDidSucessed:self];
    }
}
#pragma mark prompt
-(void)alertWithPrompt:(NSString *)prompt{
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self.parent presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:prompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alertview.tag=0;
    [alertview show];
#endif
}
-(void)alertAuthorityWithPrompt:(NSString *)prompt andWithType:(HGBAuthorityType)type{
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"权限提示" message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if(![HGBMediaTool openAppSetView]){
            [self alertWithPrompt:@"跳转失败,请在设置界面开启权限"];
        }

    }];
    [alert addAction:action1];
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action2];
    [self.parent presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:prompt delegate:self cancelButtonTitle:@"设置" otherButtonTitles:@"取消"];
     alertview.tag=1;
    [alertview show];
#endif

}
#ifdef KiOS8Later
#else
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==0){

    }else if (alertView.tag==1){
        if(buttonIndex==0){
            if(![HGBMediaTool openAppSetView]){
                [self alertWithPrompt:@"跳转失败,请在设置界面开启权限"];
            }
        }else{

        }
    }
}
#endif

/**
 打开设置界面

 @return 结果
 */
+(BOOL)openAppSetView{

    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {

#ifdef KiOS10Later
        static BOOL sucessFlag=YES;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            sucessFlag=success;
            //发出已完成的信号
            dispatch_semaphore_signal(semaphore);
        }];


        //等待执行，不会占用资源
        dispatch_semaphore_wait(semaphore, 20);
        return sucessFlag;
#else
        return [[UIApplication sharedApplication]openURL:url];
#endif
    }else{
        return NO;
    }
}
#pragma mark 获取时间
/**
 获取时间戳-秒级

 @return 秒级时间戳
 */
+ (NSString *)getSecondTimeStringSince1970
{
    NSDate* date = [NSDate date];
    NSTimeInterval interval=[date timeIntervalSince1970];  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%f", interval]; //转为字符型
    NSString *timeStr = [NSString stringWithFormat:@"%lf",[timeString doubleValue]*1000000];

    if(timeStr.length>=16){
        return [timeStr substringToIndex:16];
    }else{
        return timeStr;
    }
}

#pragma mark 文件
/**
 文件拷贝

 @param srcPath 文件路径
 @param filePath 复制文件路径
 @return 结果
 */
+(BOOL)copyFilePath:(NSString *)srcPath ToPath:(NSString *)filePath{
    if(![HGBMediaTool isExitAtFilePath:srcPath]){
        return NO;
    }
    NSString *directoryPath=[filePath stringByDeletingLastPathComponent];
    if(![HGBMediaTool isExitAtFilePath:directoryPath]){
        [HGBMediaTool createDirectoryPath:directoryPath];
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL flag=[filemanage copyItemAtPath:srcPath toPath:filePath error:nil];
    if(flag){
        return YES;
    }else{
        return NO;
    }
}

/**
 文件剪切

 @param srcPath 文件路径
 @param filePath 复制文件路径
 @return 结果
 */
+(BOOL)moveFilePath:(NSString *)srcPath ToPath:(NSString *)filePath{
    if(![HGBMediaTool isExitAtFilePath:srcPath]){
        return NO;
    }
    NSString *directoryPath=[filePath stringByDeletingLastPathComponent];
    if(![HGBMediaTool isExitAtFilePath:directoryPath]){
        [HGBMediaTool createDirectoryPath:directoryPath];
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL flag=[filemanage moveItemAtPath:srcPath toPath:filePath error:nil];
    if(flag){
        return YES;
    }else{
        return NO;
    }
}
#pragma mark 文档通用
/**
 删除文档

 @param filePath 归档的路径
 @return 结果
 */
+ (BOOL)removeFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return YES;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:filePath];
    BOOL deleteFlag=NO;
    if(isExit){
        deleteFlag=[filemanage removeItemAtPath:filePath error:nil];
    }else{
        deleteFlag=NO;
    }
    return deleteFlag;
}
/**
 文档是否存在

 @param filePath 归档的路径
 @return 结果
 */
+(BOOL)isExitAtFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:filePath];
    return isExit;
}

#pragma mark 文件夹

/**
 创建文件夹

 @param directoryPath 路径
 @return 结果
 */
+(BOOL)createDirectoryPath:(NSString *)directoryPath{
    if([HGBMediaTool isExitAtFilePath:directoryPath]){
        return YES;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];
    BOOL flag=[filemanage createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];
    if(flag){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 获取文件完整路径

/**
 将简化路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
+(NSString *)getCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    NSString *path=[simplifyFilePath copy];
    if(![HGBMediaTool isExitAtFilePath:path]){
        path=[[HGBMediaTool getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
        if(![HGBMediaTool isExitAtFilePath:path]){
            path=[[HGBMediaTool getDocumentFilePath] stringByAppendingPathComponent:simplifyFilePath];
            if(![HGBMediaTool isExitAtFilePath:path]){
                path=[[HGBMediaTool getMainBundlePath] stringByAppendingPathComponent:simplifyFilePath];
                if(![HGBMediaTool isExitAtFilePath:path]){
                    path=simplifyFilePath;
                }

            }

        }

    }
    return path;
}
#pragma mark bundle
/**
 获取主资源文件路径

 @return 主资源文件路径
 */
+(NSString *)getMainBundlePath{
    return [[NSBundle mainBundle]resourcePath];
}
#pragma mark 沙盒
/**
 获取沙盒根路径

 @return 根路径
 */
+(NSString *)getHomeFilePath{
    NSString *path_huang=NSHomeDirectory();
    return path_huang;
}
/**
 获取沙盒Document路径

 @return Document路径
 */
+(NSString *)getDocumentFilePath{
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    return path_huang;
}
/**
 获取沙盒cache路径

 @return cache路径
 */
+(NSString *)getCacheFilePath{
    //    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
    return path_huang;
}


#pragma mark get
-(UIImagePickerController *)picker{
    if(_picker==nil){
        _picker=[[UIImagePickerController alloc]init];
        _picker.delegate=self;
    }
    return _picker;
}
@end
