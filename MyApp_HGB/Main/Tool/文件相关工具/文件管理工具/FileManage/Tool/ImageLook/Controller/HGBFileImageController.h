//
//  HGBFileImageController.h
//  测试
//
//  Created by huangguangbao on 2017/8/17.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGBFileImageController;
@protocol HGBFileImageControllerDelegate <NSObject>
@optional
/**
 关闭
 */
-(void)fileImageControllerDidClosed;
@end
@interface HGBFileImageController : UIViewController
@property(strong,nonatomic)NSString *url;
@property(assign,nonatomic)id<HGBFileImageControllerDelegate>delegate;

@end
