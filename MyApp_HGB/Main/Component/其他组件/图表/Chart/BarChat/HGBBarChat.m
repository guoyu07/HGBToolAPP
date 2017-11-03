//
//  HGBBarChat.m
//  测试
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBarChat.h"
#import "HGBBarChatLayer.h"

#define FONT(x) [UIFont systemFontOfSize:x]

#define MARGIN_LEFT 35              // 统计图的左间隔
#define MARGIN_TOP 50               // 统计图的顶部间隔
#define MARGIN_BETWEEN_X_POINT 50   // X轴的坐标点的间距
#define Y_SECTION 5                 // 纵坐标轴的区间数

#define MASKPATH_TAG 20000


@interface HGBBarChat ()

@end
@implementation HGBBarChat
#pragma mark init
/**
 初始化

 @param frame 尺寸
 @param dataArray 数据源
 @return 实体
 */
- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        [self getMaxValue:dataArray];
    }
    return self;
}
#pragma mark  绘制
- (void)drawRect:(CGRect)rect {

    if(self.perYValue==0){

        self.perYValue = self.maxYValue / self.ySectionNum;
    }
    if(self.perXValue==0){
        self.perXValue = self.maxXValue / self.xSectionNum;
    }

    CGContextRef lineContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(lineContext, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(lineContext, self.borderColor.CGColor);
    CGContextSetLineCap(lineContext, kCGLineCapButt);
    CGContextSetLineJoin(lineContext, kCGLineJoinBevel);
    CGContextSetLineWidth(lineContext, self.borderWidth);

    // 绘制横线
    for (NSInteger i = 0; i <= self.ySectionNum; i ++) {
        CGPoint startPoint = CGPointMake(MARGIN_LEFT, MARGIN_TOP + i * self.yDistance);
        CGPoint endPoint = CGPointMake(MARGIN_LEFT + self.xDistance * (self.xSectionNum + 1), MARGIN_TOP + i * self.yDistance);
        [self horizontalAddLineStartPoint:startPoint endPoint:endPoint context:lineContext];
    }

    // 绘制竖线
    for (NSInteger i = 0; i < 2; i ++) {
        CGPoint startPoint = CGPointMake(MARGIN_LEFT + i * self.xDistance * (self.xSectionNum + 1), MARGIN_TOP);
        CGPoint endPoint = CGPointMake(MARGIN_LEFT + i * self.xDistance * (self.xSectionNum + 1), MARGIN_TOP + self.yDistance * self.ySectionNum);
        [self verticalAddLineStartPoint:startPoint endPoint:endPoint context:lineContext];
    }

    /**
     * 柱状图
     */
    for (NSInteger i = 1; i <= self.xSectionNum; i ++) {
        HGBBarValue *value = self.dataArray[i - 1];
        NSString *xValue = [NSString stringWithFormat:@"%.2f", value.x];
        UILabel *xLabel = [self addXValue:xValue frame:CGRectMake(0, 0, self.xDistance, 30)];
        xLabel.center = CGPointMake(MARGIN_LEFT + i * self.xDistance, MARGIN_TOP + 10 + self.yDistance * self.ySectionNum);
        [self addSubview:xLabel];
    }

    // add yValue
    for (NSInteger i = 1; i <= self.ySectionNum; i ++) {
        NSString *yValue = [NSString stringWithFormat:@"%.2f", self.perYValue * i];
        UILabel *yLabel = [self addYValue:yValue frame:CGRectMake(0, 0, 32, 20)];
        CGPoint center = yLabel.center;
        center = CGPointMake(center.x, MARGIN_TOP + (self.ySectionNum - i) * self.yDistance);
        yLabel.center = center;
        [self addSubview:yLabel];
    }

    [self addXSectionMark:lineContext];
    CGContextStrokePath(lineContext);

    for (CALayer *sublayer in self.layer.sublayers) {
        if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
            [sublayer removeFromSuperlayer];
        }
    }

    [self.dataArray enumerateObjectsUsingBlock:^(HGBBarValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self drawBarChart:obj i:idx];
    }];
}

