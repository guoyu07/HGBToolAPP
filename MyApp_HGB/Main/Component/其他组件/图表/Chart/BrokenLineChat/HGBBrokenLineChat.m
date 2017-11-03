//
//  HGBBrokenLineChat.m
//  测试
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBrokenLineChat.h"

#import "HGBBrokenLineLayer.h"

#import "HGBEndPointButton.h"

#define FONT(x) [UIFont systemFontOfSize:x]

#define MARGIN_LEFT 35              // 统计图的左间隔
#define MARGIN_TOP 50               // 统计图的顶部间隔
#define MARGIN_BETWEEN_X_POINT 50   // X轴的坐标点的间距
#define Y_SECTION 5                 // 纵坐标轴的区间数

#define MASKPATH_TAG 20000

@interface HGBBrokenLineChat()<HGBEndPointButtonDelegate>
@end
@implementation HGBBrokenLineChat

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

    self.perXValue = self.maxXValue / self.xSectionNum;
    self.perYValue = self.maxYValue / self.ySectionNum;

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
     * 折线图
     */
    // add xValue
    for (NSInteger i = 1; i <= self.xSectionNum; i ++) {
        NSString *xValue = [NSString stringWithFormat:@"%.2f", self.perXValue * i];
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

    HGBBrokenLineLayer *linelayer = [HGBBrokenLineLayer layer];
    linelayer.lineCap = kCALineCapRound;
    linelayer.lineJoin = kCALineJoinBevel;
    linelayer.lineWidth = 0.5f;
    linelayer.strokeColor = self.lineColor.CGColor;
    linelayer.fillColor = [UIColor clearColor].CGColor;

    CGMutablePathRef linepath = CGPathCreateMutable();
    for (NSInteger i = 0; i < self.dataArray.count - 1; i ++) {
        HGBBrokenLineValue *startValue = self.dataArray[i];
        HGBBrokenLineValue *endValue   = self.dataArray[i + 1];

        CGPathMoveToPoint(linepath, &CGAffineTransformIdentity, [self getFrameX:startValue.x], [self getFrameY:startValue.y]);
        CGPathAddLineToPoint(linepath, &CGAffineTransformIdentity, [self getFrameX:endValue.x], [self getFrameY:endValue.y]);
    }
    linelayer.path = linepath;
    [self.layer addSublayer:linelayer];
    CGPathRelease(linepath);

    if (self.animation) {
        [linelayer addAnimationForKeypath:@"strokeEnd" fromValue:0 toValue:1 duration:self.duration delegate:self];
    }

    if (self.needCloud) {
        CAShapeLayer *cloudlayer = [CAShapeLayer layer];
        cloudlayer.lineCap = kCALineCapRound;
        cloudlayer.lineJoin = kCALineJoinMiter;
        cloudlayer.lineWidth = 0.f;
        cloudlayer.strokeColor = [UIColor clearColor].CGColor;
        cloudlayer.fillColor = self.cloudColor.CGColor;
        cloudlayer.fillMode = kCAFillModeForwards;
        cloudlayer.fillRule = kCAFillRuleEvenOdd;
        cloudlayer.frame = rect;

        CGMutablePathRef cloudpath = CGPathCreateMutable();

        HGBBrokenLineValue *firstValue = self.dataArray.firstObject;
        CGPathMoveToPoint(cloudpath, &CGAffineTransformIdentity, [self getFrameX:firstValue.x], [self getFrameY:firstValue.y]);

        for (NSInteger i = 0; i < self.dataArray.count; i ++) {
            HGBBrokenLineValue *startValue = self.dataArray[i];
            CGPathAddLineToPoint(cloudpath, &CGAffineTransformIdentity, [self getFrameX:startValue.x], [self getFrameY:startValue.y]);
        }

        HGBBrokenLineValue *lastValue = self.dataArray.lastObject;
        CGPathAddLineToPoint(cloudpath, &CGAffineTransformIdentity, [self getFrameX:lastValue.x], [self getFrameY:0]);
        CGPathAddLineToPoint(cloudpath, &CGAffineTransformIdentity, [self getFrameX:firstValue.x], [self getFrameY:0]);
        CGPathAddLineToPoint(cloudpath, &CGAffineTransformIdentity, [self getFrameX:firstValue.x], [self getFrameY:firstValue.y]);

        cloudlayer.path = cloudpath;
        [self.layer addSublayer:cloudlayer];
        CGPathRelease(cloudpath);
    }
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
 * x坐标轴 label 添加
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


#pragma mark buttondelegate
-(void)endPointButtonDidClicked:(HGBEndPointButton *)button{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(brokenLineChat:didClickWithValue:)]){
        [self.delegate brokenLineChat:self didClickWithValue:button.userInfo];
    }
}
#pragma mark 刷新
-(void)updateWithDataSource:(NSArray *)dataArray{
    self.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray arrayWithArray:dataArray];
    [self getMaxValue:dataArray];
    [self setNeedsDisplay];
}

#pragma mark 动画
/// CAAnimation Delegate
- (void)animationDidStart:(CAAnimation *)anim {

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.showPoint) {
        [self.dataArray enumerateObjectsUsingBlock:^(HGBBrokenLineValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HGBEndPointButton *button = [HGBEndPointButton defaultRadius:2.5 center:CGPointMake([self getFrameX:obj.x], [self getFrameY:obj.y]) userInfo:obj delegate:self];
            button.circleColor = [UIColor redColor];
            [self addSubview:button];
        }];
    }
}
#pragma mark func-get
// Get Max Value
- (void)getMaxValue:(NSArray *)dataArray {
    self.maxXValue = 0;
    self.maxYValue = 0;
    NSInteger i=0;
    for (HGBBrokenLineValue *value in self.dataArray) {
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
    return (_xSectionNum != 0) ? _xSectionNum : 10;
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
- (UIColor *)lineColor {
    return _lineColor ? _lineColor : [UIColor redColor];
}

- (UIColor *)cloudColor {
    return _cloudColor ? _cloudColor : [UIColor colorWithWhite:0.75 alpha:0.5];
}

@end
