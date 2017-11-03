//
//  HGBNumberScrollAnimatedView.m
//  测试
//
//  Created by huangguangbao on 2017/6/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBNumberScrollAnimatedView.h"

@interface HGBNumberScrollAnimatedView ()
{
    NSMutableArray *_numbersText;       // 保存拆分出来的数字
    NSMutableArray *_scrollLayers;
    NSMutableArray *_scrollLabels;      // 保存label
}

@end
@implementation HGBNumberScrollAnimatedView

#pragma mark - Life Cycle

// 支持 frame 方式和 xib 方式 init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public Methods

- (void)reloadView
{
    [self prepareAnimations];
}

- (void)startAnimation
{
    [self createAnimations];
}

- (void)stopAnimation
{
    for (CALayer *layer in _scrollLayers) {
        [layer removeAnimationForKey:@"MSNumberScrollAnimatedView"];
    }
}

#pragma mark - Private Methods

- (void)commonInit
{
    self.duration = 1.5;
    self.durationOffset = 0.2;
    self.density = 5;
    self.minLength = 0;
    self.isAscending = NO;
    
    self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.textColor = [UIColor blackColor];
    
    _numbersText = [NSMutableArray array];
    _scrollLayers = [NSMutableArray array];
    _scrollLabels = [NSMutableArray array];
}

- (void)prepareAnimations
{
    // 先删除旧数据
    for (CALayer *layer in _scrollLayers) {
        [layer removeFromSuperlayer];
    }
    [_numbersText removeAllObjects];
    [_scrollLayers removeAllObjects];
    [_scrollLabels removeAllObjects];
    
    // 配置新的数据和UI
    [self configNumbersText];
    [self configScrollLayers];
}

- (void)configNumbersText
{
    NSString *numberStr = [_number stringValue];
    // 如果 number 长度小于 最小长度就补0
    // 这里需要注意一下 minLength 和 length 都是NSUInteger类型 如果相减得负数的话会有问题
    for (NSInteger i = 0; i < (NSInteger)self.minLength - (NSInteger)numberStr.length; i++) {
        [_numbersText addObject:@"0"];
    }
    // 取出 number 各位数
    for (NSUInteger i = 0; i < numberStr.length; i++) {
        [_numbersText addObject:[numberStr substringWithRange:NSMakeRange(i, 1)]];
    }
}

- (void)configScrollLayers
{
    // 平均分配宽度
    CGFloat width = CGRectGetWidth(self.frame) / _numbersText.count;
    CGFloat height = CGRectGetHeight(self.frame);
    // 创建和配置 scrollLayer
    for (NSUInteger i = 0; i < _numbersText.count; i++) {
        CAScrollLayer *layer = [CAScrollLayer layer];
        layer.frame = CGRectMake(i*width, 0, width, height);
        [_scrollLayers addObject:layer];
        [self.layer addSublayer:layer];
        
        NSString *numberText = _numbersText[i];
        [self configScrollLayer:layer numberText:numberText];
    }
}

- (void)configScrollLayer:(CAScrollLayer *)layer numberText:(NSString *)numberText
{
    NSInteger number = [numberText integerValue];
    NSMutableArray *scrollNumbers = [NSMutableArray array];
    // 添加要滚动的数字
    for (NSInteger i = 0; i < self.density + 1; i++) {
        [scrollNumbers addObject:[NSString stringWithFormat:@"%u", (unsigned int)((number+i) % 10)]];
    }
    [scrollNumbers addObject:numberText];
    // 创建 scrollLayer 的内容，数字降序排序
    // 修改局部变量的值需要使用 __block 修饰符
    __block CGFloat height = 0;
    [scrollNumbers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [self createLabel:text];
        label.frame = CGRectMake(0, height, CGRectGetWidth(layer.frame), CGRectGetHeight(layer.frame));
        [layer addSublayer:label.layer];
        // 保存label，防止对象被回收
        [_scrollLabels addObject:label];
        // 累加高度
        height = CGRectGetMaxY(label.frame);
    }];
}

- (UILabel *)createLabel:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    
    label.textColor = self.textColor;
    label.font = self.font;
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = text;
    
    return label;
}

- (void)createAnimations
{
    // 第一个 layer 的动画持续时间
    NSTimeInterval duration = self.duration - ((_numbersText.count-1) * self.durationOffset);
    for (CALayer *layer in _scrollLayers) {
        
        CGFloat maxY = [[layer.sublayers lastObject] frame].origin.y;
        // keyPath 是 sublayerTransform ，因为动画应用于 layer 的 subLayer。
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.y"];
        animation.duration = duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        // 滚动方向
        if (self.isAscending) {
            animation.fromValue = @0;
            animation.toValue = [NSNumber numberWithFloat:-maxY];
        } else {
            animation.fromValue = [NSNumber numberWithFloat:-maxY];
            animation.toValue = @0;
        }
        // 添加动画
        [layer addAnimation:animation forKey:@"MSNumberScrollAnimatedView"];
        // 累加动画持续时间
        duration += self.durationOffset;
    }
}

#pragma mark - Setter

- (void)setNumber:(NSNumber *)number
{
    _number = number;
    // 准备动画
    [self prepareAnimations];
}

@end
