//
//  HGBScanView.m
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/8.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBScanView.h"
@interface HGBScanView()

/**
 扫码区域各种参数
 */
@property (nonatomic, strong) HGBScanViewStyle* viewStyle;


/**
 扫码区域
 */
@property (nonatomic,assign)CGRect scanRetangleRect;
/**
 扫码区域背景
 */
@property (nonatomic, strong) UIView *scanBackView;

/**
 扫码区域背景图片
 */
@property (nonatomic, strong) UIImageView *scanBackImgView;
/**
 线条扫码动画封装
 */
@property (nonatomic,strong)HGBScanLineAnimation *scanLineAnimation;
/**
 网格扫码动画封装
 */
@property (nonatomic,strong)HGBScanNetAnimation *scanNetAnimation;

/**
 线条在中间位置，不移动
 */
@property (nonatomic,strong)UIImageView *scanLineStill;

/**
 @brief  启动相机时 菊花等待
 */
@property(nonatomic,strong)UIActivityIndicatorView* activityView;

/**
 @brief  启动相机中的提示文字
 */
@property(nonatomic,strong)UILabel *labelReadying;



@end
@implementation HGBScanView

-(id)initWithFrame:(CGRect)frame style:(HGBScanViewStyle*)style
{
    if (self = [super initWithFrame:frame])
    {
        self.viewStyle = style;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [self drawScanRect];
    
}


- (void)startDeviceReadyingWithText:(NSString*)text
{
    int XRetangleLeft = _viewStyle.xScanRetangleOffset;
    
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - XRetangleLeft*2, self.frame.size.width - XRetangleLeft*2);
    
    if (!_viewStyle.isNeedShowRetangle) {
        
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / _viewStyle.whRatio;
        
        NSInteger hInt = (NSInteger)h;
        h  = hInt;
        
        sizeRetangle = CGSizeMake(w, h);
    }
    
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0 - _viewStyle.centerUpOffset;
    
    //设备启动状态提示
    if (!_activityView)
    {
        self.activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_activityView setCenter:CGPointMake(XRetangleLeft +  sizeRetangle.width/2 - 50, YMinRetangle + sizeRetangle.height/2)];
        
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:_activityView];
        
        CGRect labelReadyRect = CGRectMake(_activityView.frame.origin.x + _activityView.frame.size.width + 10, _activityView.frame.origin.y, 100, 30);
        self.labelReadying = [[UILabel alloc]initWithFrame:labelReadyRect];
        _labelReadying.backgroundColor = [UIColor clearColor];
        _labelReadying.textColor  = [UIColor whiteColor];
        _labelReadying.font = [UIFont systemFontOfSize:18.];
        _labelReadying.text = text;
        
        [self addSubview:_labelReadying];
        
        [_activityView startAnimating];
    }
    
}

- (void)stopDeviceReadying
{
    if (_activityView) {
        
        [_activityView stopAnimating];
        [_activityView removeFromSuperview];
        [_labelReadying removeFromSuperview];
        
        self.activityView = nil;
        self.labelReadying = nil;
    }
}


/**
 *  开始扫描动画
 */
- (void)startScanAnimation
{
    switch (_viewStyle.anmiationStyle)
    {
        case HGBScanViewAnimationStyle_LineMove:
        {
            //线动画
            if (!_scanLineAnimation)
                self.scanLineAnimation = [[HGBScanLineAnimation alloc]init];
            [_scanLineAnimation startAnimatingWithRect:_scanRetangleRect InView:self Image:_viewStyle.animationImage];
        }
            break;
        case HGBScanViewAnimationStyle_NetGrid:
        {
            //网格动画
            if (!_scanNetAnimation)
                self.scanNetAnimation = [[HGBScanNetAnimation alloc]init];
            if(self.viewStyle.HorizontalScan){
                [_scanNetAnimation startAnimatingWithRect:_scanRetangleRect InView:self Image:_viewStyle.animationImage andWithDirection:1];
            }else{
                [_scanNetAnimation startAnimatingWithRect:_scanRetangleRect InView:self Image:_viewStyle.animationImage andWithDirection:0];
            }
            
        }
            break;
        case HGBScanViewAnimationStyle_LineStill:
        {
            if (!_scanLineStill) {
                
                CGRect stillRect = CGRectMake(_scanRetangleRect.origin.x+20,
                                              _scanRetangleRect.origin.y + _scanRetangleRect.size.height/2,
                                              _scanRetangleRect.size.width-40,
                                              2);
                _scanLineStill = [[UIImageView alloc]initWithFrame:stillRect];
                _scanLineStill.image = _viewStyle.animationImage;
            }
            [self addSubview:_scanLineStill];
        }
            
        default:
            break;
    }
    
}