- (void)drawBarChart:(HGBBarValue *)value i:(NSInteger)i {
    HGBBarChatLayer *barlayer = [HGBBarChatLayer layer];
    barlayer.lineCap = kCALineCapButt;
    barlayer.lineWidth = self.barWidth;
    barlayer.fillColor = [self convertColor:value.color].CGColor;
    barlayer.strokeColor = [self convertColor:value.color].CGColor;

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, MARGIN_LEFT + (i + 1) * self.xDistance, [self getFrameY:0]);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, MARGIN_LEFT + (i + 1) * self.xDistance, [self getFrameY:value.y]);

    barlayer.path = path;
    [self.layer addSublayer:barlayer];
    CGPathRelease(path);

    if (self.animation) {
        [barlayer addAnimationForKeypath:@"strokeEnd" fromValue:0 toValue:1 duration:self.duration delegate:self];
    }

    [self addMaskClickedPath:i value:value superLayer:barlayer];

    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}



/**
 * 绘制横坐标及分割线
 */
- (void)horizontalAddLineStartPoint:(CGPoint)startPoint
                           endPoint:(CGPoint)endPoint
                            context:(CGContextRef)context {
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
}
/**
 * 绘制纵坐标及分割线
 */
- (void)verticalAddLineStartPoint:(CGPoint)startPoint
                         endPoint:(CGPoint)endPoint
                          context:(CGContextRef)context {
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
}
/**
 添加中心标记线

 @param context context
 */
- (void)addXSectionMark:(CGContextRef)context {
    for (NSInteger i = 1; i <= self.xSectionNum; i ++) {
        CGContextMoveToPoint(context, MARGIN_LEFT + i * self.xDistance, MARGIN_TOP + self.ySectionNum * self.yDistance - self.marKWidth);
        CGContextAddLineToPoint(context, MARGIN_LEFT + i * self.xDistance, MARGIN_TOP + self.ySectionNum * self.yDistance);
    }
}

/**
 * x 坐标轴 label 添加
 */
- (UILabel *)addXValue:(NSString *)xValue frame:(CGRect)frame {
    UILabel *xLabel = [[UILabel alloc] initWithFrame:frame];
    xLabel.text = xValue;
    xLabel.textAlignment = NSTextAlignmentCenter;
    xLabel.backgroundColor = [UIColor clearColor];
    xLabel.font = FONT(self.xValueFont);
    xLabel.textColor = self.xValueTextColor;
    return xLabel;
}
/**
 * y坐标轴 label 添加
 */
- (UILabel *)addYValue:(NSString *)yValue frame:(CGRect)frame {
    UILabel *yLabel = [[UILabel alloc] initWithFrame:frame];
    yLabel.text = yValue;
    yLabel.textAlignment = NSTextAlignmentRight;
    yLabel.backgroundColor = [UIColor clearColor];
    yLabel.font = FONT(self.yValueFont);
    yLabel.textColor = self.yValueTextColor;
    return yLabel;
}



- (void)addMaskClickedPath:(NSInteger)index value:(HGBBarValue *)value superLayer:(HGBBarChatLayer *)superLayer {
    HGBBarChatLayer *barlayer = [HGBBarChatLayer layer];
    barlayer.lineCap = kCALineCapButt;
    barlayer.fillColor = [UIColor clearColor].CGColor;

    barlayer.userInfo = value;
    barlayer.currenTIndex = index;
    barlayer.tag = MASKPATH_TAG;

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(MARGIN_LEFT + (index + 1) * self.xDistance - self.barWidth / 2, [self getFrameY:value.y], self.barWidth, [self getFrameY:0] - [self getFrameY:value.y]));
    barlayer.path = path;
    [self.layer addSublayer:barlayer];
    CGPathRelease(path);
}
#pragma mark 刷新
-(void)updateWithDataSource:(NSArray *)dataArray{
    self.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray arrayWithArray:dataArray];
    [self getMaxValue:dataArray];
    [self setNeedsDisplay];
}


