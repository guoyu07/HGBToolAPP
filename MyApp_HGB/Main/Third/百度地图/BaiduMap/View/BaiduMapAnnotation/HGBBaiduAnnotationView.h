//
//  HGBBaiduAnnotationView.h
//  测试
//
//  Created by huangguangbao on 2017/10/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBBaiduMapActionLabel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#pragma mark 定位代理
@protocol HGBBaiduAnnotationViewDelegate <NSObject>
//获取地理位置
-(void)annotationButtonActionWithIndex:(NSInteger)index;
@end

@interface HGBBaiduAnnotationView: BMKAnnotationView
@property(strong,nonatomic)id<HGBBaiduAnnotationViewDelegate>delegate;
@property(strong,nonatomic)UIView *promtView;
@property(strong,nonatomic)HGBBaiduMapActionLabel *titleLab;
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end

