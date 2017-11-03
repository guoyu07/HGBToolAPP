//
//  HGBTitleBottomTypeCell.h
//  CTTX
//
//  Created by huangguangbao on 17/1/4.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBottomBaseTableViewCell.h"

/**
 底部弹窗选择cell
 */
@interface HGBTitleBottomTypeCell : HGBBottomBaseTableViewCell
/**
 标题
 */
@property(strong,nonatomic)UILabel *titleLab;
/**
 详情
 */
@property(strong,nonatomic)UILabel *detailLab;
/**
 点击
 */
@property(strong,nonatomic)UIImageView *tapImgV;
@end