#pragma mark touch
/// Touch Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    [self touchLayerWithPoint:point];
}

- (void)touchLayerWithPoint:(CGPoint)point {
    NSMutableArray *subbarLayers = [NSMutableArray array];
    for (CALayer *sublayer in self.layer.sublayers) {
        if ([sublayer isKindOfClass:[HGBBarChatLayer class]]) {
            if (((HGBBarChatLayer *)sublayer).tag == MASKPATH_TAG) {
                [subbarLayers addObject:sublayer];
            }
        }
    }
    

    [subbarLayers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HGBBarChatLayer *layer = (HGBBarChatLayer *)obj;
        CGPathRef path = layer.path;
        if (CGPathContainsPoint(path, &CGAffineTransformIdentity, point, NO)) {
            HGBBarValue *value=self.dataArray[idx];
            if(self.delegate&&[self.delegate respondsToSelector:@selector(barChat:didClickWithValue:)]){
                [self.delegate barChat:self didClickWithValue:value];
            }
        }
    }];
}
#pragma mark 动画
/// CAAnimation Delegate
- (void)animationDidStart:(CAAnimation *)anim {

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}
#pragma mark 颜色
/**
 转换颜色

 @param color 颜色
 @return 转换后颜色
 */
- (UIColor *)convertColor:(UIColor *)color {
    if (color != [UIColor whiteColor] && color != [UIColor clearColor] && color != nil) {
        return color;
    }
    return self.backgroundColor;
}
#pragma mark func-get
// Get Max Value
- (void)getMaxValue:(NSArray *)dataArray {
    self.maxXValue = 0;
    self.maxYValue = 0;
    NSInteger i=0;
    for (HGBBarValue *value in self.dataArray) {
        if(value.index==0){
            value.index=i;
        }
        self.maxXValue = self.maxXValue > value.x ? self.maxXValue : value.x;
        self.maxYValue = self.maxYValue > value.y ? self.maxYValue : value.y;
        i++;
    }
}
// Value Convert To Frame
- (CGFloat)getFrameX:(CGFloat)x {
    CGFloat resultX = (MARGIN_LEFT + (self.xSectionNum * self.xDistance) * (x / self.maxXValue));
    return  resultX;
}

- (CGFloat)getFrameY:(CGFloat)y {
    CGFloat resultY = (MARGIN_TOP + self.ySectionNum * self.yDistance) - ((self.ySectionNum * self.yDistance) * (y / self.maxYValue));
    return resultY;
}
#pragma mark get
// Get Default Value
- (UIColor *)xValueTextColor {
    return _xValueTextColor ? _xValueTextColor : [UIColor darkTextColor];
}

- (UIColor *)yValueTextColor {
    return _yValueTextColor ? _yValueTextColor : [UIColor darkTextColor];
}

- (CGFloat)xValueFont {
    return (_xValueFont != 0) ? _xValueFont : 9;
}

- (CGFloat)yValueFont {
    return (_yValueFont != 0) ? _yValueFont : 9;
}

- (NSInteger)xSectionNum {
    return self.dataArray.count;
}

- (NSInteger)ySectionNum {
    return (_ySectionNum != 0) ? _ySectionNum : 5;
}

- (CGFloat)xDistance {
    return (_xDistance != 0) ? _xDistance : 35;
}

- (CGFloat)yDistance {
    return (_yDistance != 0) ? _yDistance : 30;
}

- (CGFloat)marKWidth {
    return (_marKWidth != 0) ? _marKWidth : 2;
}

- (CGFloat)duration {
    return (_duration != 0) ? _duration : 2;
}

-(UIColor *)borderColor{
    return _borderColor ? _borderColor : [UIColor brownColor];
}
-(CGFloat)borderWidth{
     return _borderWidth ? _borderWidth : 0.5f;
}
- (CGFloat)barWidth {
    return _barWidth ? _barWidth : 12;
}

@end