/**
 *  结束扫描动画
 */
- (void)stopScanAnimation
{
    if (_scanLineAnimation) {
        [_scanLineAnimation stopAnimating];
    }
    
    if (_scanNetAnimation) {
        [_scanNetAnimation stopAnimating];
    }
    
    if (_scanLineStill) {
        [_scanLineStill removeFromSuperview];
    }
}


- (void)drawScanRect
{
    int XRetangleLeft = _viewStyle.xScanRetangleOffset;
    
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - XRetangleLeft*2, self.frame.size.width - XRetangleLeft*2);
    
    //if (!_viewStyle.isScanRetangelSquare)
    if (_viewStyle.whRatio != 1)
    {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / _viewStyle.whRatio;
        
        NSInteger hInt = (NSInteger)h;
        h  = hInt;
        
        sizeRetangle = CGSizeMake(w, h);
    }
    
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0 - _viewStyle.centerUpOffset;
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
    CGFloat XRetangleRight = self.frame.size.width - XRetangleLeft;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //非扫码区域半透明
    {
        //设置非识别区域颜色
        CGContextSetRGBFillColor(context, _viewStyle.red_notRecoginitonArea, _viewStyle.green_notRecoginitonArea,_viewStyle.blue_notRecoginitonArea, _viewStyle.alpa_notRecoginitonArea);
        
        //填充矩形
        
        //扫码区域上面填充
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, YMinRetangle);
        CGContextFillRect(context, rect);
        
        
        //扫码区域左边填充
        rect = CGRectMake(0, YMinRetangle, XRetangleLeft,sizeRetangle.height);
        CGContextFillRect(context, rect);
        
        //扫码区域右边填充
        rect = CGRectMake(XRetangleRight, YMinRetangle, XRetangleLeft,sizeRetangle.height);
        CGContextFillRect(context, rect);
        
        //扫码区域下面填充
        rect = CGRectMake(0, YMaxRetangle, self.frame.size.width,self.frame.size.height - YMaxRetangle);
        CGContextFillRect(context, rect);
        //执行绘画
        CGContextStrokePath(context);
    }
    
    if (_viewStyle.isNeedShowRetangle)
    {
        //中间画矩形(正方形)
        CGContextSetStrokeColorWithColor(context, _viewStyle.colorRetangleLine.CGColor);
        CGContextSetLineWidth(context, 1);
        
        CGContextAddRect(context, CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height));
        
        
        CGContextStrokePath(context);
        
    }
    _scanRetangleRect = CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);
    
    self.scanBackView.frame = _scanRetangleRect;
    
    self.scanBackImgView.frame = CGRectMake(_scanRetangleRect.origin.x+_scanRetangleRect.size.width*0.3295,_scanRetangleRect.origin.y+_scanRetangleRect.size.height*0.1909, _scanRetangleRect.size.width*0.341,_scanRetangleRect.size.height*0.6182);
    [self addSubview:self.scanBackImgView];
    //画矩形框4格外围相框角
    
    //相框角的宽度和高度
    int wAngle = _viewStyle.photoframeAngleW;
    int hAngle = _viewStyle.photoframeAngleH;
    
    //4个角的 线的宽度
    CGFloat linewidthAngle = _viewStyle.photoframeLineW;// 经验参数：6和4
    
    //画扫码矩形以及周边半透明黑色坐标参数
    CGFloat diffAngle = 0.0f;
    //diffAngle = linewidthAngle / 2; //框外面4个角，与框有缝隙
    //diffAngle = linewidthAngle/2;  //框4个角 在线上加4个角效果
    //diffAngle = 0;//与矩形框重合
    
    switch (_viewStyle.photoframeAngleStyle)
    {
        case HGBScanViewPhotoframeAngleStyle_Outer:
        {
            diffAngle = linewidthAngle/3;//框外面4个角，与框紧密联系在一起
        }
            break;
        case HGBScanViewPhotoframeAngleStyle_On:
        {
            diffAngle = 0;
        }
            break;
        case HGBScanViewPhotoframeAngleStyle_Inner:
        {
            diffAngle = -_viewStyle.photoframeLineW/2;
            
        }
            break;
            
        default:
        {
            diffAngle = linewidthAngle/3;
        }
            break;
    }
    
    CGContextSetStrokeColorWithColor(context, _viewStyle.colorAngle.CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, linewidthAngle);
    
    
    //
    CGFloat leftX = XRetangleLeft - diffAngle;
    CGFloat topY = YMinRetangle - diffAngle;
    CGFloat rightX = XRetangleRight + diffAngle;
    CGFloat bottomY = YMaxRetangle + diffAngle;
    
    //左上角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, leftX + wAngle, topY);
    
    //左上角垂直线
    CGContextMoveToPoint(context, leftX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, topY+hAngle);
    
    
    //左下角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, leftX + wAngle, bottomY);
    
    //左下角垂直线
    CGContextMoveToPoint(context, leftX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, bottomY - hAngle);
    
    
    //右上角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, rightX - wAngle, topY);
    
    //右上角垂直线
    CGContextMoveToPoint(context, rightX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, topY + hAngle);
    
    
    //右下角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, rightX - wAngle, bottomY);
    
    //右下角垂直线
    CGContextMoveToPoint(context, rightX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, bottomY - hAngle);
    
    CGContextStrokePath(context);
}



