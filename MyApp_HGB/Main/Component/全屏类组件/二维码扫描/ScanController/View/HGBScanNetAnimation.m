//
//  HGBScanNetAnimation.m
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/8.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBScanNetAnimation.h"
@interface HGBScanNetAnimation()
{
    BOOL isAnimationing;
}

/**
 动画区域
 */
@property (nonatomic,assign) CGRect animationRect;
/**
 扫描图片
 */
@property (nonatomic,strong) UIImageView *scanImageView;
/**
 扫描方向
 */
@property (nonatomic,assign)NSInteger direction;
@end
@implementation HGBScanNetAnimation


- (instancetype)init{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        [self addSubview:self.scanImageView];
    }
    return self;
}

- (UIImageView *)scanImageView{
    if (!_scanImageView) {
        _scanImageView = [[UIImageView alloc] init];
    }
    return _scanImageView;
}

- (void)stepAnimation
{
    if (!isAnimationing) {
        return;
    }
    
    self.frame = _animationRect;
    
    if(self.direction==0){
        CGFloat scanNetImageViewW = self.frame.size.width;
        CGFloat scanNetImageH = self.frame.size.height;
        
        __weak __typeof(self) weakSelf = self;
        self.alpha = 0.5;
        _scanImageView.frame = CGRectMake(0, -scanNetImageH, scanNetImageViewW, scanNetImageH);
        [UIView animateWithDuration:2 animations:^{
            weakSelf.alpha = 1.0;
            
            _scanImageView.frame = CGRectMake(0,scanNetImageH, scanNetImageViewW, scanNetImageH);
            
        } completion:^(BOOL finished)
         {
             [weakSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
         }];
        
    }else{
        CGFloat scanNetImageViewW = self.frame.size.width;
        CGFloat scanNetImageH = self.frame.size.height;
        
        __weak __typeof(self) weakSelf = self;
        self.alpha = 0.5;
        _scanImageView.frame = CGRectMake(scanNetImageViewW,0, scanNetImageViewW, scanNetImageH);
        [UIView animateWithDuration:1.4 animations:^{
            weakSelf.alpha = 1.0;
            
            _scanImageView.frame = CGRectMake(0, 0, scanNetImageViewW, scanNetImageH);
            
        } completion:^(BOOL finished)
         {
             [weakSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
         }];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
}


- (void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView *)parentView Image:(UIImage*)image andWithDirection:(NSInteger)direction
{
    self.direction=direction;
    [self.scanImageView setImage:image];
    
    self.animationRect = animationRect;
    
    [parentView addSubview:self];
    
    self.hidden = NO;
    
    isAnimationing = YES;
    
    [self stepAnimation];
}


- (void)dealloc
{
    [self stopAnimating];
}

- (void)stopAnimating
{
    self.hidden = YES;
    isAnimationing = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
@end
