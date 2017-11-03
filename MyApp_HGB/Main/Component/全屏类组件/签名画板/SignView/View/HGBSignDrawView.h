//
//  HGBSignDrawView.h
//  啊啊啊
//
//  Created by huangguangbao on 2017/8/4.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageBlock)(UIImage *image);

@interface HGBSignDrawView : UIView

/**
 *  线宽
 */
@property (nonatomic,assign) CGFloat  lineWidth;
/**
 *  线的颜色
 */
@property (nonatomic,strong) UIColor * lineColor;
/**
 *  清空画板
 */
-(void)clearDrawBoard;

/**
 back操作
 */
- (void)doBack;

/**
 Forward操作
 */
- (void)doForward;
/**
 *  获取画图
 */
-(UIImage*)getDrawingImage;


/**
 保存到相册

 @param imageBlock 保存成功回调
 */
- (void)savePhotoToAlbumWithImageBlock:(ImageBlock)imageBlock;


@end
