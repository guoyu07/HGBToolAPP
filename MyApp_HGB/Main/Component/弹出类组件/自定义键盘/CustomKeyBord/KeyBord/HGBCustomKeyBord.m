//
//  HGBCustomKeyBord.m
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCustomKeyBord.h"
#import "HGBNumKeyBord.h"
#import "HGBWordKeyBord.h"
#import "HGBNumOnlyKeyBord.h"
#import "HGBSymbolKeyBord.h"
#import "HGBCustomKeyBordHeader.h"
#import "HGBCustomKeyBordSquareTextView.h"
#import "HGBKeybordEncryptTool.h"

@interface HGBCustomKeyBord()<HGBWordKeyboardDelegate,HGBNumKeyboardDelegate,HGBSymbolKeyBordDelegate,HGBNumOnlyKeyBordDelegate,HGBCustomKeyBordSquareTextViewDelegate>
/**
 相应
 */
@property (nonatomic, weak)   UITextField *responder;
/**
 纯数字键盘
 */
@property (nonatomic, strong) HGBNumOnlyKeyBord    *numOnlyPad;

/**
 数字键盘
 */
@property (nonatomic, strong) HGBNumKeyBord    *numPad;

/**
 字母键盘
 */
@property (nonatomic, strong) HGBWordKeyBord   *wordPad;
/**
 符号键盘
 */
@property (nonatomic, strong) HGBSymbolKeyBord   *symbolPad;
/**
 表头
 */
@property(strong,nonatomic)UIView *titleView;
/**
 弹出标志
 */
@property(assign,nonatomic)BOOL popFlag;

/**
 弹出视图
 */
@property(strong,nonatomic)UIView *backView;
/**
 显示输入
 */
@property(strong,nonatomic)UITextField *showText;

/**
 格子显示输入
 */
@property(strong,nonatomic)HGBCustomKeyBordSquareTextView *squaresText;
/**
 背景按钮
 */
@property(strong,nonatomic)UIButton *backButton;

/**
 键盘位置
 */
@property(assign,nonatomic)CGFloat keybordy;
/**
 加密密钥
 */
@property(strong,nonatomic)NSString *customKey;
@end

