//
//  HGBCommonCameraView.m
//  CTTX
//
//  Created by huangguangbao on 2017/3/20.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCommonCameraView.h"
#import "HGBCommonCameraHeader.h"
@interface HGBCommonCameraView()<UIGestureRecognizerDelegate>
/**
 拍照前底部view
 */
@property(strong,nonatomic)UIView *beforeBottomView;

/**
 拍照按钮
 */
@property(strong,nonatomic)UIButton *takePhotoButton;
/**
 取消按钮
 */
@property(strong,nonatomic)UIButton *cancelButton;

/**
 摄像头转换按钮
 */
@property(strong,nonatomic)UIButton *transCameraButton;

/**
 拍照后底部view
 */
@property(strong,nonatomic)UIView *endBottomView;

/**
 重拍按钮
 */
@property(strong,nonatomic)UIButton *reTakeButton;
/**
 完成按钮
 */
@property(strong,nonatomic)UIButton *completeButton;
/**
 移动位置
 */
@property (assign,nonatomic)CGFloat preX,preY;
/**
  放大比例
 */
@property (assign,nonatomic)CGFloat scale;


@end
@implementation HGBCommonCameraView
#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewSetUp];
    }
    return self;
}
#pragma mark view
-(void)viewSetUp{
    self.backgroundColor=[UIColor whiteColor];
    [self setBeforeView];
}
-(void)cleanView{
   
    if([self.endBottomView superview]){
        [self.endBottomView removeFromSuperview];
    }
    
    if([self.editView superview]){
        [self.editView removeFromSuperview];
    }
   
    if([self.beforeBottomView superview]){
        [self.beforeBottomView removeFromSuperview];
    }
    if([self.showView superview]){
        [self.showView removeFromSuperview];
    }
}
#pragma mark beforeview
-(void)setBeforeView{
    [self cleanView];
    /*--------------显示--------------*/
    //显示图
    self.showView=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, kHeight-144)];
    
    [self addSubview:self.showView];
    
    
    
    /*--------------底部--------------*/
    self.beforeBottomView=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-144, kWidth, 100)];
    self.beforeBottomView.backgroundColor=[UIColor blackColor];
    [self addSubview:self.beforeBottomView];
    
    
    //取消按钮
    CGFloat w_c=[self widthForString:@"取消" fontSize:42*hScale andheight:96*hScale]+30*wScale;
    self.cancelButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.cancelButton.frame=CGRectMake(30*wScale,(100-96*hScale)*0.5, w_c,96*hScale);
    [self.cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    self.cancelButton.titleLabel.font=[UIFont boldSystemFontOfSize:36*hScale];
    [self.cancelButton addTarget:self action:@selector(camerabuttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.cancelButton.tag=10;
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.beforeBottomView addSubview:self.cancelButton];
    
    
    //拍照按钮
    self.takePhotoButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.takePhotoButton.frame=CGRectMake((kWidth-70)*0.5,15, 70,70);
    [self.takePhotoButton addTarget:self action:@selector(camerabuttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.takePhotoButton.tag=20;
    [self.takePhotoButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_takephoto_normal"] forState:(UIControlStateNormal)];
    [self.takePhotoButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_takephoto_presss"] forState:(UIControlStateHighlighted)];
    [self.beforeBottomView addSubview:self.takePhotoButton];
    
    
    
    //相机按钮
    self.transCameraButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.transCameraButton addTarget:self action:@selector(camerabuttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.transCameraButton.frame=CGRectMake(kWidth-60-30*wScale,20, 60,60);
    self.transCameraButton.tag=30;
    [self.transCameraButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_camera_normal"] forState:(UIControlStateNormal)];
    [self.transCameraButton setBackgroundImage:[UIImage imageNamed:@"HGBCommonCameraBundle.bundle/commonCamera_flash_camera_pressed"] forState:(UIControlStateHighlighted)];
    [self.beforeBottomView addSubview:self.transCameraButton];
    
    
   
}

#pragma mark endview
-(void)setEndView{
    [self cleanView];
    
    
    /*--------------编辑--------------*/
    
    //编辑图片
    self.editView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-144)];
    self.editView.backgroundColor=[UIColor blackColor];
    [self addSubview:self.editView];
    
    
    self.editImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-144)];
    self.editImageView.userInteractionEnabled=YES;
    [self.editView addSubview:self.editImageView];
    
    
    
    
    
    if(self.style.isEdit){
        self.scale=1;
        self.preY=0;
        self.preX=0;
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
        pinch.delegate=self;
        
        [self.editView addGestureRecognizer:pinch];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
        pan.delegate=self;
        [self.editView addGestureRecognizer:pan];
        
        [self makeCropRectWithView:self.editView];
    }
    
    
    /*--------------底部--------------*/
    self.endBottomView=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-144, kWidth, 100)];
    self.endBottomView.backgroundColor=[UIColor blackColor];
    [self addSubview:self.endBottomView];
    
    
    //重拍按钮
    CGFloat w_r=[self widthForString:@"重拍" fontSize:42*hScale andheight:96*hScale]+30*wScale;
    self.reTakeButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.reTakeButton.frame=CGRectMake(30*wScale,(80-96*hScale)*0.5, w_r,96*hScale);
    [self.reTakeButton setTitle:@"重拍" forState:(UIControlStateNormal)];
    self.reTakeButton.titleLabel.font=[UIFont boldSystemFontOfSize:36*hScale];
    [self.reTakeButton addTarget:self action:@selector(camerabuttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.reTakeButton.tag=50;
    [self.reTakeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.endBottomView addSubview:self.reTakeButton];
    
    
    //使用按钮
    CGFloat w_u=[self widthForString:@"使用照片" fontSize:42*hScale andheight:96*hScale]+30*wScale;
    self.completeButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.completeButton.frame=CGRectMake(kWidth-30*wScale-w_u,(80-96*hScale)*0.5, w_u,96*hScale);
    [self.completeButton setTitle:@"使用照片" forState:(UIControlStateNormal)];
    self.completeButton.titleLabel.font=[UIFont boldSystemFontOfSize:36*hScale];
    [self.completeButton addTarget:self action:@selector(camerabuttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.completeButton.tag=60;
    [self.completeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.endBottomView addSubview:self.completeButton];
    
    
    
}
-(void)makeCropRectWithView:(UIView *)view
{
    
    CGRect cropRect=CGRectMake((kWidth-self.style.cropSize.width)*0.5,(CGRectGetHeight(view.frame)- self.style.cropSize.height)*0.5,self.style.cropSize.width, self.style.cropSize.height);
    if(CGRectGetHeight(view.frame)<cropRect.size.height){
        cropRect.size.height=CGRectGetHeight(view.frame);
    }
    UIColor *backCorlor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.53];
    if(self.style.cropRectColor){
        backCorlor=self.style.cropRectColor;
    }
    
    
    self.editCropView=[[UIView alloc]initWithFrame:cropRect];
    self.editCropView.backgroundColor=[UIColor clearColor];
    self.editCropView.layer.masksToBounds=YES;
    self.editCropView.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.editCropView.layer.borderWidth=1;
    [view addSubview:self.editCropView];
    
    //拍照区域上面填充
    CGRect rectT = CGRectMake(0, 0,view.frame.size.width, cropRect.origin.y);
    UIView *viewT=[[UIView alloc]initWithFrame:rectT];
    viewT.backgroundColor=backCorlor;
    [view addSubview:viewT];
    
    
    
    
    //拍照区域左边填充
    CGRect rectL = CGRectMake(0,cropRect.origin.y, cropRect.origin.x,cropRect.size.height);
    UIView *viewL=[[UIView alloc]initWithFrame:rectL];
    viewL.backgroundColor=backCorlor;
    [view addSubview:viewL];
    
    
    //拍照区域右边填充
   CGRect rectR = CGRectMake(CGRectGetMaxX(cropRect),cropRect.origin.y, cropRect.origin.x,cropRect.size.height);
    UIView *viewR=[[UIView alloc]initWithFrame:rectR];
    viewR.backgroundColor=backCorlor;
    [view addSubview:viewR];
    
    //拍照区域下面填充
    CGRect rectB = CGRectMake(0, CGRectGetMaxY(cropRect), CGRectGetWidth(view.frame),cropRect.origin.y);
    UIView *viewB=[[UIView alloc]initWithFrame:rectB];
    viewB.backgroundColor=backCorlor;
    [view addSubview:viewB];
   
    
}
#pragma mark gesture
- (void)pinchGestureDetected:(UIPinchGestureRecognizer *)recognizer
{
    
    CGFloat  baseScore=0.05;
    __block CGFloat scale0=(recognizer.scale-1)*baseScore+1;
    
   __block  CGFloat width=self.editImageView.frame.size.width*scale0;
   __block CGFloat height=self.editImageView.frame.size.height*scale0;
    
    NSLog(@"%f",scale0);
    self.preX=self.preX-self.editImageView.frame.size.width*(scale0-1)*0.5;
    self.preY=self.preY-self.editImageView.frame.size.height*(scale0-1)*0.5;
    
    self.editImageView.frame=CGRectMake(self.preX, self.preY,width,height);
    
    if(recognizer.state==UIGestureRecognizerStateEnded){
        self.scale=(scale0-1)*baseScore+1;
        if(self.editImageView.frame.size.width<self.editView.frame.size.width){
            self.scale=self.editView.frame.size.width/self.editImageView.frame.size.width;
        }
        
        
        CGFloat width2=self.editImageView.frame.size.width*self.scale;
        CGFloat height2=self.editImageView.frame.size.height*self.scale;
        
        self.preX=self.preX-self.editImageView.frame.size.width*(self.scale-1)*0.5;
        self.preY=self.preY-self.editImageView.frame.size.height*(self.scale-1)*0.5;
        
        if(self.preX>0){
            self.preX=0;
        }
        if(self.preY>0){
            self.preY=0;
        }
        
        
        self.editImageView.frame=CGRectMake(self.preX, self.preY,width2,height2);
    
    }
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    __block CGPoint point=[recognizer translationInView:self.editView];
    
    self.editImageView.frame=CGRectMake(self.preX+point.x, self.preY+point.y, self.editImageView.frame.size.width, self.editImageView.frame.size.height);
    
    if(recognizer.state==UIGestureRecognizerStateEnded){
        self.preX=self.preX+point.x;
        self.preY=self.preY+point.y;
        
        if(self.preX>0){
            self.preX=0;
        }
        if(self.preY>0){
            self.preY=0;
        }
        if((self.preX+CGRectGetWidth(self.editImageView.frame))<kWidth){
            self.preX=self.editView.frame.size.width-self.editImageView.frame.size.width;
        }
        if(self.preY+(CGRectGetHeight(self.editImageView.frame))<self.editView.frame.size.height){
            self.preY=self.editView.frame.size.height-self.editImageView.frame.size.height;
        }
        self.editImageView.frame=CGRectMake(self.preX,self.preY,self.editImageView.frame.size.width, self.editImageView.frame.size.height);
        
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
#pragma mark buttonhandle
-(void)camerabuttonHandle:(UIButton*)_b{
    NSLog(@"clicked");
    if(self.delegate&&[self.delegate respondsToSelector:@selector(commonCameraViewButtonDidClickWithIndex:)]){
        [self.delegate commonCameraViewButtonDidClickWithIndex:_b.tag];
    }
    
    
}
#pragma mark handel
/**
 重拍
 */
-(void)retakePhoto{
    [self setBeforeView];
   
}
/**
 拍照
 */
-(void)takePhotoSucess{
    [self setEndView];
}
#pragma mark 获取字符串宽高
/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (CGFloat)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGRect r = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil];
    return r.size.height;
}
/**
 @method 获取指定高度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param height 限制字符串显示区域的高度
 @result float 返回的宽度
 */
- (CGFloat)widthForString:(NSString *)value fontSize:(float)fontSize andheight:(float)height{
    CGRect r = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil];
    return r.size.width;
}
#pragma mark get
-(HGBCommonCameraStyle *)style{
    if(_style==nil){
        _style=[[HGBCommonCameraStyle alloc]init];
        _style.isEdit=YES;
        _style.cropSize=CGSizeMake(100, 100);
    }
    return _style;
}
@end
