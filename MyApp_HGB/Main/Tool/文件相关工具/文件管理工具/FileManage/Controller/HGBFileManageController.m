//
//  HGBFileManageController.m
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBFileManageController.h"

#import "HGBFileManageHeader.h"
#import "HGBFileTableCell.h"


#import "HGBFileManageTool.h"
#import "HGBFileQuickLookTool.h"
#import "HGBImageLookTool.h"
#import "HGBFileWebLook.h"
#import "HGBFileOutAppOpenFileTool.h"



#ifndef SYSTEM_VERSION
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号

#endif

#ifndef KiOS6Later
#define KiOS6Later (SYSTEM_VERSION >= 6)
#endif

#ifndef KiOS7Later
#define KiOS7Later (SYSTEM_VERSION >= 7)
#endif

#ifndef KiOS8Later
#define KiOS8Later (SYSTEM_VERSION >= 8)
#endif

#ifndef KiOS9Later
#define KiOS9Later (SYSTEM_VERSION >= 9)
#endif

#ifndef KiOS10Later
#define KiOS10Later (SYSTEM_VERSION >= 10)
#endif





/**
 文件类型
 */
typedef enum HGBFileToolType
{
    HGBFileToolTypeFile,//文件
    HGBFileToolTypeNothing//空白

}HGBFileToolType;

#define identify_FileTableCell @"FileTableCellIdentify"

@interface HGBFileManageController ()<UITableViewDelegate,UITableViewDataSource,HGBFileBaseTableCellDelegate>
/**
 顶部view
 */
@property(strong,nonatomic)UIView *headView;

/**
 下一级
 */
@property(strong,nonatomic)UIButton *nextButton;

/**
 刷新
 */
@property(strong,nonatomic)UIButton *refreshButton;

/**
 上一级
 */
@property(strong,nonatomic)UIButton *beforeButton;


/**
 列表
 */
@property(strong,nonatomic)UITableView *tableView;

/**
 数据源
 */
@property(strong,nonatomic)NSMutableArray *dataSource;

/**
 工具集合
 */
@property(strong,nonatomic)NSMutableArray *toolsArr;
/**
 工具类型
 */
@property(assign,nonatomic)HGBFileToolType toolType;


/**
 选中文件路径
 */
@property(strong,nonatomic)NSIndexPath *selectIndexPath;
/**
 文件路径
 */
@property(strong,nonatomic)NSString *currentDirectoryPath;
/**
 黏贴版路径
 */
@property(strong,nonatomic)NSString *dataPastBordPath;
/**
 源文件路径
 */
@property(strong,nonatomic)NSString *sourceDataPath;
/**
 下一步历史记录
 */
@property(strong,nonatomic)NSMutableArray *nextHistoryPaths;
/**
 基础
 */
@property(strong,nonatomic)NSString *baseCopyPath;
@end

