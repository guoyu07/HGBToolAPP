//
//  HGBCustomKeyBordButton.m
//  Keyboard
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCustomKeyBordButton.h"

@implementation HGBCustomKeyBordButton

+ (HGBCustomKeyBordButton *)buttonWithTitle:(NSString *)title tag:(NSInteger)tag delegate:(id)delegate{
    HGBCustomKeyBordButton *btn = [HGBCustomKeyBordButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:btn action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.delegate = delegate;
    
    return btn;
}
-(void)btnClick:(HGBCustomKeyBordButton *)_b{
    if ([_b.delegate respondsToSelector:@selector(keyboardButtonDidClick:)]) {
        [_b.delegate keyboardButtonDidClick:_b];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
@end
