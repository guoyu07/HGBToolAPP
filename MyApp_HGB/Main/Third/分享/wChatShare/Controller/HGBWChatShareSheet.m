//
//  HGBWChatShareSheet.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/11/1.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBWChatShareSheet.h"
#import "HGBWChatShareHeader.h"
#import "HGBWChatShareTool.h"

@interface HGBWChatShareSheet ()<HGBWChatShareToolDelegate>
/**
 父控制器
 */
@property (strong,nonatomic)UIViewController *parent;
/**
 代理
 */
@property (strong,nonatomic)id<HGBWChatShareSheetDelegate>delegate;
/**
 底层灰层
 */
@property(strong,nonatomic)UIView *grayHeaderView;
/**
 底层返回按钮
 */
@property(strong,nonatomic)UIButton *backButton;
/**
 分享类型
 */
@property(strong,nonatomic)NSString *type;
/**
 分享方式
 */
@property(strong,nonatomic)NSArray *shareType;
@end

@implementation HGBWChatShareSheet

#pragma mark init
/**
 创建
 */
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBWChatShareSheetDelegate>)delegate;
{
    return [[[self class]alloc]initWithWithParentContoller:parent andWithDelegate:delegate];;
}

-(instancetype)initWithWithParentContoller:(UIViewController *)parent andWithDelegate:(id<HGBWChatShareSheetDelegate>)delegate
{
    self=[super init];
    if(self){
        self.parent=parent;
        self.delegate=delegate;
    }
    return self;
}
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewSetUp];//ui

}