@implementation HGBFileManageController
#define PastBordPath [[HGBFileManageTool getHomeFilePath] stringByAppendingPathComponent:@"pastBord_huang"]
#pragma mark life
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self delocSet];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initSet];//初始化设置
    [self createNavigationItem];//导航栏
    [self viewSetUp];//UI
    [self setBasedDirectorySource];//根数据


}
#pragma mark 导航栏
//导航栏
-(void)createNavigationItem
{
    //导航栏
    self.navigationController.navigationBar.barTintColor=[UIColor orangeColor];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=@"文件管理";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;

    //左键
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnhandler)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    //右键
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"HGBFileManageToolBundle.bundle/add.png"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]  style:UIBarButtonItemStylePlain target:self action:@selector(setButtonHandle:)];
    [self.navigationItem.rightBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -15, 0, 5)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

}
//返回
-(void)returnhandler{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(fileManageDidCanced)]){
        [self.delegate fileManageDidCanced];
    }

    UIViewController *rootVC=self.navigationController.childViewControllers[0];
    if([self.parentViewController isKindOfClass:[UINavigationController class]]){
        if(self==rootVC){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)setButtonHandle:(UIBarButtonItem *)_b{
    [self alertToolSelectViewWithFlag:NO];
}
#pragma mark data
/**
 设置基础数据源
 */
-(void)setBasedDirectorySource{
    self.baseCopyPath=[self.basePath copy];
    [self updateDataSourceWithDirectoryPath:self.basePath];
    [self addObserver:self forKeyPath:self.currentDirectoryPath options:(NSKeyValueObservingOptionNew) context:nil];

}
/**
 根据文件夹路径更新数据源

 @param directoryPath 文件夹路径
 */
-(void)updateDataSourceWithDirectoryPath:(NSString *)directoryPath{


    NSString *directoryChangePath=[directoryPath copy];
    if(directoryChangePath==nil||directoryChangePath.length==0){
        directoryChangePath=[HGBFileManageTool getDocumentFilePath];
    }else{
        if((![directoryPath containsString:[HGBFileManageTool getHomeFilePath]])&&(![directoryPath containsString:[HGBFileManageTool getMainBundlePath]])){
            directoryChangePath=[[HGBFileManageTool getHomeFilePath] stringByAppendingPathComponent:directoryPath];
        }else{
            directoryChangePath=directoryPath;
        }


    }
    directoryPath=directoryChangePath;


    self.dataSource=[NSMutableArray arrayWithArray:[HGBFileManageTool getFileModelsFromDirectoryPath:directoryPath]];
    self.currentDirectoryPath=directoryPath;


    if([self.currentDirectoryPath isEqualToString:self.basePath]){
        [self.beforeButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        self.beforeButton.enabled=NO;
    }else{
        [self.beforeButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        self.beforeButton.enabled=YES;
    }
    [self.tableView reloadData];

}
-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    static NSString *pastPath=@"";
    if(self.currentDirectoryPath.length>pastPath.length){
        self.nextHistoryPaths=[NSMutableArray array];
    }else if(self.currentDirectoryPath.length<pastPath.length){
        if(pastPath&&pastPath.length!=0){
            [self.nextHistoryPaths insertObject:pastPath atIndex:0];
        }
    }
    pastPath=self.currentDirectoryPath;
}
#pragma mark 初始化
-(void)initSet{
    [HGBFileManageTool createDirectoryPath:PastBordPath];
}
#pragma mark 销毁
-(void)delocSet{
    [HGBFileManageTool clearStrorageAtFilePath:PastBordPath];
}
#pragma mark view
-(void)viewSetUp{

    //headerview
    self.headView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 42)];
    self.headView.backgroundColor=[UIColor colorWithRed:246.0/256 green:246.0/256 blue:246.0/256 alpha:1];
    [self.view addSubview:self.headView];


    self.beforeButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.beforeButton.frame=CGRectMake(10,6,(kWidth-40)/3, 30);
    self.beforeButton.layer.masksToBounds=YES;
    self.beforeButton.layer.cornerRadius=10;
    [self.beforeButton setTitle:@"上一级" forState:(UIControlStateNormal)];
    [self.beforeButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    self.beforeButton.backgroundColor=[UIColor whiteColor];
    [self.beforeButton addTarget:self action:@selector(beforeButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.headView addSubview:self.beforeButton];


    self.refreshButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.refreshButton.frame=CGRectMake(20+(kWidth-30)/3,6,(kWidth-30)*0.333333, 30);
    self.refreshButton.layer.masksToBounds=YES;
    self.refreshButton.layer.cornerRadius=10;
    [self.refreshButton setTitle:@"刷新" forState:(UIControlStateNormal)];
    [self.refreshButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    self.refreshButton.backgroundColor=[UIColor whiteColor];
    [self.refreshButton addTarget:self action:@selector(refreshButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.headView addSubview:self.refreshButton];



    self.nextButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.nextButton.frame=CGRectMake(30+(kWidth-30)*2/3,6,(kWidth-30)/3, 30);
    self.nextButton.layer.masksToBounds=YES;
    self.nextButton.layer.cornerRadius=10;
    [self.nextButton setTitle:@"bundle" forState:(UIControlStateNormal)];
    [self.nextButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    self.nextButton.backgroundColor=[UIColor whiteColor];
    [self.nextButton addTarget:self action:@selector(nextButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    if(self.withoutFileSwitch==NO){
         [self.headView addSubview:self.nextButton];
    }



    //tableview
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,106, kWidth, kHeight-106) style:(UITableViewStylePlain)];

    self.tableView.alpha=1;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor=[UIColor clearColor];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[HGBFileTableCell class] forCellReuseIdentifier:identify_FileTableCell];

    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressHandler:)];
    //要求点击保持最短时间
    longPress.minimumPressDuration=1;
    [self.tableView addGestureRecognizer:longPress];

}
#pragma mark action
/**
 长按

 @param _p 长按
 */
-(void)longPressHandler:(UILongPressGestureRecognizer *)_p{
    [self alertToolSelectViewWithFlag:NO];
}
/**
 上一级

 @param _b 按钮
 */
-(void)beforeButtonHandle:(UIButton *)_b{
    NSString *path=[self.currentDirectoryPath stringByDeletingLastPathComponent];
    if([self.currentDirectoryPath isEqualToString:self.basePath]){
        path=self.currentDirectoryPath;
    }
    [self.nextHistoryPaths insertObject:self.currentDirectoryPath atIndex:0];
    [self updateDataSourceWithDirectoryPath:path];
}
/**
 下一级

 @param _b 按钮
 */
-(void)nextButtonHandle:(UIButton *)_b{

    if([_b.titleLabel.text isEqualToString:@"bundle"]){
         [self.nextButton setTitle:@"沙盒" forState:(UIControlStateNormal)];
         NSString *path=[HGBFileManageTool getMainBundlePath];
        self.basePath=path;

        [self updateDataSourceWithDirectoryPath:path];
    }else if([_b.titleLabel.text isEqualToString:@"沙盒"]){
        [self.nextButton setTitle:@"base" forState:(UIControlStateNormal)];
         NSString *path=[HGBFileManageTool getHomeFilePath];
        self.basePath=path;
        [self updateDataSourceWithDirectoryPath:path];
    }else{
        self.basePath=[self.baseCopyPath copy];
        [self.nextButton setTitle:@"bundle" forState:(UIControlStateNormal)];
        [self updateDataSourceWithDirectoryPath:self.basePath];
    }
}
/**
 刷新

 @param _b 按钮
 */
-(void)refreshButtonHandle:(UIButton *)_b{
    [self updateDataSourceWithDirectoryPath:self.currentDirectoryPath];
}
#pragma mark tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120*hScale;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     HGBFileTableCell *cell=[tableView dequeueReusableCellWithIdentifier:identify_FileTableCell forIndexPath:indexPath];
    cell.backGroundDelegate=self;
    cell.indexPath=indexPath;
     HGBFileModel *fileModel=self.dataSource[indexPath.row];
    UIImage *iconImage=[UIImage imageNamed:fileModel.fileIcon];
    if(iconImage){
        cell.iconImageView.image=iconImage;
    }else{
        cell.iconImageView.image=[UIImage imageNamed:@"HGBFileManageToolBundle.bundle/undefine.png"];
    }
    
    cell.imageView.backgroundColor=[UIColor redColor];
    if(fileModel.fileType==HGBFileTypeDirectory){
        cell.tapImageView.hidden=NO;
    }else{
        cell.tapImageView.hidden=YES;
    }
    if(fileModel.fileName){
        cell.fileNameLabel.text=fileModel.fileName;
    }
    if(fileModel.fileAbout){
        cell.fileInfoLable.text=fileModel.fileAbout;
    }
    return cell;


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self openFileAtIndex:indexPath.row];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}
-(void)fileBaseTableCellBackGroundButtonActionWithIndexPath:(NSIndexPath *)indexPath{
    self.selectIndexPath=indexPath;
    [self alertToolSelectViewWithFlag:YES];
}
/**
 打开文件

 @param index 文件位置
 */
