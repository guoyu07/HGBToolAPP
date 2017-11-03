//
//  HGBPurchaseTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/17.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, HGBPurchaseFiledCode) {
    /**
     *  苹果返回错误信息
     */
    HGBPurchase_FILEDCOED_APPLECODE = 0,

    /**
     *  用户禁止应用内付费购买
     */
    HGBPurchase_FILEDCOED_NORIGHT = 1,

    /**
     *  商品为空
     */
    HGBPurchase_FILEDCOED_EMPTYGOODS = 2,
    /**
     *  无法获取产品信息，请重试
     */
    HGBPurchase_FILEDCOED_CANNOTGETINFORMATION = 3,
    /**
     *  购买失败，请重试
     */
    HGBPurchase_FILEDCOED_BUYFILED = 4,
    /**
     *  用户取消交易
     */
    HGBPurchase_FILEDCOED_USERCANCEL = 5

};

@protocol HGBPurchaseToolDelegate <NSObject>

/**
 内购失败

 @param errorCode 错误码
 @param errorInfo 错误信息
 */
- (void)purchaseFailedWithErrorCode:(NSInteger)errorCode andWithErrorInfo:(NSDictionary *)errorInfo;
/**
 获取商品请求成功

 @param products 商品
 */
- (void)purchaseRequireProductsSucess:(NSArray *)products;

@end
@interface HGBPurchaseTool : NSObject
@property (nonatomic, weak)id<HGBPurchaseToolDelegate>delegate;
/**
 单例

 @return 对象
 */
+ (instancetype)shareInstance;
/**
 启动工具
 */
- (void)startManager;

/**
 结束工具
 */
- (void)stopManager;

/**
 请求商品列表
 */
- (void)requestProductsWithId:(NSString *)productId;
/**
 支付产品

 @param product 产品
 */
-(void)payProduct:(SKProduct *)product;

@end
