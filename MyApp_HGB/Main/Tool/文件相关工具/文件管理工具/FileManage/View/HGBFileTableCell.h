//
//  HGBFileTableCell.h
//  测试
//
//  Created by huangguangbao on 2017/8/15.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBFileBaseTableCell.h"
@interface HGBFileTableCell : HGBFileBaseTableCell
/**
 icon
 */
@property(strong,nonatomic)UIImageView *iconImageView;
/**
 文件名
*/
@property(strong,nonatomic)UILabel *fileNameLabel;
/**
 文件信息
 */
@property(strong,nonatomic)UILabel *fileInfoLable;
/**
 下一级
 */
@property(strong,nonatomic)UIImageView *tapImageView;
@end
