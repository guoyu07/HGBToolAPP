//
//  HGBCollectionViewCell.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HGBBaseCollectionViewCell.h"

@interface HGBCollectionViewCell : HGBBaseCollectionViewCell

/**
 图片
 */
@property(strong,nonatomic) UIImageView *imageV;
/**
 提示标签
 */
@property(strong,nonatomic)UILabel *promptLabel;


@end
