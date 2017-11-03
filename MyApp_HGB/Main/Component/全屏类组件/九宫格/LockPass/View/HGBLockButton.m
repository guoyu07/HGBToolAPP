//
//  HGBLockButton.m
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/23.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBLockButton.h"
#import "HGBLockPassHeader.h"

@implementation HGBLockButton

/** 使用文件创建会调用 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initLockButton];
    }
    return self;
}

/** 使用代码创建会调用 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initLockButton];
    }
    return self;
}

/** 初始化 */
- (void) initLockButton {
    // 取消交互事件（点击）
    self.userInteractionEnabled = NO;
    
    // 设置普通状态图片
    [self setBackgroundImage:[UIImage imageNamed:@"HGBLockPass.bundle/gesture_node_normal"] forState:UIControlStateNormal];
    
    // 设置选中状态图片
    [self setBackgroundImage:[UIImage imageNamed:@"HGBLockPass.bundle/gesture_node_highlighted"] forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 可触碰范围
    CGFloat touchWidth =kWidth*0.2;
    CGFloat touchHeight = kWidth*0.2;
    CGFloat touchX = self.center.x - touchWidth/2;
    CGFloat touchY = self.center.y - touchHeight/2;
    self.touchFrame = CGRectMake(touchX, touchY,touchWidth, touchHeight);
}
@end
