//
//  HGBBaseCollectionViewController.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGBBaseCollectionViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/**
 表格
 */
@property(strong,nonatomic)UICollectionView *collectionView;
/**
 数据源
 */
@property(strong,nonatomic)NSMutableArray *dataSourceArray;
/**
 数据源
 */
@property(strong,nonatomic)NSMutableDictionary *dataSourceDictionary;

@end