//根据矩形区域，获取识别区域
+ (CGRect)getScanRectWithPreView:(UIView*)view style:(HGBScanViewStyle*)style
{
    int XRetangleLeft = style.xScanRetangleOffset;
    CGSize sizeRetangle = CGSizeMake(view.frame.size.width - XRetangleLeft*2, view.frame.size.width - XRetangleLeft*2);
    
    if (style.whRatio != 1)
    {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / style.whRatio;
        
        NSInteger hInt = (NSInteger)h;
        h  = hInt;
        
        sizeRetangle = CGSizeMake(w, h);
    }
    
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = view.frame.size.height / 2.0 - sizeRetangle.height/2.0 - style.centerUpOffset;
    //扫码区域坐标
    CGRect cropRect =  CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);
    
    
    //计算兴趣区域
    CGRect rectOfInterest;
    
    //ref:http://www.cocoachina.com/ios/20141225/10763.html
    CGSize size = view.bounds.size;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                    cropRect.origin.x/size.width,
                                    cropRect.size.height/fixHeight,
                                    cropRect.size.width/size.width);
        
        
    } else {
        CGFloat fixWidth = size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                    (cropRect.origin.x + fixPadding)/fixWidth,
                                    cropRect.size.height/size.height,
                                    cropRect.size.width/fixWidth);
        
        
    }
    
    
    return rectOfInterest;
}
#pragma mark - getter
- (UIImageView *)scanBackImgView {
    if (_scanBackImgView == nil) {
        _scanBackImgView = [[UIImageView alloc] init];
        if(self.viewStyle.promptImage){
            _scanBackImgView.image = self.viewStyle.promptImage;
        }
    }
    return _scanBackImgView;
}

- (UIView *)scanBackView {
    if (_scanBackView == nil) {
        _scanBackView = [[UIView alloc]init];
        _scanBackView.backgroundColor = [UIColor whiteColor];
        _scanBackView.alpha = 0;
    }
    return _scanBackView;
}
@end
