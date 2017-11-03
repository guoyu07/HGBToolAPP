//
//  HGBMediaViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/18.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBMediaViewController.h"
#import "HGBMediaTool.h"


#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"



/**
 名称:媒体基础功能


 调用:1.HGBMediaTool 媒体基础功能


 功能:手电筒,相册，相机，录像，录音，图片展示，播放录音，播放视频

 framework:
 QuartzCore.framework
 QuickLook.framework
 MobileCoreServices.framework
 AVKit.framework
 CoreLocation.framework
 AssetsLibrary.framework
 AVFoundation.framework
 Foundation.framework
 UIKit.framework
 CoreImage.framework



 info.plist权限：
 <!— 相册 -->
 <key>NSPhotoLibraryUsageDescription</key> <string>App需要您的同意,才能访问相册</string>
 <!-- 相机 -->
 <key>NSCameraUsageDescription</key>
 <string>App需要您的同意,才能访问相机</string>
 <!-- 麦克风 -->
 <key>NSMicrophoneUsageDescription</key>
 <string>App需要您的同意,才能访问麦克风</string>
 */
@interface HGBMediaViewController ()<HGBMediaToolDelegate>
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
/**
 相机相册存储地址
 */
@property(strong,nonatomic)NSString *imagePath;
/**
 视频地址
 */
@property(strong,nonatomic)NSString *videoPath;
/**
 音频地址
 */
@property(strong,nonatomic)NSString *audioPath;
@property(assign,nonatomic)NSInteger index;
/**
 图片框
 */
@property(strong,nonatomic)UIImageView *imageView;
@end

@implementation HGBMediaViewController
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetUp];//UI

}
#pragma mark 导航栏
//导航栏
-(void)createNavigationItem
{
    //导航栏
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0/256 green:191.0/256 blue:256.0/256 alpha:1];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0.0/256 green:191.0/256 blue:256.0/256 alpha:1]];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=@"多媒体工具";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;


    //左键
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回"  style:UIBarButtonItemStylePlain target:self action:@selector(returnhandler)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -15, 0, 5)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

}
//返回
-(void)returnhandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UI
-(void)viewSetUp{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, kWidth, kHeight) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.dataDictionary=@{@"多媒体工具:":@[@"打开手电筒",@"关闭手电筒",@"相册",@"拍照",@"录像",@"开始录音",@"暂停录音",@"结束录音",@"取消录音",@"打开图片",@"播放视频",@"播放音频"]};
    self.keys=@[@"多媒体工具:"];

    [self.tableView registerClass:[HGBCommonSelectCell class] forCellReuseIdentifier:Identify_Cell];
    [self.tableView reloadData];

    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth,200)];
    headerView.backgroundColor=[UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];

    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-160)*0.5, 20, 160, 160)];
    self.imageView.backgroundColor=[UIColor lightGrayColor];
    [headerView addSubview:self.imageView];
    self.tableView.tableHeaderView=headerView;
}
#pragma mark table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keys.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 72 * hScale;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 72 * hScale)];
    headView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    //信息提示栏
    UILabel *tipMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(32 * wScale, 0, kWidth - 32 * wScale, CGRectGetHeight(headView.frame))];
    tipMessageLabel.backgroundColor = [UIColor clearColor];
    tipMessageLabel.text =self.keys[section];
    tipMessageLabel.textColor = [UIColor grayColor];
    tipMessageLabel.textAlignment = NSTextAlignmentLeft;
    tipMessageLabel.font = [UIFont systemFontOfSize:12.0];
    tipMessageLabel.numberOfLines = 0;
    [headView addSubview:tipMessageLabel];
    return headView;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=self.keys[section];
    NSArray *dataAraay=[self.dataDictionary objectForKey:key];
    return  dataAraay.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HGBCommonSelectCell *cell=[tableView dequeueReusableCellWithIdentifier:Identify_Cell forIndexPath:indexPath];
    NSString *key=self.keys[indexPath.section];
    NSArray *dataArray=[self.dataDictionary objectForKey:key];
    cell.title.text=dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){
        self.index=indexPath.row;
        HGBMediaTool *media=[HGBMediaTool instanceWithParent:self andWithDelegate:self];
        media.isSaveToAlbum=NO;
        media.isSaveToCache=YES;
        if (indexPath.row==0){
            [media startOnTorch];
        }else if (indexPath.row==1){
            [media startOffTorch];
        }else if (indexPath.row==2){
            [media startPhotoAlbum];
        }else if (indexPath.row==3){
            [media startCamera];
        }else if (indexPath.row==4){
            [media startVideo];
        }else if (indexPath.row==5){
            [media startRecording];
        }else if (indexPath.row==6){
            [media parseRecording];
        }else if (indexPath.row==7){
            [media stopRecording];
        }else if (indexPath.row==8){
            [media cancelRecording];
        }else if (indexPath.row==9){
            [media lookImageAtPath:self.imagePath inParent:self];
        }else if (indexPath.row==10){
            [media lookVideoAtPath:self.videoPath inParent:self];
        }else if (indexPath.row==11){
            [media lookAudioAtPath:self.audioPath inParent:self];
        }

    }
}

#pragma mark delegate
-(void)mediaToolDidCanceled:(HGBMediaTool *)media{
    NSLog(@"cancel");
}
-(void)mediaToolDidSucessed:(HGBMediaTool *)media{
    NSLog(@"sucesss");
}
-(void)mediaTool:(HGBMediaTool *)media didReturnImage:(UIImage *)image{
    self.imageView.image=image;
    NSLog(@"%@",image);
}
-(void)mediaTool:(HGBMediaTool *)media didFailedWithError:(NSDictionary *)errorInfo{
    NSLog(@"%@",errorInfo);
}
-(void)mediaToolDidFailToSaveToAlbum:(HGBMediaTool *)media{
    NSLog(@"fail to album");
}
-(void)mediaToolDidFailToSaveToCache:(HGBMediaTool *)media{
    NSLog(@"fail to caches");
}
-(void)mediaToolDidSucessToSaveToAlbum:(HGBMediaTool *)media{
    NSLog(@"sucess to album");
}
-(void)mediaTool:(HGBMediaTool *)media didSucessSaveToCachePath:(NSString *)path{
    NSLog(@"sucess to caches");
    if(self.index==2){
        self.imagePath=path;
    }else if (self.index==3){
        self.imagePath=path;
    }else if (self.index==4){
        self.videoPath=path;
    }else if (self.index==7){
        self.audioPath=path;
    }
}
#pragma mark get
-(NSDictionary *)dataDictionary{
    if(_dataDictionary==nil){
        _dataDictionary=[NSDictionary dictionary];
    }
    return _dataDictionary;
}
-(NSArray *)keys{
    if(_keys==nil){
        _keys=[NSArray array];
    }
    return _keys;
}
@end
