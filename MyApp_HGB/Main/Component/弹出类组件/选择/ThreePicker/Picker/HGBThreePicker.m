//
//  HGBThreePicker.m
//  CTTX
//
//  Created by huangguangbao on 17/1/5.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBThreePicker.h"
#import "HGBThreePickerHeader.h"
@interface HGBThreePicker ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger _firstIndex;//第一项坐标
    NSInteger _secondIndex;//第二项坐标
    NSInteger _threadIndex;//第三项坐标
}
@property(assign,nonatomic)id<HGBThreePickerDelegate>delegate;
/**
 父控制器
 */
@property(strong,nonatomic)UIViewController *parent;
/**
 根控制器
 */
@property(strong,nonatomic)UIWindow *window;

/**
 背景图
 */
@property (nonatomic,strong)UIView *backgroudView;
/**
 选择控制器
 */
@property (nonatomic,strong)UIPickerView *pickerView;

/**
 第一列数组
 */
@property (nonatomic,strong)NSMutableArray *firstTypesArr;
/**
 第二列数组
 */
@property (nonatomic,strong)NSMutableArray *secondTypesArr;
/**
 第三列数组
 */
@property (nonatomic,strong)NSMutableArray *threadypesArr;

/**
 结果数组
 */
@property (nonatomic,strong)NSMutableArray *souceArr;


/**
 提示
 */
@property(strong,nonatomic)UILabel *promptLab;
/**
 灰层
 */
@property(strong,nonatomic)UIButton *grayHeaderView;

/**
 确认按钮
 */
@property(strong,nonatomic) UIButton *okButton;
/**
 取消按钮
 */
@property(strong,nonatomic) UIButton *cancelButton;


@end

@implementation HGBThreePicker

