//
//  HGBPurchaseTool.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/17.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBPurchaseTool.h"

static NSString * const receiptKey = @"receipt_key";
static NSString * const dateKey = @"date_key";
static NSString * const userIdKey = @"userId_key";


dispatch_queue_t iap_queue() {
    static dispatch_queue_t as_iap_queue;
    static dispatch_once_t onceToken_iap_queue;
    dispatch_once(&onceToken_iap_queue, ^{
        as_iap_queue = dispatch_queue_create("com.PurchaseTool.queue", DISPATCH_QUEUE_CONCURRENT);
    });

    return as_iap_queue;
}


#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"
#define ReslutError @"reslutError"






@interface HGBPurchaseTool()<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, assign) BOOL goodsRequestFinished; //判断一次请求是否完成

@property (nonatomic, copy) NSString *receipt; //交易成功后拿到的一个64编码字符串

@property (nonatomic, copy) NSString *date; //交易时间

@property (nonatomic, copy) NSString *userId; //交易人
@end
@implementation HGBPurchaseTool
static HGBPurchaseTool *instance=nil;
#pragma mark init
/**
 单例

 @return 对象
 */
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBPurchaseTool alloc]init];
    }
    return instance;
}
#pragma mark 开启-关闭

/**
 开启内购监听
 */
- (void)startManager { //开启监听

    dispatch_async(iap_queue(), ^{

        self.goodsRequestFinished = YES;

        /***
         内购支付两个阶段：
         1.app直接向苹果服务器请求商品，支付阶段；
         2.苹果服务器返回凭证，app向公司服务器发送验证，公司再向苹果服务器验证阶段；
         */

        /**
         阶段一正在进中,app退出。
         在程序启动时，设置监听，监听是否有未完成订单，有的话恢复订单。
         */
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

        /**
         阶段二正在进行中,app退出。
         在程序启动时，检测本地是否有receipt文件，有的话，去二次验证。
         */
        [self checkIAPFiles];
    });
}

/**
 关闭内购监听
 */
- (void)stopManager{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    });
}

#pragma mark 查询
- (void)requestProductsWithId:(NSString *)productId {

    if (self.goodsRequestFinished) {

        if ([SKPaymentQueue canMakePayments]) { //用户允许app内购

            if (productId.length) {

                NSLog(@"%@商品正在请求中",productId);

                self.goodsRequestFinished = NO; //正在请求

                NSArray *product = [[NSArray alloc] initWithObjects:productId, nil];

                NSSet *set = [NSSet setWithArray:product];

                SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];

                productRequest.delegate = self;

                [productRequest start];

            } else {

                NSLog(@"商品为空");

                [self filedWithErrorCode:HGBPurchase_FILEDCOED_EMPTYGOODS error:nil];

                self.goodsRequestFinished = YES; //完成请求
            }

        } else { //没有权限

            [self filedWithErrorCode:HGBPurchase_FILEDCOED_NORIGHT error:nil];

            self.goodsRequestFinished = YES; //完成请求
        }

    } else {

        NSLog(@"上次请求还未完成，请稍等");
    }
}

#pragma mark SKProductsRequestDelegate 查询成功后的回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {

    NSArray *products = response.products;


    if (products.count == 0) {
        NSLog(@"无法获取商品信息，请重试");

        [self filedWithErrorCode:HGBPurchase_FILEDCOED_CANNOTGETINFORMATION error:nil];

        self.goodsRequestFinished = YES; //失败，请求完成

    } else {
        if(self.delegate&&[self.delegate respondsToSelector:@selector(purchaseRequireProductsSucess:)]){
            [self.delegate purchaseRequireProductsSucess:products];
        }
    }
}

#pragma mark SKProductsRequestDelegate 查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {

    [self filedWithErrorCode:HGBPurchase_FILEDCOED_APPLECODE error:[error localizedDescription]];

    self.goodsRequestFinished = YES; //失败，请求完成
}
/**
 支付产品

 @param product 产品
 */