-(void)openFileAtIndex:(NSInteger)index{
    if(index>=self.dataSource.count){
        return;
    }
    HGBFileModel *fileModel=self.dataSource[index];

    NSString *path;
    if(fileModel.filePathType==HGBFilePathTypeSandBox){
        path=[[HGBFileManageTool getHomeFilePath]stringByAppendingPathComponent:fileModel.filePath];
    }else if (fileModel.filePathType==HGBFilePathTypeBundle){
        path=[[HGBFileManageTool getMainBundlePath]stringByAppendingPathComponent:fileModel.filePath];
    }else{
        path=fileModel.filePath;
    }
    if(fileModel.fileType==HGBFileTypeDirectory||fileModel.fileType==HGBFileTypeBundle){
        if([self.basePath containsString:[HGBFileManageTool getHomeFilePath]]){
            [self updateDataSourceWithDirectoryPath:fileModel.filePath];
        }else{
            [self updateDataSourceWithDirectoryPath:[[HGBFileManageTool getMainBundlePath] stringByAppendingPathComponent:fileModel.filePath]];
        }

    }else if(fileModel.fileType==HGBFileTypeImage){
        if([self.basePath containsString:[HGBFileManageTool getHomeFilePath]]){
             [HGBImageLookTool lookFileAtPath:path inParent:self];
        }else{
            [HGBImageLookTool lookFileAtPath:[[HGBFileManageTool getMainBundlePath] stringByAppendingPathComponent:fileModel.filePath] inParent:self];
        }

    }else{

        if([self.basePath containsString:[HGBFileManageTool getHomeFilePath]]){
            [HGBFileQuickLookTool lookFileAtPath:path inParent:self];
        }else{
            [HGBFileQuickLookTool lookFileAtPath:[[HGBFileManageTool getMainBundlePath] stringByAppendingPathComponent:fileModel.filePath] inParent:self];
        }
    }
}
#pragma mark 工具栏
-(void)alertToolSelectViewWithFlag:(BOOL)flag{
    static BOOL isShow=NO;
    HGBFileModel *fileModel;
    if(self.selectIndexPath.row<self.dataSource.count){
        fileModel=self.dataSource[self.selectIndexPath.row];
    }
    NSString *path;
    if(fileModel.filePathType==HGBFilePathTypeSandBox){
        path=[[HGBFileManageTool getHomeFilePath]stringByAppendingPathComponent:fileModel.filePath];
    }else if (fileModel.filePathType==HGBFilePathTypeBundle){
        path=[[HGBFileManageTool getMainBundlePath]stringByAppendingPathComponent:fileModel.filePath];
    }else{
        path=fileModel.filePath;
    }
    if(flag){
        self.toolType=HGBFileToolTypeFile;
        if(fileModel.fileType==HGBFileTypeDirectory||fileModel.fileType==HGBFileTypeBundle){
             self.toolsArr=[NSMutableArray arrayWithArray:@[@{@"id":@"0",@"title":@"打开"},@{@"id":@"98",@"title":@"选择"}]];

        }else{
             self.toolsArr=[NSMutableArray arrayWithArray:@[@{@"id":@"0",@"title":@"打开"},@{@"id":@"98",@"title":@"选择"},@{@"id":@"3",@"title":@"使用浏览器打开"},@{@"id":@"4",@"title":@"其他方式打开"}]];
        }

        if(fileModel.isEdit){
            [self.toolsArr addObject: @{@"id":@"5",@"title":@"重命名"}];
            [self.toolsArr addObject:@{@"id":@"6",@"title":@"复制"}];
            [self.toolsArr addObject:@{@"id":@"7",@"title":@"剪切"}];
            [self.toolsArr addObject:@{@"id":@"8",@"title":@"删除"}];
        }
        if(self.dataPastBordPath){
            [self.toolsArr addObject:@{@"id":@"9",@"title":@"粘贴"}];
        }

         [self.toolsArr addObject:@{@"id":@"99",@"title":@"取消"}];

    }else{
        self.toolType=HGBFileToolTypeNothing;
        self.toolsArr=[NSMutableArray array];
         self.toolsArr=[NSMutableArray arrayWithArray:@[@{@"id":@"1",@"title":@"新建文件夹"},@{@"id":@"2",@"title":@"新建文件"}]];
        if(self.dataPastBordPath){
            [self.toolsArr addObject:@{@"id":@"9",@"title":@"粘贴"}];
        }
         [self.toolsArr addObject:@{@"id":@"99",@"title":@"取消"}];
    }

    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    for(NSDictionary *dic in self.toolsArr){
        UIAlertAction *action=[UIAlertAction actionWithTitle:dic[@"title"] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSString *idString=dic[@"id"];
            if (idString.integerValue==0) {
                [self openFileAtIndex:self.selectIndexPath.row];
            }else if(idString.integerValue==1){
                __block UITextField *inputText;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"创建文件夹" message:@"请输入文件夹名称" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    inputText=textField;
                }];

                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSString *directoryName=[inputText text];
                    if(directoryName==nil||directoryName.length==0){
                        [self alertWithPrompt:@"文件夹名不能为空"];
                        return ;
                    }
                    NSString *directoryPath=[self.currentDirectoryPath stringByAppendingPathComponent:directoryName];
                    [HGBFileManageTool createDirectoryPath:directoryPath];
                    [self updateDataSourceWithDirectoryPath:self.currentDirectoryPath];


                }];

                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:confirmAction];
                [self presentViewController:alertController animated:YES completion:nil];

            }else if(idString.integerValue==2){
                __block UITextField *inputText;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"创建文件" message:@"请输入文件名称" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    inputText=textField;
                }];

                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSString *fileName=[inputText text];
                    if(fileName==nil||fileName.length==0){
                        [self alertWithPrompt:@"文件名不能为空"];
                        return ;
                    }
                    NSString *filePath=[self.currentDirectoryPath stringByAppendingPathComponent:fileName];
                    [HGBFileManageTool createFileAtPath:filePath];
                    [self updateDataSourceWithDirectoryPath:self.currentDirectoryPath];


                }];

                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                }];

                [alertController addAction:cancelAction];
                [alertController addAction:confirmAction];
                [self presentViewController:alertController animated:YES completion:nil];

            }else if(idString.integerValue==3){
                [HGBFileWebLook lookFileAtPath:path inParent:self];

            }else if(idString.integerValue==4){
                 [HGBFileOutAppOpenFileTool openFileWithExetenAppWithPath:path inParent:self andWithCompleteBlock:^(NSInteger status) {

                 }];
            }else if(idString.integerValue==5){
                __block UITextField *inputText;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"文件重命名" message:@"请输入文件新名称" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    inputText=textField;
                }];

                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"重命名" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSString *fileName=[inputText text];
                    if(fileName==nil||fileName.length==0){
                        [self alertWithPrompt:@"文件名不能为空"];
                        return ;
                    }
                    NSString *curentPath=path;
                    NSString *filePath=[[curentPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
                    [HGBFileManageTool copyFilePath:curentPath ToPath:filePath];
                    [HGBFileManageTool removeFilePath:curentPath];
                    [self updateDataSourceWithDirectoryPath:self.currentDirectoryPath];
                }];

                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                }];

                [alertController addAction:cancelAction];
                [alertController addAction:confirmAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }else if(idString.integerValue==6){
                self.sourceDataPath=path;
                self.dataPastBordPath=[PastBordPath stringByAppendingPathComponent:[self.sourceDataPath lastPathComponent]];
               [HGBFileManageTool copyFilePath:self.sourceDataPath ToPath:self.dataPastBordPath];

                self.sourceDataPath=nil;


            }else if(idString.integerValue==7){
                self.sourceDataPath=path;
                self.dataPastBordPath=[PastBordPath stringByAppendingPathComponent:[self.sourceDataPath lastPathComponent]];
                BOOL flag=[HGBFileManageTool copyFilePath:self.sourceDataPath ToPath:self.dataPastBordPath];
                if(flag==NO){
                    self.dataPastBordPath=nil;
                }
            }else if(idString.integerValue==8){

                [HGBFileManageTool removeFilePath:path];
                [self updateDataSourceWithDirectoryPath:self.currentDirectoryPath];

            }else if(idString.integerValue==9){
                NSString *filePath=[self.currentDirectoryPath stringByAppendingPathComponent:[self.dataPastBordPath lastPathComponent]];
                int i=0;
                NSString *fileCopyPath=[filePath copy];
                while([HGBFileManageTool isExitAtFilePath:fileCopyPath]){
                fileCopyPath=[filePath stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
                    i++;
                }
                [HGBFileManageTool copyFilePath:self.dataPastBordPath ToPath:filePath];
                if(self.sourceDataPath){
                    [HGBFileManageTool removeFilePath:self.sourceDataPath];
                    self.sourceDataPath=nil;
                }
                [self updateDataSourceWithDirectoryPath:self.currentDirectoryPath];

            }else if(idString.integerValue==98){
                if(self.delegate&&[self.delegate respondsToSelector:@selector(fileManageDidReturnFilePath:andWithFileType:)]){
                    [self.delegate fileManageDidReturnFilePath:fileModel.filePath andWithFileType:fileModel.filePathType];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            isShow=NO;


        }];
        [alert addAction:action];
    }
    if(isShow==NO){
        [[self currentViewController] presentViewController:alert animated:YES completion:nil];
        isShow=YES;
    }
}
#pragma mark 提示
/**
 展示内容

 @param prompt 提示
 */
-(void)alertWithPrompt:(NSString *)prompt{
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:prompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
#endif
}
#pragma mark 获取当前控制器

/**
 获取当前控制器

 @return 当前控制器
 */
-(UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}

/**
 寻找上层控制器

 @param vc 控制器
 @return 上层控制器
 */
- (UIViewController *)findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [self findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [self findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [self findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        return vc;
    }
}
#pragma mark get
-(NSString *)basePath{
    if(_basePath==nil){
        _basePath=[HGBFileManageTool getHomeFilePath];
    }
    return _basePath;
}
-(NSMutableArray *)toolsArr{
    if(_toolsArr==nil){
        _toolsArr=[NSMutableArray array];
    }
    return _toolsArr;
}
-(NSMutableArray *)nextHistoryPaths{
    if(_nextHistoryPaths==nil){
        _nextHistoryPaths=[NSMutableArray array];
    }
    return _nextHistoryPaths;
}
@end