#pragma mark view
-(void)viewSetUp
{
    //功能区背景
    self.view.frame=CGRectMake(0,kHeight+30,kWidth,213);
    UIView *backview=[[UIView alloc]initWithFrame:CGRectMake(20*wScale, 0, kWidth-40*wScale, 150)];
    backview.backgroundColor=[UIColor whiteColor];
    backview.layer.masksToBounds=YES;
    backview.layer.cornerRadius=10;
    [self.view addSubview:backview];

    //提示信息
    UILabel *promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale,17.7,kWidth-60*wScale,16.7)];
    promptLabel.text=@"分享给我的好友";
    promptLabel.textColor=HGBColor(102,102,102);
    promptLabel.textAlignment=NSTextAlignmentLeft;
    promptLabel.font=[UIFont systemFontOfSize:16.7];
    [backview addSubview:promptLabel];
    //功能区
    [self createFuncInBackView:backview];

    //取消按钮
    UIButton *cancelButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelButton.frame=CGRectMake(20*wScale, 160, kWidth-40*wScale,53);
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelButton setTitleColor:HGBColor(102,102,102) forState:(UIControlStateNormal)];
    cancelButton.backgroundColor=[UIColor whiteColor];
    cancelButton.layer.masksToBounds=YES;
    cancelButton.layer.cornerRadius=10;
    [cancelButton addTarget:self action:@selector(cancelButtonHandler:) forControlEvents:(UIControlEventTouchDown)];
    [self.view addSubview:cancelButton];



}
-(void)createFuncInBackView:(UIView *)view
{

    for(int i=0; i<self.shareType.count;i++){
        NSDictionary *dic =self.shareType[i];
        float w=83,h=view.frame.size.height-50,x_image=15,y_image=0,w_image=53,h_image=53,y_label=10;
        NSString *name=[dic objectForKey:@"name"];
        NSString *pic=[dic objectForKey:@"pic"];
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(i*w,50, w, h)];
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(x_image, y_image,w_image, h_image)];
        imageV.image=[UIImage imageNamed:pic];
        [backView addSubview:imageV];

        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,y_image+h_image+y_label,w,16.7)];
        label.text=name;
        label.textColor=HGBColor(85,85,85);
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:16.7];
        [backView addSubview:label];
        UIButton *button=[UIButton buttonWithType:(UIButtonTypeSystem)];
        button.backgroundColor=[UIColor clearColor];
        button.frame=CGRectMake(0,0,w, h);
        button.tag=i;
        [button addTarget:self action:@selector(buttonActionHandle:) forControlEvents:(UIControlEventTouchUpInside)];
        [button addTarget:self action:@selector(buttonRemoveBlurredHandle:) forControlEvents:(UIControlEventTouchUpOutside)];
        [button addTarget:self action:@selector(buttonRemoveBlurredHandle:) forControlEvents:(UIControlEventTouchCancel)];
        [button addTarget:self action:@selector(buttonBlurredHandle:) forControlEvents:(UIControlEventTouchDown)];

        [backView addSubview:button];
        [view addSubview:backView];
    }

}
#pragma mark 按钮功能
-(void)buttonActionHandle:(UIButton *)_b{
    _b.backgroundColor=[UIColor clearColor];
    if(_b.tag==0){
        [HGBWChatShareTool shareToWChatSceneSessionWithTitle:self.shareTitle andWithDetails:self.shareDetail andWithUrl:self.shareUrl andWithThumImage:self.shareImage andWithDelegate:self];
    }else if (_b.tag==1){
        [HGBWChatShareTool shareToWChatSceneTimelineWithDetails:self.shareDetail andWithUrl:self.shareUrl andWithThumImage:self.shareImage andWithDelegate:self];
    }
    [self popViewRemoved];
}
-(void)buttonBlurredHandle:(UIButton *)_b{
    _b.backgroundColor=HGBAColor(256,256,256,0.59);
}
-(void)buttonRemoveBlurredHandle:(UIButton *)_b{
    _b.backgroundColor=[UIColor clearColor];
}
-(void)cancelButtonHandler:(UIButton *)_b
{
    [self popViewRemoved];
}
#pragma mark delegate
-(void)wChatShare:(HGBWChatShareTool *)wChatShare didShareWithShareStatus:(HGBWChatShareStatus)status andWithReslutInfo:(NSDictionary *)reslutInfo{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(wChatShareSheet:didShareWithShareStatus:andWithReslutInfo:)]){
        [self.delegate wChatShareSheet:self didShareWithShareStatus:status andWithReslutInfo:reslutInfo];
    }
    
}
#pragma mark 视图弹出
-(void)popInParentView
{
    self.grayHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth,kHeight)];
    self.grayHeaderView.tag=10;
    self.grayHeaderView.backgroundColor=[UIColor blackColor];
    self.grayHeaderView.alpha=0.3;

    [self.grayHeaderView addSubview:self.backButton];
    [self.parent.navigationController.view addSubview:self.grayHeaderView];

    [self.parent.navigationController.view addSubview:self.view];

    [self.parent.navigationController addChildViewController:self];

    self.view.frame=CGRectMake(0,kHeight+30,kWidth,213);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=CGRectMake(0, kHeight-213-10, kWidth, 213);
    }];
}

#pragma mark 视图消失
-(void)popViewDisappearWithSucessBlock:(void (^)(void))successBlock
{
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.view.transform=CGAffineTransformTranslate(self.view.transform,0,1000*hScale);
    } completion:^(BOOL finished) {
        successBlock();
        [self popViewRemoved];
    }];
}
//视图移除
-(void)popViewRemoved
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self.grayHeaderView removeFromSuperview];
}

#pragma mark get

-(UIButton *)backButton{
    if(_backButton==nil){
        //灰色背景取消按钮
        _backButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
        _backButton.frame=CGRectMake(0, 0, kWidth, kHeight);
        _backButton.backgroundColor=[UIColor clearColor];

        [_backButton addTarget:self action:@selector(cancelButtonHandler:) forControlEvents:(UIControlEventTouchDown)];
    }
    return _backButton;
}

-(NSArray *)shareType{
    if(_shareType==nil){
        _shareType=@[@{@"pic":@"HGBWChartBundle.bundle/icon_normal_wechat",@"name":@"微信"},@{@"pic":@"HGBWChartBundle.bundle/icon_normal_wechat moment",@"name":@"朋友圈"}];
    }
    return _shareType;
}
@end
