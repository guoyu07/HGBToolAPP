//
//  HGBEncryptViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/17.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBEncryptViewController.h"
#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"

#import "HGBEncryptTool.h"

@interface HGBEncryptViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBEncryptViewController
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
    titleLab.text=@"加密工具";
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
    self.dataDictionary=@{@"加密工具:(本工具包含AES,DES,RSA,TTAlgorithmSM4,MD2/3/5,sha1/256/126..,Sign,Hash,Base64)":@[@"特殊字符编码",@"Base64",@"MD5",@"sha",@"hash",@"AES",@"DES",@"TTAlgorithmSM4",@"RSA",@"RSA反向",@"Sign"]};
    self.keys=@[@"加密工具:(本工具包含AES,DES,RSA,TTAlgorithmSM4,MD2/3/5,sha1/256/126..,Sign,Hash,Base64)"];

    [self.tableView registerClass:[HGBCommonSelectCell class] forCellReuseIdentifier:Identify_Cell];
    [self.tableView reloadData];
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
    NSString *string=@"hello";
    NSString *key=@"1234567890123456";
    if(indexPath.section==0){
        if (indexPath.row==0){
            string=[HGBEncryptTool specialStringEncodingWithString:string];
            NSLog(@"特殊字符-encode:%@",string);
            string=[HGBEncryptTool specialStringDecodingWithString:string];
            NSLog(@"特殊字符-decode:%@",string);


        }else if (indexPath.row==1){
            string=[HGBEncryptTool encryptStringWithBase64:string];
            NSLog(@"base64-encrypt:%@",string);
            string=[HGBEncryptTool decryptStringWithBase64:string];
            NSLog(@"base64-decrypt:%@",string);
        }else if (indexPath.row==2){
            string=[HGBEncryptTool encryptStringWithMD5_32UP:string];
            NSLog(@"md5-32-up-encrypt:%@",string);
            string=@"hello";
            string=[HGBEncryptTool encryptStringWithMD5_32LOW:string];
            NSLog(@"md5-32-low-encrypt:%@",string);
            string=@"hello";
            string=[HGBEncryptTool encryptStringWithMD5_16UP:string];
            NSLog(@"md5-16-up-encrypt:%@",string);
            string=@"hello";

            string=[HGBEncryptTool encryptStringWithMD5_16LOW:string];
            NSLog(@"md5-16-low-encrypt:%@",string);


        }else if (indexPath.row==3){
             string=[HGBEncryptTool encryptStringWithsha1:string];
            NSLog(@"sha1-encrypt:%@",string);
        }else if (indexPath.row==4){
            string=[HGBEncryptTool hashStringFromJsonObject:string andWithSalt:key];
            NSLog(@"hash-encrypt:%@",string);
        }else if (indexPath.row==5){
            string=[HGBEncryptTool encryptStringWithAES256:string andWithKey:key];
            NSLog(@"aes256-encrypt:%@",string);
            string=[HGBEncryptTool decryptStringWithAES256:string andWithKey:key];
            NSLog(@"aes256-decrypt:%@",string);
        }else if (indexPath.row==6){
            string=[HGBEncryptTool encryptStringWithDES3:string andWithKey:key];
            NSLog(@"DES-encrypt:%@",string);
            string=[HGBEncryptTool decryptStringWithDES3:string andWithKey:key];
            NSLog(@"DES-decrypt:%@",string);
        }else if (indexPath.row==7){
            string=[HGBEncryptTool encryptStringWithTTAlgorithmSM4_ECB:string andWithKey:key];
            NSLog(@"TTAlgorithmSM4_ECB-encrypt:%@",string);
            string=[HGBEncryptTool decryptStringWithTTAlgorithmSM4_ECB:string andWithKey:key];
            NSLog(@"TTAlgorithmSM4_ECB-decrypt:%@",string);
        }else if (indexPath.row==8){
            NSString *pubPath=[[NSBundle mainBundle]pathForResource:@"public_key" ofType:@"der"];
            NSString *priPath=[[NSBundle mainBundle]pathForResource:@"private_key" ofType:@"p12"];

            string=[HGBEncryptTool encryptStringWithRSA:string andWithPublicKeyPath:pubPath];
            NSLog(@"RSA-encrypt:%@",string);
            string=[HGBEncryptTool decryptStringWithRSA:string andWithPrivateKeyPath:priPath andWithPassWord:@"123456"];
            NSLog(@"RSA-decrypt:%@",string);
        }else if (indexPath.row==9){
            NSString *pubPath=@"public_key.der";
            NSString *priPath=@"private_key.p12";

            string=[HGBEncryptTool encryptStringWithReverseRSA:string andWithPrivateKeyPath:priPath andWithPassWord:@"123456"];
            NSLog(@"RSA反向-encrypt:%@",string);
            string=[HGBEncryptTool decryptStringWithReverseRSA:string andWithPublicKeyPath:pubPath];
            NSLog(@"RSA反向-decrypt:%@",string);
        }else if (indexPath.row==10){

        }
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
