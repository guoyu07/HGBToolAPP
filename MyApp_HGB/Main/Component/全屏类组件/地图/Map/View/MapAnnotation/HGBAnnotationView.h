//
//  HGBAnnotationView.h
//  CTTX
//
//  Created by huangguangbao on 16/9/21.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "HGBMapActionLabel.h"


#pragma mark 定位代理
@protocol HGBAnnotationViewDelegate <NSObject>
//获取地理位置
-(void)annotationButtonActionWithIndex:(NSInteger)index;
@end

@interface HGBAnnotationView : MKAnnotationView
@property(strong,nonatomic)id<HGBAnnotationViewDelegate>delegate;
@property(strong,nonatomic)UIView *promtView;
@property(strong,nonatomic)HGBMapActionLabel *titleLab;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end
