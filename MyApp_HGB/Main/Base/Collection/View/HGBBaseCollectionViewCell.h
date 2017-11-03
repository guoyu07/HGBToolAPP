//
//  HGBBaseCollectionViewCell.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/27.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGBBaseCollectionViewCell : UICollectionViewCell
@property(strong,nonatomic)NSIndexPath *indexPath;


/**
 左部线标志
 */
@property(assign,nonatomic)BOOL leftHiden;
/**
 右部线标志
 */
@property(assign,nonatomic)BOOL rightHiden;
/**
 底部线
 */
@property(assign,nonatomic)BOOL bottomHiden;
/**
 上部线
 */
@property(assign,nonatomic)BOOL topHiden;
@end
