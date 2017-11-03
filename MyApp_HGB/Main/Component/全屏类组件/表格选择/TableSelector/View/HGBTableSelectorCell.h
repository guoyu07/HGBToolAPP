//
//  HGBTableSelectorCell.h
//  CTTX
//
//  Created by huangguangbao on 16/11/21.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 表格选择cell
 */
@interface HGBTableSelectorCell :UITableViewCell
/**
 标题
 */
@property (nonatomic,strong)UILabel *titleLab;
/**
 状态
 */
@property (nonatomic,strong)UIImageView *selectImageView;
@end