static HGBThreePicker *obj=nil;
#pragma mark init
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBThreePickerDelegate>)delegate{
    return [[[self class]alloc]initWithParent:parent andWithDelegate:delegate];
}
-(instancetype)initWithParent:(UIViewController *)parent andWithDelegate:(id<HGBThreePickerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate=delegate;
        self.parent=parent;
         [self viewSetUp];
        
    }
    return self;
}

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark view
-(void)viewSetUp{
    
    self.view.backgroundColor = [UIColor whiteColor];
    _firstIndex = 0;
    _secondIndex = 0;
    _threadIndex = 0;
    
    self.view.frame=CGRectMake(0, 0,kWidth,700*hScale);
    
    self.firstTypesArr = [NSMutableArray array];
    self.secondTypesArr = [NSMutableArray array];
    self.threadypesArr = [NSMutableArray array];
    self.souceArr = [NSMutableArray array];
    
    
    self.backgroudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 700 * hScale)];
    self.backgroudView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroudView];
    
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 96 * hScale)];
    tempView.backgroundColor = [UIColor whiteColor];
    [self.backgroudView addSubview:tempView];
    
    
    UIButton *closeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    closeButton.frame = CGRectMake(20 * wScale, 34 * hScale, 100 * wScale, 28 * wScale);
    [closeButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [closeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [closeButton addTarget:self action:@selector(cancelButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    closeButton.tag = 200;
    [tempView addSubview:closeButton];
    
    
    self.cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.cancelButton .frame = CGRectMake(0 * wScale, 0 * hScale, 96 * wScale, 96 * wScale);
    
    [self.cancelButton  addTarget:self action:@selector(cancelButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    self.cancelButton .tag = 201;
    [tempView addSubview:self.cancelButton ];
    
   self.okButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.okButton.backgroundColor = [UIColor clearColor];
    self.okButton.frame = CGRectMake(kWidth - 50 - 30 * wScale, 0, 50, 96 * hScale);
    [self.okButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.okButton setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] forState:(UIControlStateNormal)];
    [self.okButton addTarget:self action:@selector(okButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    [tempView addSubview:self.okButton];
    
    
    
    self.promptLab=[[UILabel alloc]initWithFrame:CGRectMake(120*wScale, 0, kWidth-240*wScale, 70*hScale)];
    self.promptLab.text=@"时间选择器";
    self.promptLab.font=[UIFont systemFontOfSize:32*hScale];
    self.promptLab.textColor=[UIColor blackColor];
    self.promptLab.textAlignment=NSTextAlignmentCenter;
    self.promptLab.backgroundColor=[UIColor whiteColor];
    
    
    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(tempView.frame) - 1, kWidth, 1)];
    lineImageView.image = [UIImage imageNamed:@"line_cell_H"];
    [tempView addSubview:lineImageView];
    
    
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tempView.frame), kWidth, 604 * hScale)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.backgroudView addSubview:self.pickerView];
}
#pragma mark 弹出视图
//弹出视图
-(void)popInParentView
{
    if(obj){
        [obj popViewRemoved];
    }
    
    NSString *firstStr,*secondStr,*thirdStr;
    if(self.selectedItems.count>=3){
        firstStr=self.selectedItems[0];
        secondStr=self.selectedItems[1];
        thirdStr=self.selectedItems[2];
    }else if(self.selectedItems.count>=2){
        firstStr=self.selectedItems[0];
        secondStr=self.selectedItems[1];
    }else if(self.selectedItems.count>=1){
        firstStr=self.selectedItems[0];
    }
    NSArray *keyArr = [self.dataSource allKeys];
    keyArr=[keyArr sortedArrayUsingSelector:@selector(compare:)];
    int i=0,j=0,k=0;
    for(i=0;i<keyArr.count;i++){
        NSString *key=keyArr[i];
        if(firstStr){
            if([key isEqualToString:firstStr]){
                break;
            }
        }
    }
    if(i==keyArr.count){
        i=0;
    }
    _firstIndex=i;
    self.firstTypesArr=[NSMutableArray arrayWithArray:keyArr];
    
    NSString *keyStr = [self.firstTypesArr objectAtIndex:i];
    
    NSDictionary *seconddic = [_dataSource objectForKey:keyStr];
    NSArray *secondArr = [seconddic allKeys];
    secondArr=[secondArr sortedArrayUsingSelector:@selector(compare:)];
    
    for(j=0;j<secondArr.count;j++){
        NSString *key=secondArr[j];
        if(secondStr){
            if([key isEqualToString:secondStr]){
                break;
            }
        }
    }
    if(j==secondArr.count){
        j=0;
    }
    _secondIndex=j;
    self.secondTypesArr=[NSMutableArray arrayWithArray:secondArr];
    
    
    NSArray *threadArr = [seconddic objectForKey:[secondArr objectAtIndex:j]];
    for(k=0;k<threadArr.count;k++){
        NSString *key=threadArr[k];
        if(thirdStr){
            if([key isEqualToString:thirdStr]){
                break;
            }
        }
    }
    if(k==threadArr.count){
        k=0;
    }
    _threadIndex=k;
     self.threadypesArr=[NSMutableArray arrayWithArray:threadArr];
    _souceArr=[NSMutableArray arrayWithObjects:keyStr,secondArr[j],threadArr[k], nil];
    [self.pickerView selectRow:_firstIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:_secondIndex inComponent:1 animated:NO];
    [self.pickerView selectRow:_threadIndex inComponent:2 animated:NO];
    [self.pickerView reloadComponent:1];
    [self.pickerView reloadComponent:2];
    
    
    
    if(self.titleStr&&self.titleStr.length!=0){
        
        if(![self.promptLab superview]){
            self.promptLab.text=self.titleStr;
             [self.view addSubview:self.promptLab];
        }
    }else{
        if([self.promptLab superview]){
            [self.promptLab removeFromSuperview];
        }
    }
   
    self.grayHeaderView=[UIButton buttonWithType:UIButtonTypeSystem];
    self.grayHeaderView.frame=[UIScreen mainScreen].bounds;
    self.grayHeaderView.tag=10;
    self.grayHeaderView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.grayHeaderView addTarget:self action:@selector(cancelButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.window addSubview:self.grayHeaderView];
    self.view.frame=CGRectMake(0,kHeight+30,kWidth,366*hScale);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=CGRectMake(0,kHeight-700*hScale, kWidth, 700*hScale);
    }];
   
    [self.grayHeaderView addSubview:self.view];
    [self.parent addChildViewController:self];
    
    
    obj=self;
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

