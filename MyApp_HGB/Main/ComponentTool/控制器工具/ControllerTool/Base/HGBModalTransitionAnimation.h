//
//  HGBModalTransitionAnimation.h
//  测试
//
//  Created by huangguangbao on 2017/6/29.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    
    HGBAnimationTypePresent,
    
    HGBAnimationTypeDismiss
    
} HGBAnimationType;

@interface HGBModalTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>
/**
 动画类型
 */
@property (nonatomic, assign) HGBAnimationType animationType;

@end
