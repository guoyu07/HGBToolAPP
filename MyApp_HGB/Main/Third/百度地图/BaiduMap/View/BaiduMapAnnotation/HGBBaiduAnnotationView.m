//
//  HGBBaiduAnnotationView.m
//  测试
//
//  Created by huangguangbao on 2017/10/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBaiduAnnotationView.h"
#import "HGBBaiduMapHeader.h"
@implementation HGBBaiduAnnotationView

//创建视图
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {

        float w=424*wScale,h=168*hScale,h_t=98*hScale,w_t=w,h_l=58*hScale,w_l=38*hScale;
        self.promtView=[[UIView alloc]initWithFrame:CGRectMake(0*wScale,0*hScale,w,h)];

        UIImageView *messageImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,w, h_t)];
        messageImageView.image=[UIImage imageNamed:@"HGBBaiduMapBundle.bundle/bg_label1"];
        messageImageView.alpha=0.94;
        [self.promtView addSubview:messageImageView];
        self.titleLab=[[HGBBaiduMapActionLabel  alloc]initWithFrame:CGRectMake(26*wScale,28*hScale, w-64*wScale, 26*hScale)];
        self.titleLab.text=@"title";
        self.titleLab.textAlignment=NSTextAlignmentLeft;
        self.titleLab.textColor=[UIColor colorWithRed:77.0/256 green:77.0/256 blue:77.0/256 alpha:1];;
        self.titleLab.font=[UIFont systemFontOfSize:26*hScale];
        [self.promtView addSubview:self.titleLab];


        UIButton *actionButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
        actionButton.frame=CGRectMake(0, 0,w_t, h_t);
        [actionButton addTarget:self action:@selector(actionButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.promtView addSubview:actionButton];



        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake((w-38*wScale)*0.5, h_t, w_l, h_l)];
        UIImage *myImage = [UIImage imageNamed:@"HGBBaiduMapBundle.bundle/icon_zuobiao"];
        imageV.image=myImage;
        [self.promtView addSubview:imageV];

        UIButton *actionButton2=[UIButton buttonWithType:(UIButtonTypeSystem)];
        actionButton2.frame=imageV.frame;
        [actionButton2 addTarget:self action:@selector(actionButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.promtView addSubview:actionButton2];

        [self addSubview:self.promtView];

        self.frame = CGRectMake(0, 0,w,h);
        self.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.promtView];
        self.centerOffset = CGPointMake(0*wScale,-h*0.5);

        self.canShowCallout = YES;


        UIImageView *leftAccessoryView = [[UIImageView alloc]initWithImage:myImage];
        leftAccessoryView.frame = CGRectMake(0, 0, 20, 20);
        leftAccessoryView.contentMode = UIViewContentModeScaleAspectFill;
        self.leftCalloutAccessoryView = leftAccessoryView;
        self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    return self;
}
-(void)actionButtonHandle:(UIButton *)_b{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(annotationButtonActionWithIndex:)]){
        [self.delegate annotationButtonActionWithIndex:self.tag];
    }
}
@end