#pragma mark 弹出视图移除
-(void)popViewRemoved
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self.grayHeaderView removeFromSuperview];
    obj=nil;
}
#pragma mark buttonHandler
//确认
-(void)okButtonHandler:(UIButton *)_b
{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(threePicker: didSelectedWithTitleArr:)]){
        [self.delegate threePicker:self didSelectedWithTitleArr:self.souceArr];

    }
    [self popViewDisappearWithSucessBlock:^{

    }];

}
//取消
-(void)cancelButtonHandler:(UIButton *)_b
{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(threePickerDidCanceled:)]){
        [self.delegate threePickerDidCanceled:self];
    }
    [self popViewDisappearWithSucessBlock:^{
        
    }];
}
#pragma mark Picker Data Source Methed
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.firstTypesArr count];
    }else if (component == 1){
        return [self.secondTypesArr count];
    }else{
        return [self.threadypesArr count];
    }
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)componen
{
    if (componen == 0) {
        return [self.firstTypesArr objectAtIndex:row];
    }else if (componen == 1){
        return [self.secondTypesArr objectAtIndex:row];
    }else{
        return [self.threadypesArr objectAtIndex:row];
    }
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        if(self.fontSize!=0){
             [pickerLabel setFont:[UIFont boldSystemFontOfSize:self.fontSize]];
        }else{
             [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        }
        if(self.textColor){
            pickerLabel.textColor=self.textColor;
        }else{
            pickerLabel.textColor=[UIColor blackColor];
        }
    
       
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSString *keyStr = nil;
    if (component == 0) {
        _firstIndex = row;
        _secondIndex = 0;
        _threadIndex = 0;
        keyStr = [self.firstTypesArr objectAtIndex:_firstIndex];
        NSDictionary *seconddic = [_dataSource objectForKey:keyStr];
        NSArray *secondArr = [seconddic allKeys];
         secondArr=[secondArr sortedArrayUsingSelector:@selector(compare:)];
         self.secondTypesArr=[NSMutableArray arrayWithArray:secondArr];
        
        NSArray *threadArr = [seconddic objectForKey:[secondArr objectAtIndex:_secondIndex]];
        self.threadypesArr=[NSMutableArray arrayWithArray:threadArr];
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else if (component == 1){
        _secondIndex = row;
        _threadIndex = 0;
        keyStr = [self.firstTypesArr objectAtIndex:_firstIndex];
        NSDictionary *seconddic = [_dataSource objectForKey:keyStr];
        NSArray *secondArr = [seconddic allKeys];
        secondArr=[secondArr sortedArrayUsingSelector:@selector(compare:)];
        self.secondTypesArr=[NSMutableArray arrayWithArray:secondArr];
        NSArray *threadArr = [seconddic objectForKey:[secondArr objectAtIndex:_secondIndex]];
        self.threadypesArr=[NSMutableArray arrayWithArray:threadArr];
        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else if (component == 2){
        _threadIndex = row;
        keyStr = [self.firstTypesArr objectAtIndex:_firstIndex];
        NSDictionary *seconddic = [_dataSource objectForKey:keyStr];
        NSArray *secondArr = [seconddic allKeys];
        secondArr=[secondArr sortedArrayUsingSelector:@selector(compare:)];
        self.secondTypesArr=[NSMutableArray arrayWithArray:secondArr];
        NSArray *threadArr = [seconddic objectForKey:[secondArr objectAtIndex:_secondIndex]];
        self.threadypesArr=[NSMutableArray arrayWithArray:threadArr];
    }
    [self.pickerView reloadComponent:1];
    [self.pickerView reloadComponent:2];
    self.souceArr=[NSMutableArray arrayWithObjects:[self.firstTypesArr objectAtIndex:_firstIndex],self.secondTypesArr[_secondIndex],self.threadypesArr[_threadIndex],nil];
    
    
}
#pragma mark get
-(UIWindow *)window
{
    if(_window==nil){
        _window=[[UIApplication sharedApplication] keyWindow];
    }
    return _window;
}
-(NSMutableArray *)firstTypesArr{
    if(_firstTypesArr==nil){
        _firstTypesArr=[NSMutableArray array];
    }
    return _firstTypesArr;
}
-(NSMutableArray *)secondTypesArr{
    if(_secondTypesArr==nil){
        _secondTypesArr=[NSMutableArray array];
    }
    return _secondTypesArr;
}
-(NSMutableArray *)threadypesArr{
    if(_threadypesArr==nil){
        _threadypesArr=[NSMutableArray array];
    }
    return _threadypesArr;
}
-(NSMutableArray *)souceArr{
    if(_souceArr==nil){
        _souceArr=[NSMutableArray array];
    }
    return _souceArr;
}
@end
