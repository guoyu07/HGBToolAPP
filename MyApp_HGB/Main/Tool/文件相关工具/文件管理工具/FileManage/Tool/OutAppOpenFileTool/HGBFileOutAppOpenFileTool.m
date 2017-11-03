
//
//  HGBFileOutAppOpenFileTool.m
//  测试
//
//  Created by huangguangbao on 2017/8/16.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBFileOutAppOpenFileTool.h"
#import <QuickLook/QuickLook.h>
#import <SafariServices/SafariServices.h>

@interface HGBFileOutAppOpenFileTool()<UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (nonatomic, strong)CompleteBlock comleteBlock;
@property (nonatomic, strong) UIViewController *parentViewController;
@property (nonatomic, strong) QLPreviewController *preViewController;
@end
@implementation HGBFileOutAppOpenFileTool
static HGBFileOutAppOpenFileTool *instance=nil;
#pragma mark init
+(instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBFileOutAppOpenFileTool alloc]init];
    }
    return instance;
}
/**
 使用外部app打开文件

 @param url 路径
 @param parent 父控制器
 @param completeBlock 结果 0失败 1成功 2取消
 */
+(void)openFileWithExetenAppWithUrl:(NSString *)url inParent:(UIViewController *)parent andWithCompleteBlock:(CompleteBlock )completeBlock{
    [[self shareInstance]openFileWithExetenAppWithUrl:url inParent:parent andWithCompleteBlock:completeBlock];
}
/**
 使用外部app打开文件

 @param path 路径
 @param parent 父控制器
 @param completeBlock 结果 0失败 1成功 2取消
 */
+(void)openFileWithExetenAppWithPath:(NSString *)path inParent:(UIViewController *)parent andWithCompleteBlock:(CompleteBlock )completeBlock{
    if(path==nil||path.length==0){
        [[self shareInstance]openFileWithExetenAppWithUrl:nil inParent:parent andWithCompleteBlock:completeBlock];
    }else{
        NSString *url=[[NSURL fileURLWithPath:path]absoluteString];
        [[self shareInstance]openFileWithExetenAppWithUrl:url inParent:parent andWithCompleteBlock:completeBlock];
    }

}
/**
 使用外部app打开文件

 @param url 路径
 @param parent 父控制器
 @param completeBlock 结果 0失败 1成功 2取消
 */
-(void)openFileWithExetenAppWithUrl:(NSString *)url inParent:(UIViewController *)parent andWithCompleteBlock:(CompleteBlock )completeBlock{
    if(url==nil||url.length==0){
        completeBlock(0);
    }
    self.comleteBlock=completeBlock;
    self.parentViewController = parent;
    _documentController =[UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:url]];

    _documentController.delegate = self;



    //[_documentController presentOpenInMenuFromRect:CGRectZero
    //
    //										inView:parent.view
    //
    //									  animated:YES];

    //[_documentController presentPreviewAnimated:YES];

    [_documentController presentOptionsMenuFromRect:parent.view.bounds inView:parent.view animated:YES];

}




- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self.parentViewController;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller{
    return self.preViewController.view.frame;
}
- (nullable UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    return self.preViewController.view;
}

/**
 *  文件分享面板弹出的时候调用
 */
- (void)documentInteractionControllerWillPresentOptionsMenu:(UIDocumentInteractionController *)controller{
    NSLog(@"WillPresentOptionsMenu");

}
- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller{
    NSLog(@"DidDismissOptionsMenu");
    [self performSelector:@selector(cancelHandle) withObject:nil afterDelay:0.9];

}
-(void)cancelHandle{
    if(self.comleteBlock){
        self.comleteBlock(2);
    }
    self.comleteBlock =nil;
}
/**
 *  当选择一个文件分享App的时候调用
 */
- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(nullable NSString *)application {
    NSLog(@"begin send : %@", application);
}
-(void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application{
    NSLog(@"did send : %@", application);
    if(self.comleteBlock){
        self.comleteBlock(1);
    }
    self.comleteBlock =nil;
}
@end
