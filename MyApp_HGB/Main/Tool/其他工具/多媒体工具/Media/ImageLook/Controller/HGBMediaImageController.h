//
//  HGBMediaImageController.h
//  测试
//
//  Created by huangguangbao on 2017/8/23.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGBMediaImageController;
@protocol HGBMediaImageControllerDelegate <NSObject>
@optional
/**
 关闭
 */
-(void)fileImageControllerDidClosed;
@end
@interface HGBMediaImageController : UIViewController
@property(strong,nonatomic)NSString *url;
@property(assign,nonatomic)id<HGBMediaImageControllerDelegate>delegate;

@end