@implementation HGBCustomKeyBord
static  HGBCustomKeyBord *obj = nil;
#pragma mark init
+(instancetype)instance{
    HGBCustomKeyBord *keyBord=[[HGBCustomKeyBord alloc]initWithFrame:CGRectMake(0, 0,kWidth,kWidth*0.576+72*hScale+2)];
    return keyBord;
}
- (instancetype)init{
    self.keybordy=72*hScale+2;
    self = [self initWithFrame:CGRectMake(0, 0,kWidth,kWidth*0.576+self.keybordy)];
    if (self) {
        self.keybordy=72*hScale+2;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:209.0/256 green:214.0/256 blue:218.0/256 alpha:153.0/256];
       
        self.keybordy=72*hScale+2;
        
        //        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        HGBNumKeyBord *numPad = [[HGBNumKeyBord alloc] initWithFrame:CGRectMake(0,self.keybordy, frame.size.width,frame.size.height-self.keybordy)];
        numPad.tag=10;
        numPad.delegate = self;
        numPad.frame=CGRectMake(numPad.frame.origin.x, self.keybordy, numPad.frame.size.width, numPad.frame.size.height);
        self.numPad = numPad;
        [self addSubview:numPad];
        [self setTitleView];
    }
    return self;
}
-(void)setKeybordType:(HGBCustomKeyBordType)keybordType{
    _keybordType=keybordType;
    [self.numPad removeFromSuperview];
    if(_keybordType==HGBCustomKeyBordType_NumWord){
        self.numPad.random=self.random;
        self.numPad.delegate=self;
        [self addSubview:self.numPad];
        [self.wordPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
        [self.numOnlyPad removeFromSuperview];
        
    }else if(_keybordType==HGBCustomKeyBordType_WordNum){
        self.wordPad.random=self.random;
        self.wordPad.delegate=self;
        [self addSubview:self.wordPad];
        [self.numPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
        [self.numOnlyPad removeFromSuperview];
    }else if(_keybordType==HGBCustomKeyBordType_Num){
        self.numOnlyPad.random=self.random;
        self.numOnlyPad.delegate=self;
        [self addSubview:self.numOnlyPad];
        [self.numPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
        [self.wordPad removeFromSuperview];
    }else if(_keybordType==HGBCustomKeyBordType_NumWordSymbol){
        self.numPad.random=self.random;
        self.numPad.delegate=self;
        [self addSubview:self.numPad];
        [self.wordPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
        [self.numOnlyPad removeFromSuperview];
    }else if(_keybordType==HGBCustomKeyBordType_Word){
        self.wordPad.random=self.random;
        self.wordPad.delegate=self;
        [self addSubview:self.wordPad];
        [self.numPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
        [self.numOnlyPad removeFromSuperview];
        
    }else if (keybordType==HGBCustomKeyBordType_WordNumSymbol){
        self.wordPad.random=self.random;
        self.wordPad.delegate=self;
        [self addSubview:self.wordPad];
        [self.numPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
        [self.numOnlyPad removeFromSuperview];
    }
    
}
-(HGBNumOnlyKeyBord *)numOnlyPad{
    if(!_numOnlyPad){
        _numOnlyPad=[[HGBNumOnlyKeyBord alloc] initWithFrame:CGRectMake(0, self.keybordy, self.bounds.size.width, self.bounds.size.height-self.keybordy)];
        _numOnlyPad.tag=10;
        
        if (self.random) _numOnlyPad.random = self.random;
        
    }
    _numOnlyPad.delegate=self;
    _numOnlyPad.frame=CGRectMake(_numOnlyPad.frame.origin.x, self.keybordy, _numOnlyPad.frame.size.width,  _numOnlyPad.frame.size.height);
    return _numOnlyPad;
}
- (HGBNumKeyBord *)numPad{
    if (!_numPad) {
        _numPad = [[HGBNumKeyBord alloc] initWithFrame:CGRectMake(0, self.keybordy, self.bounds.size.width, self.bounds.size.height-self.keybordy)];
        _numPad.tag=10;
        if (self.random) _numPad.random = self.random;
        
        
    }
    _numPad.delegate = self;
    _numPad.keybordType=self.keybordType;
    _numPad.frame=CGRectMake(_numPad.frame.origin.x, self.keybordy, _numPad.frame.size.width,  _numPad.frame.size.height);
    return _numPad;
}
- (HGBWordKeyBord *)wordPad{
    if (!_wordPad) {
        _wordPad = [[HGBWordKeyBord alloc] initWithFrame:CGRectMake(0, self.keybordy, self.bounds.size.width, self.bounds.size.height-self.keybordy)];
        _wordPad.tag=10;
        if (self.random) _wordPad.random = self.random;
        
        
    }
    _wordPad.delegate = self;
    _wordPad.keybordType=self.keybordType;
    _wordPad.frame=CGRectMake(_wordPad.frame.origin.x, self.keybordy, _wordPad.frame.size.width,  _wordPad.frame.size.height);
    return _wordPad;
}
-(HGBSymbolKeyBord *)symbolPad{
    if(!_symbolPad){
        _symbolPad = [[HGBSymbolKeyBord alloc] initWithFrame:CGRectMake(0, self.keybordy, self.bounds.size.width, self.bounds.size.height-self.keybordy)];
        _symbolPad.tag=10;
        if (self.random) _symbolPad.random = self.random;
        
        
    }
    _symbolPad.delegate = self;
    _symbolPad.keybordType=self.keybordType;
    _symbolPad.frame=CGRectMake(_symbolPad.frame.origin.x, self.keybordy, _symbolPad.frame.size.width,  _symbolPad.frame.size.height);
    return _symbolPad;
}
- (UITextField *)responder{
    //    if (!_responder) {  // 防止多个输入框采用同一个inputview
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow valueForKey:@"firstResponder"];
    _responder = (UITextField *)firstResponder;
//    _responder
    //    }
    return _responder;
}
#pragma mark pop
/**
 弹出键盘
 @param parent 父控制器
 */
-(void)popKeyBordInParent:(UIViewController *)parent{
    [self popKeyBordWithType:self.keybordShowType inParent:parent];
}
/**
 弹出键盘
 
 @param showType 弹出类型
 @param parent 父控制器
 */
-(void)popKeyBordWithType:(HGBCustomKeyBordShowType)showType inParent:(UIViewController *)parent{
    
    self.keybordShowType=showType;
    self.popFlag=YES;
    if([obj superview]){
        return;
    }
    self.backButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.backButton.frame=parent.view.frame;
    [self.backButton addTarget:self action:@selector(backButtonHandle:) forControlEvents:(UIControlEventTouchDown)];
    [parent.view addSubview:self.backButton];
    
    self.backView=[[UIView alloc]init];
    self.backView.backgroundColor = [UIColor colorWithRed:209.0/256 green:214.0/256 blue:218.0/256 alpha:153.0/256];
    CGRect backFrame=CGRectZero;
    CGRect selfFrame=self.frame;
    if(showType==HGBCustomKeyBordShowType_Common){
        backFrame=self.frame;
        selfFrame=self.frame;
        self.keybordy=self.keybordy;
        [self.backView addSubview:self];
    }else if(showType==HGBCustomKeyBordShowType_NoTitle){
        if([self.titleView superview]){
            [self.titleView removeFromSuperview];
        }
        self.keybordy=2;
        self.frame=CGRectMake(self.frame.origin.x, self.keybordy, self.frame.size.width,  kWidth*0.576+4);
        backFrame=self.frame;
        selfFrame=self.frame;
        UIView *keybordPadView=[self viewWithTag:10];
         keybordPadView.frame=CGRectMake(keybordPadView.frame.origin.x, 0, keybordPadView.frame.size.width,  selfFrame.size.height);
        [self.backView addSubview:self];
        
    }else if(showType==HGBCustomKeyBordShowType_Text){
        if([self.titleView superview]){
            [self.titleView removeFromSuperview];
        }
        UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0*wScale,0, kWidth, 96*hScale)];
        headview.backgroundColor=[UIColor colorWithRed:209.0/256 green:214.0/256 blue:218.0/256 alpha:153.0/256];
        self.showText=[[UITextField alloc]initWithFrame:CGRectMake(20*wScale,(96*hScale-80*hScale)*0.5+8*hScale, kWidth-40*wScale, 80*hScale)];
        self.showText.inputView=self;
        self.showText.backgroundColor=[UIColor whiteColor];
        self.showText.layer.masksToBounds=YES;
        
        self.showText.layer.borderColor=[[UIColor grayColor]CGColor];
        self.showText.layer.borderWidth=1;
        self.showText.layer.cornerRadius=5;
        [self.showText becomeFirstResponder];
        [headview addSubview:self.showText];
        [self.backView addSubview:headview];
        
        self.keybordy=0;
        self.frame=CGRectMake(self.frame.origin.x, 96*hScale+2, self.frame.size.width, kWidth*0.576+2);
        backFrame=self.frame;
        backFrame.size.height=self.frame.size.height+96*hScale+2;
        selfFrame=self.frame;
        UIView *keybordPadView=[self viewWithTag:10];
        keybordPadView.frame=CGRectMake(keybordPadView.frame.origin.x, 0, self.frame.size.width, selfFrame.size.height);
        
    }else if (showType==HGBCustomKeyBordShowType_Pass){
        if([self.titleView superview]){
            [self.titleView removeFromSuperview];
        }
        UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0*wScale,0, kWidth, 96*hScale)];
        headview.backgroundColor=[UIColor colorWithRed:209.0/256 green:214.0/256 blue:218.0/256 alpha:153.0/256];
        self.showText=[[UITextField alloc]initWithFrame:CGRectMake(20*wScale,(96*hScale-80*hScale)*0.5+8*hScale, kWidth-40*wScale, 80*hScale)];
        self.showText.inputView=self;
        self.showText.backgroundColor=[UIColor whiteColor];
        self.showText.secureTextEntry=YES;
        self.showText.layer.masksToBounds=YES;
        
        self.showText.layer.borderColor=[[UIColor grayColor]CGColor];
        self.showText.layer.borderWidth=1;
        self.showText.layer.cornerRadius=5;
        [self.showText becomeFirstResponder];
        [headview addSubview:self.showText];
        [self.backView addSubview:headview];
        
        self.keybordy=0;
        self.frame=CGRectMake(self.frame.origin.x, 96*hScale+2, self.frame.size.width,  kWidth*0.576+2);
        backFrame=self.frame;
        backFrame.size.height=self.frame.size.height+96*hScale+2;
        selfFrame=self.frame;
        UIView *keybordPadView=[self viewWithTag:10];
         keybordPadView.frame=CGRectMake(keybordPadView.frame.origin.x, 0, keybordPadView.frame.size.width,  selfFrame.size.height);
        _numOnlyPad.frame=CGRectMake(_numOnlyPad.frame.origin.x, self.keybordy, _numOnlyPad.frame.size.width,  _numOnlyPad.frame.size.height);
    }else if (showType==HGBCustomKeyBordShowType_PayPass){
        if([self.titleView superview]){
            [self.titleView removeFromSuperview];
        }
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 90*hScale)];
        titleView.backgroundColor=[UIColor whiteColor];
        [self.backView addSubview:titleView];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/icon_keyboard_close"] forState:(UIControlStateNormal)];
        closeBtn.frame=CGRectMake(5*wScale, 5*hScale, 80*hScale, 80*hScale);
        [closeBtn addTarget:self action:@selector(disappearSwitchBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 10*hScale, kWidth, 70*hScale)];
        titleLab.text=@"请输入支付密码";
        titleLab.textAlignment=NSTextAlignmentCenter;
        [titleView addSubview:titleLab];
        
        [titleView addSubview:closeBtn];
        
        UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0*wScale,90*hScale, kWidth, 180*hScale)];
        
        headview.layer.masksToBounds=YES;
        headview.layer.borderWidth=0.5;
        headview.layer.borderColor=[[UIColor grayColor]CGColor];
        headview.backgroundColor=[UIColor whiteColor];
        self.squaresText=[[HGBCustomKeyBordSquareTextView alloc]initWithFrame:CGRectMake(50*wScale,(160*hScale-120*hScale)*0.5+5*hScale, kWidth-100*wScale, 120*hScale) length:6];
        self.squaresText.keybord=self;
        self.squaresText.squareViewDelegate=self;
        [headview addSubview:self.squaresText];
        [self.backView addSubview:headview];
        
        self.keybordy=0;
        self.frame=CGRectMake(self.frame.origin.x, 270*hScale, self.frame.size.width,  kWidth*0.576);
        backFrame=self.frame;
        backFrame.size.height=self.frame.size.height+270*hScale;
        selfFrame=self.frame;
        UIView *keybordPadView=[self viewWithTag:10];
        keybordPadView.frame=CGRectMake(keybordPadView.frame.origin.x, 0, keybordPadView.frame.size.width,  selfFrame.size.height);
        
        
    }
    
    

    backFrame.origin.y=kHeight;
    self.backView.frame=backFrame;
    self.backView.userInteractionEnabled=YES;


    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.frame=CGRectMake(0,kHeight-self.backView.frame.size.height, kWidth,self.backView.frame.size.height);
        
        
        
    }];
    [parent.view addSubview:self.backView];
    
    obj=self;

}
#pragma mark 转换类delegte
- (void)keyboardNumPadDidClickSwitchBtn:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"ABC"]) {
        self.wordPad.random=self.random;
        [self addSubview:self.wordPad];
        [self.numPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
    }else{
        self.symbolPad.random=self.random;
        [self addSubview:self.symbolPad];
        [self.numPad removeFromSuperview];
        [self.wordPad removeFromSuperview];
    }
}
- (void)keyboardWordPadDidClickSwitchBtn:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"123"]) {
        self.numPad.random=self.random;
        [self addSubview:self.numPad];
        [self.wordPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
    }else{
        self.symbolPad.random=self.random;
        [self addSubview:self.symbolPad];
        [self.numPad removeFromSuperview];
        [self.wordPad removeFromSuperview];
    }
}
-(void)keyboardOnlyNumPadDidClickSwitchBtn:(UIButton *)btn{
    
}
-(void)keyboardSymbolPadDidClickSwitchBtn:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"123"]) {
        self.numPad.random=self.random;
        [self addSubview:self.numPad];
        [self.wordPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
    }else{
        self.wordPad.random=self.random;
        [self addSubview:self.wordPad];
        [self.numPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
    }
}
#pragma mark 数据传输
-(void)keyboardOnlyNumPadReturnMessage:(NSString *)message{
    if((self.keybordShowType!=HGBCustomKeyBordShowType_PayPass)||[message isEqualToString:@"ok"]){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(customKeybord:didReturnMessage:)]){
            [self.delegate customKeybord:self didReturnMessage:[self encryptMessage:message]];
        }
        
    }
    
    if([message isEqualToString:@"ok"]){
        if([self.backButton superview]){
            [self.backButton removeFromSuperview];
        }
        [UIView animateWithDuration:0.2 animations:^{
            if([self.backView superview]){
               self.backView.frame=CGRectMake(0,kHeight, kWidth,self.backView.frame.size.height);
            }
            
        } completion:^(BOOL finished) {
            if([self.backView superview]){
                [self.backView removeFromSuperview];
            }
            obj=nil;
        }];
        if([self.showText superview]){
            [self.showText resignFirstResponder];
        }
        if([self.squaresText superview]){
            [self.squaresText resignFirstResponder];
        }
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        
    }
}
-(void)keyboardNumPadReturnMessage:(NSString *)message{
    if((self.keybordShowType!=HGBCustomKeyBordShowType_PayPass)||[message isEqualToString:@"ok"]){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(customKeybord:didReturnMessage:)]){
            [self.delegate customKeybord:self didReturnMessage:[self encryptMessage:message]];
        }
        
    }
    if([message isEqualToString:@"ok"]){
        if([self.backButton superview]){
            [self.backButton removeFromSuperview];
        }
        [UIView animateWithDuration:0.2 animations:^{
            if([self.backView superview]){
                self.backView.frame=CGRectMake(0,kHeight, kWidth,self.backView.frame.size.height);
            }
        } completion:^(BOOL finished) {
            if([self.backView superview]){
                [self.backView removeFromSuperview];
            }
            obj=nil;
        }];
        if([self.showText superview]){
            [self.showText resignFirstResponder];
        }
        if([self.squaresText superview]){
            [self.squaresText resignFirstResponder];
        }

        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }
}
-(void)keyboardWordPadReturnMessage:(NSString *)message{
    if((self.keybordShowType!=HGBCustomKeyBordShowType_PayPass)||[message isEqualToString:@"ok"]){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(customKeybord:didReturnMessage:)]){
            [self.delegate customKeybord:self didReturnMessage:[self encryptMessage:message]];
        }
        
    }
    if([message isEqualToString:@"ok"]){
        if([self.backButton superview]){
            [self.backButton removeFromSuperview];
        }
        [UIView animateWithDuration:0.2 animations:^{
            if([self.backView superview]){
                self.backView.frame=CGRectMake(0,kHeight, kWidth,self.backView.frame.size.height);
            }
        } completion:^(BOOL finished) {
            if([self.backView superview]){
                [self.backView removeFromSuperview];
            }
            obj=nil;
        }];
        
        if([self.showText superview]){
            [self.showText resignFirstResponder];
        }
        if([self.squaresText superview]){
            [self.squaresText resignFirstResponder];
        }
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }
    
}
-(void)keyboardSymbolPadReturnMessage:(NSString *)message{
    if((self.keybordShowType!=HGBCustomKeyBordShowType_PayPass)||[message isEqualToString:@"ok"]){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(customKeybord:didReturnMessage:)]){
            [self.delegate customKeybord:self didReturnMessage:[self encryptMessage:message]];
        }
        
    }
    if([message isEqualToString:@"ok"]){
        if([self.backButton superview]){
            [self.backButton removeFromSuperview];
        }
        [UIView animateWithDuration:0.2 animations:^{
            if([self.backView superview]){
                self.backView.frame=CGRectMake(0,kHeight, kWidth,self.backView.frame.size.height);
            }
        } completion:^(BOOL finished) {
            if([self.backView superview]){
                [self.backView removeFromSuperview];
            }
            obj=nil;
        }];
        if([self.showText superview]){
            [self.showText resignFirstResponder];
        }
        if([self.squaresText superview]){
            [self.squaresText resignFirstResponder];
        }

        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }
}
-(void)squaresTextView:(HGBCustomKeyBordSquareTextView *)squaresText didFinishWithResult:(NSString *)result{
    
    if(self.delegate&&[self.delegate respondsToSelector:@selector(customKeybord:didReturnMessage:)]){
        [self.delegate customKeybord:self didReturnMessage:[self encryptMessage:result]];
    }
    [self disappearSwitchBtnClick];

}
#pragma mark 设置
- (void)setRandom:(BOOL)random{
    _random = random;
    self.numPad.random = random;
    self.wordPad.random=random;
    self.numOnlyPad.random=random;
    self.symbolPad.random=random;
}
-(void)layoutSubviews{
    [super layoutSubviews];
   
    self.numPad.random=self.random;
    self.wordPad.random=self.random;
}
#pragma mark 加密设置
-(NSString *)encryptMessage:(NSString *)message{
    NSString *msg=[message copy];
    if(self.encryptKey&&self.encryptKey.length!=0){
        if(self.keybordEncryptType==HGBCustomKeyBordEncryptType__TTAlgorithmSM4){
            if(self.encryptKey.length==16){
                msg=[HGBKeybordEncryptTool encryptStringWithTTAlgorithmSM4_ECB:msg andWithKey:self.encryptKey];
            }
        }else if (self.keybordEncryptType==HGBCustomKeyBordEncryptType_DES){
            msg=[HGBKeybordEncryptTool encryptStringWithDES:msg andWithKey:self.encryptKey];

        }else if (self.keybordEncryptType==HGBCustomKeyBordEncryptType_AES){
            msg=[HGBKeybordEncryptTool encryptStringWithAES256:msg andWithKey:self.encryptKey];

        }else{
            msg=message;
        }
    }else{
        msg=message;
    }
    return msg;
}
#pragma mark 设置标题
-(void)setTitleView{
    
     NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    self.titleView=[[UIView alloc]initWithFrame:CGRectMake(0,2, kWidth, 72*hScale)];
    //    self.titleView.layer.cornerRadius = 5;
    //    self.titleView.layer.masksToBounds = YES;
    self.titleView.backgroundColor=[UIColor whiteColor];
    UIImageView *promptImageView=[[UIImageView alloc]initWithFrame:CGRectMake(24*wScale, 21*hScale, 30*wScale, 30*hScale)];
    NSString *icon = [[infoDictionary valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage *image=[UIImage imageNamed:icon];
    if(!image){
        image=[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/prompt"];
    }
    promptImageView.image=image;
   
    [self.titleView addSubview:promptImageView];
    
    UILabel *promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(68*wScale, 24*hScale, kWidth-120*wScale, 24*hScale)];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    promptLabel.text=@"安全输入";
    if(app_Name&&app_Name.length>0){
        promptLabel.text=[NSString stringWithFormat:@"%@安全输入",app_Name];
    }
    promptLabel.textColor=[UIColor colorWithRed:102.0/256 green:102.0/256 blue:102.0/256 alpha:256.0/256];
    promptLabel.font=[UIFont systemFontOfSize:24*hScale];
    [self.titleView addSubview:promptLabel];
    
    UIButton *disappearSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    disappearSwitchBtn.frame=CGRectMake(CGRectGetMaxX(self.titleView.frame)-100*wScale, 15*hScale, 85*wScale, 42*hScale);
    [disappearSwitchBtn addTarget:self action:@selector(disappearSwitchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [disappearSwitchBtn setImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/icon_keyword"] forState:(UIControlStateNormal)];
    [disappearSwitchBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [disappearSwitchBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    
    disappearSwitchBtn.tag =10;
    [self.titleView addSubview:disappearSwitchBtn];
    
    
    
    if(![self.titleView superview]){
        [self addSubview:self.titleView];
    }
}
-(void)disappearSwitchBtnClick{
    [self disappearSwitchBtnClickWithBlock:^{
        
    }];
}
- (void)disappearSwitchBtnClickWithBlock:(CompleteBlock)completeBlock{
    AudioServicesPlaySystemSound(SOUNDID);
    BOOL canReturn = YES;
    if ([self.responder respondsToSelector:@selector(textFieldShouldReturn:)]) {
        canReturn = [self.responder.delegate textFieldShouldReturn:self.responder];
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(customKeybord:didReturnMessage:)]){
        [self.delegate customKeybord:self didReturnMessage:@"ok"];
    }
    if([self.showText superview]){
        [self.showText resignFirstResponder];
    }
    if([self.squaresText superview]){
        [self.squaresText resignFirstResponder];
    }
    if([self.backButton superview]){
        [self.backButton removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        if([self.backView superview]){
            self.backView.frame=CGRectMake(0,kHeight, kWidth,self.backView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if([self.backView superview]){
            [self.backView removeFromSuperview];
        }
    }];
    completeBlock();
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    obj=nil;
    
}
-(void)backButtonHandle:(UIButton *)_b{
    if([self.showText superview]){
        [self.showText resignFirstResponder];
    }
    if([self.squaresText superview]){
        [self.squaresText resignFirstResponder];
    }
    [self disappearSwitchBtnClick];
}
@end
