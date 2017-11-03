//
//  HGBStarRateView.m
//  CTTX
//
//  Created by huangguangbao on 16/9/23.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import "HGBStarRateView.h"
//星星评级


#define FOREGROUND_STAR_IMAGE_NAME @"HGBStarRateViewBundle.bundle/icon_active_xichezhishu"
#define BACKGROUND_STAR_IMAGE_NAME @"HGBStarRateViewBundle.bundle/icon_dim_xichezhishu"
#define DEFALUT_STAR_NUMBER 5
#define ANIMATION_TIME_INTERVAL 0.2



@interface HGBStarRateView()
@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;

@property (nonatomic, assign) NSInteger numberOfStars;

/**
 得分值，范围为0--1，默认为1
 */
@property (nonatomic, assign) CGFloat scorePercent2;
@end
@implementation HGBStarRateView
- (instancetype)init {
    NSAssert(NO, @"You should never call this method in this class. Use initWithFrame: instead!");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfStars:DEFALUT_STAR_NUMBER];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _numberOfStars = DEFALUT_STAR_NUMBER;
        [self buildDataAndUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars {
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
        [self buildDataAndUI];
    }
    return self;
}

#pragma mark - Private Methods

- (void)buildDataAndUI {
    _scorePercent = 1;//默认为1
    _hasAnimation = NO;//默认为NO
    _allowScrapStar = NO;//默认为NO

    UIImage *foreImage,*backImage;
    if(self.selectStarImage){
        foreImage=self.selectStarImage;
    }else{
        foreImage=[UIImage imageNamed:FOREGROUND_STAR_IMAGE_NAME];
    }
    if(self.normalStarImage){
        backImage=self.normalStarImage;
    }else{
        backImage=[UIImage imageNamed:BACKGROUND_STAR_IMAGE_NAME];
    }
    self.foregroundStarView = [self createStarViewWithImage:foreImage];
    self.backgroundStarView = [self createStarViewWithImage:backImage];
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
}

- (UIView *)createStarViewWithImage:(UIImage *)image {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak HGBStarRateView *weakSelf = self;
    CGFloat animationTimeInterval = self.hasAnimation ? ANIMATION_TIME_INTERVAL : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        weakSelf.foregroundStarView.frame = CGRectMake(0, 0, weakSelf.bounds.size.width * weakSelf.scorePercent, weakSelf.bounds.size.height);
    }];
}

#pragma mark - Get and Set Methods

- (void)setScorePercent:(CGFloat)scroePercent {
    self.scorePercent2=scroePercent;
    if (_scorePercent == scroePercent) {
        return;
    }
    
    if (scroePercent < 0) {
        _scorePercent = 0;
    } else if (scroePercent > 1) {
        _scorePercent = 1;
    } else {
        _scorePercent = scroePercent;
    }
    if(_allowScrapStar==NO){
        NSInteger n=(NSInteger)( _scorePercent*self.numberOfStars);
        _scorePercent=(CGFloat)n/(CGFloat)self.numberOfStars;
    }else{
        _scorePercent=self.scorePercent2;
    }
    
    if ([self.delegate respondsToSelector:@selector(starRateView:scroePercentDidChange:)]) {
        [self.delegate starRateView:self scroePercentDidChange:_scorePercent];
    }
    
    [self setNeedsLayout];
}
-(void)setAllowScrapStar:(BOOL)allowScrapStar{
    _allowScrapStar=allowScrapStar;
    if(allowScrapStar==NO){
        NSInteger n=(NSInteger)( _scorePercent*self.numberOfStars);
        _scorePercent=(CGFloat)n/(CGFloat)self.numberOfStars;
    }else{
        _scorePercent=self.scorePercent2;
    }
    if ([self.delegate respondsToSelector:@selector(starRateView:scroePercentDidChange:)]) {
        [self.delegate starRateView:self scroePercentDidChange:_scorePercent];
    }
    [self setNeedsLayout];
}
-(void)setAllowSelector:(BOOL)allowSelector{
    _allowSelector=allowSelector;
    if(_allowSelector){
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandler:)];
        
        tap.numberOfTapsRequired=1;//单击
        tap.numberOfTouchesRequired=1;//手指数
        [self addGestureRecognizer:tap];
    }
    
}
-(void)tapHandler:(UITapGestureRecognizer *)_t
{
    CGPoint p=[_t locationInView:self];
    if(_allowSelector){
        
        CGFloat scroePercent=p.x/self.frame.size.width;
        
        if(self.allowScrapStar){
            scroePercent=p.x/self.frame.size.width;
        }else{
            scroePercent=p.x/self.frame.size.width+1.0/self.numberOfStars;
        }
        CGFloat x1=(0.2/(CGFloat)self.numberOfStars)*self.frame.size.width;
        if(p.x<x1){
            scroePercent=0;
        }
        
        CGFloat x2=(1.0/(CGFloat)self.numberOfStars)*self.frame.size.width*((self.numberOfStars-1)+0.8);
        if(p.x>x2){
            scroePercent=1;
        }
        if (scroePercent < 0) {
            _scorePercent = 0;
        } else if (scroePercent > 1) {
            _scorePercent = 1;
        } else {
            _scorePercent = scroePercent;
        }
        _scorePercent2=_scorePercent;
        if(_allowScrapStar==NO){
            NSInteger n=(NSInteger)( _scorePercent*self.numberOfStars);
            _scorePercent=(CGFloat)n/(CGFloat)self.numberOfStars;
        }else{
            _scorePercent=self.scorePercent2;
        }
        if ([self.delegate respondsToSelector:@selector(starRateView:scroePercentDidChange:)]) {
            [self.delegate starRateView:self scroePercentDidChange:_scorePercent];
        }
        [self setNeedsLayout];
        
    }
}

@end