-(void)payProduct:(SKProduct *)product{
    //发起购买请求
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
#pragma Mark 购买操作后的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {

    for (SKPaymentTransaction *transaction in transactions) {

        switch (transaction.transactionState) {

            case SKPaymentTransactionStatePurchasing://正在交易

                break;

            case SKPaymentTransactionStatePurchased://交易完成

                [self getReceipt]; //获取交易成功后的购买凭证

                [self saveReceipt]; //存储交易凭证

                [self checkIAPFiles];//把self.receipt发送到服务器验证是否有效

                [self completeTransaction:transaction];

                break;

            case SKPaymentTransactionStateFailed://交易失败

                [self failedTransaction:transaction];

                break;

            case SKPaymentTransactionStateRestored://已经购买过该商品

                [self restoreTransaction:transaction];

                break;

            default:

                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {

    self.goodsRequestFinished = YES; //成功，请求完成

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction {

    NSLog(@"transaction.error.code = %ld", transaction.error.code);

    if(transaction.error.code != SKErrorPaymentCancelled) {

        [self filedWithErrorCode:HGBPurchase_FILEDCOED_BUYFILED error:nil];

    } else {

        [self filedWithErrorCode:HGBPurchase_FILEDCOED_USERCANCEL error:nil];
    }

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

    self.goodsRequestFinished = YES; //失败，请求完成

}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction {

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

    self.goodsRequestFinished = YES; //恢复购买，请求完成

}




#pragma mark 用户购买凭证
/**
 持久化存储用户购买凭证(这里最好还要存储当前日期，用户id等信息，用于区分不同的凭证)
 */
-(void)saveReceipt {

    self.date = [HGBPurchaseTool chindDateFormate:[NSDate date]];

    NSString *fileName = [HGBPurchaseTool uuid];

    self.userId = @"UserID";

    NSString *savedPath = [NSString stringWithFormat:@"%@/%@.plist", [HGBPurchaseTool iapReceiptPath], fileName];

    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        self.receipt,                           receiptKey,
                        self.date,                              dateKey,
                        self.userId,                            userIdKey,
                        nil];

    NSLog(@"%@",savedPath);

    [dic writeToFile:savedPath atomically:YES];
}
/**
 获取储用户购买凭证(这里最好还要存储当前日期，用户id等信息，用于区分不同的凭证)
 */
- (void)getReceipt {

    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];

    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];

    self.receipt = [receiptData base64EncodedStringWithOptions:0];
}
/**
 验证成功就从plist中移除凭证
 */
-(void)removeReceipt{

    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:[HGBPurchaseTool iapReceiptPath]]) {

        [fileManager removeItemAtPath:[HGBPurchaseTool iapReceiptPath] error:nil];

    }
}
/**
 校验凭证-将存储到本地的IAP文件发送给服务端 验证receipt失败,App启动后再次验证
 */
- (void)checkIAPFiles{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    //搜索该目录下的所有文件和目录
    NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[HGBPurchaseTool iapReceiptPath] error:&error];

    if (error == nil) {
        for (NSString *name in cacheFileNameArray) {
            if ([name hasSuffix:@".plist"]){ //如果有plist后缀的文件，说明就是存储的购买凭证

                NSString *filePath = [NSString stringWithFormat:@"%@/%@", [HGBPurchaseTool iapReceiptPath], name];

                [self sendAppStoreRequestBuyPlist:filePath];
            }
        }

    } else {

        NSLog(@"AppStoreInfoLocalFilePath error:%@", [error domain]);
    }
}

-(void)sendAppStoreRequestBuyPlist:(NSString *)plistPath {

    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];

    //这里的参数请根据自己公司后台服务器接口定制，但是必须发送的是持久化保存购买凭证
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:receiptKey],          receiptKey, [dic objectForKey:dateKey],             dateKey, [dic objectForKey:userIdKey],           userIdKey, nil];
    NSLog(@"%@",params);
#ifdef HHHHH

   // 在这里将凭证发送给服务器

    if(@"凭证有效"){

//        凭证有效
        [self removeReceipt];

    } else {//凭证无效

        //做你想做的
    }
#endif
}






#pragma mark 错误信息反馈
- (void)filedWithErrorCode:(NSInteger)code error:(NSString *)error {
    if(error==nil){
        error=@"";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(purchaseFailedWithErrorCode:andWithErrorInfo:)]) {
        switch (code) {
            case HGBPurchase_FILEDCOED_APPLECODE:
                [self.delegate purchaseFailedWithErrorCode:HGBPurchase_FILEDCOED_APPLECODE andWithErrorInfo:@{ReslutCode:@(HGBPurchase_FILEDCOED_APPLECODE),ReslutError:error,ReslutMessage:@"苹果返回错误信息"}];
                break;

            case HGBPurchase_FILEDCOED_NORIGHT:
                [self.delegate purchaseFailedWithErrorCode:HGBPurchase_FILEDCOED_NORIGHT andWithErrorInfo:@{ReslutCode:@(HGBPurchase_FILEDCOED_NORIGHT),ReslutError:error,ReslutMessage:@"用户禁止应用内付费购买"}];
                break;

            case HGBPurchase_FILEDCOED_EMPTYGOODS:
                [self.delegate purchaseFailedWithErrorCode:HGBPurchase_FILEDCOED_EMPTYGOODS andWithErrorInfo:@{ReslutCode:@(HGBPurchase_FILEDCOED_EMPTYGOODS),ReslutError:error,ReslutMessage:@"商品为空"}];
                break;

            case HGBPurchase_FILEDCOED_CANNOTGETINFORMATION:
                [self.delegate purchaseFailedWithErrorCode:HGBPurchase_FILEDCOED_CANNOTGETINFORMATION andWithErrorInfo:@{ReslutCode:@(HGBPurchase_FILEDCOED_CANNOTGETINFORMATION),ReslutError:error,ReslutMessage:@"无法获取产品信息，请重试"}];
                break;

            case HGBPurchase_FILEDCOED_BUYFILED:
                [self.delegate purchaseFailedWithErrorCode:HGBPurchase_FILEDCOED_BUYFILED andWithErrorInfo:@{ReslutCode:@(HGBPurchase_FILEDCOED_BUYFILED),ReslutError:error,ReslutMessage:@"购买失败，请重试"}];
                break;

            case HGBPurchase_FILEDCOED_USERCANCEL:
                [self.delegate purchaseFailedWithErrorCode:HGBPurchase_FILEDCOED_USERCANCEL andWithErrorInfo:@{ReslutCode:@(HGBPurchase_FILEDCOED_USERCANCEL),ReslutError:error,ReslutMessage:@"用户取消交易"}];
                break;

            default:
                break;
        }
    }
}
#pragma mark 沙盒文件
/**
 获取沙盒根路径

 @return 根路径
 */
+(NSString *)getHomeFilePath{
    NSString *path_huang=NSHomeDirectory();
    return path_huang;
}
/**
 获取沙盒Document路径

 @return Document路径
 */
+(NSString *)getDocumentFilePath{
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    return path_huang;
}
/**
 获取沙盒library路径

 @return library路径
 */
+(NSString *)getLibraryFilePath{
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) lastObject];
    return path_huang;
}
/**
 获取沙盒cache路径

 @return cache路径
 */
+(NSString *)getCacheFilePath{
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
    return path_huang;
}
/**
 获取沙盒Preference路径

 @return Preference路径
 */
+(NSString *)getPreferenceFilePath{
    NSString *path_huang= [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/Preferences"];
    return path_huang;
}
/**
 获取沙盒tmp路径

 @return tmp路径
 */
+(NSString *)getTmpFilePath{
    NSString *tmpPath=NSTemporaryDirectory();
    return tmpPath;
}
/**
 用于存储iap内购返回的购买凭证

 @return iap内购返回的购买凭证
 */
+ (NSString *)iapReceiptPath{

    NSString *path = [[HGBPurchaseTool getPreferenceFilePath] stringByAppendingFormat:@"/EACEF35FE363A75A"];
    [HGBPurchaseTool hasLive:path];
    return path;
}
+ (BOOL)hasLive:(NSString *)path
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }

    return YES;
}
#pragma mark date
+ (NSString *)chindDateFormate:(NSDate *)update{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:update];
    return destDateString;
}
#pragma mark uuid

+ (NSString *)uuid{
    // create a new UUID which you own
    CFUUIDRef uuidref = CFUUIDCreate(kCFAllocatorDefault);

    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    CFStringRef uuid = CFUUIDCreateString(kCFAllocatorDefault, uuidref);

    NSString *result = (__bridge NSString *)uuid;
    //release the uuidref
    CFRelease(uuidref);
    // release the UUID
    CFRelease(uuid);

    return result;
}
@end
