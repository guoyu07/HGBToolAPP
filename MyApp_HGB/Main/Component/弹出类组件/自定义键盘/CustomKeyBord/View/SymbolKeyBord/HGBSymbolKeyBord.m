//
//  HGBSymbolKeyBord.m
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBSymbolKeyBord.h"
#import "HGBCustomKeyBordButton.h"
#import "HGBCustomKeyBordTool.h"
#import "HGBCustomKeyBordHeader.h"
#import "HGBKeybordPromptView.h"
@interface HGBSymbolKeyBord()<HGBCustomKeyboardButtonDelegate>
/**
 时间
 */
@property(strong,nonatomic)NSTimer *timer;
/**
 提示
 */
@property(strong,nonatomic)HGBKeybordPromptView *promptView;
@end
@implementation HGBSymbolKeyBord
static  bool flag=NO;
#pragma mark get
-(HGBKeybordPromptView *)promptView{
    if(_promptView==nil){
        CGFloat smallBtnW = (self.frame.size.width - 13*margin)/10;
        CGFloat btnH = (self.frame.size.height - 5*margin)/4;
        _promptView=[[HGBKeybordPromptView alloc]initWithFrame:CGRectMake(0, 0, smallBtnW*1.83,smallBtnW*1.83*1.87)];
        _promptView.layer.cornerRadius = 5.0;
        _promptView.layer.masksToBounds = YES;
        _promptView.titleLable.frame=CGRectMake(5*wScale, 5*hScale, smallBtnW*1.83-10*wScale,smallBtnW*1.83*1.87-btnH-10*hScale);
        _promptView.titleLable.font=[UIFont systemFontOfSize:smallBtnW*1.83*1.87-btnH-10*hScale];
        
    }
    return _promptView;
}
- (UITextField *)responder{
    //    if (!_responder) {  // 防止多个输入框采用同一个inputview
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow valueForKey:@"firstResponder"];
    _responder = (UITextField *)firstResponder;
    //    }
    return _responder;
}
- (NSArray *)symbolArray{
    if (!_symbolArray) {
        _symbolArray = @[@"*",@"/",@":",@";",@"(",@")",@"[",@"]",@"$",@"=",@"!",@"^",@"&",@"%",@"+",@"-",@"￥",@"?",@"{",@"}",@"#",@"_",@"\\",@"|",@"~",@"`",@"∑",@"€",@"£",@"。"];
    }
    return _symbolArray;
}
- (void)setRandom:(BOOL)random{
    _random = random;
    if (random) {
        
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.symbolArray];
        for(int i = 0; i< self.symbolArray.count; i++)
        {
            int m = (arc4random() % (self.symbolArray.count - i)) + i;
            [newArray exchangeObjectAtIndex:i withObjectAtIndex: m];
        }
        self.symbolArray = newArray;
        for (UIButton *btn in self.subviews) {
            [btn removeFromSuperview];
        }
        [self addControl];
    }
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addControl];
    }
    
    return self;
}
- (void)addControl{
    NSMutableArray *btnArray = [NSMutableArray array];
    for (int i = 0; i < 30; i++) {
        HGBCustomKeyBordButton *btn = [HGBCustomKeyBordButton buttonWithTitle:self.symbolArray[i] tag:i delegate:self];
        [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:(UIControlEventTouchDown)];
        [btn addTarget:self action:@selector(btnTouchCancel:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn addTarget:self action:@selector(btnTouchCancel:) forControlEvents:(UIControlEventTouchUpOutside)];
        [btn addTarget:self action:@selector(btnTouchCancel:) forControlEvents:(UIControlEventTouchCancel)];
        [self addSubview:btn];
        [btnArray addObject:btn];
    }
    
    
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/icon_delete"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn addTarget:self action:@selector(deleteButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn addTarget:self action:@selector(deleteButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [deleteBtn addTarget:self action:@selector(deleteButtonTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:deleteBtn];
    
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressButtonHandle:)];
    press.minimumPressDuration=0.5;
    [deleteBtn addGestureRecognizer:press];
    
    
    UIButton *numPadCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [numPadCheckBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [numPadCheckBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [numPadCheckBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    [numPadCheckBtn setTitle:@"123" forState:UIControlStateNormal];
    numPadCheckBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [numPadCheckBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:numPadCheckBtn];
    
    UIButton *wordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wordBtn setTitle:@"ABC" forState:UIControlStateNormal];
    [wordBtn setTitle:@"ABC" forState:UIControlStateNormal];
    [wordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    wordBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [wordBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [wordBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    wordBtn.titleLabel.textColor = numPadCheckBtn.titleLabel.textColor;
    [wordBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:wordBtn];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    okBtn.layer.cornerRadius = 5;
    okBtn.layer.masksToBounds = YES;
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okBtn.backgroundColor=[UIColor colorWithRed:16.0/256 green:142.0/256 blue:233.0/256 alpha:256.0/256];
    okBtn.titleLabel.textColor = numPadCheckBtn.titleLabel.textColor;
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
    
    [btnArray addObject:numPadCheckBtn];
    [btnArray addObject:wordBtn];
    [btnArray addObject:deleteBtn];
    [btnArray addObject:okBtn];
    
    
    okBtn.layer.cornerRadius = 5.0;
    okBtn.layer.masksToBounds = YES;
    numPadCheckBtn.layer.cornerRadius = 5.0;
    numPadCheckBtn.layer.masksToBounds = YES;
    wordBtn.layer.cornerRadius = 5.0;
    wordBtn.layer.masksToBounds = YES;
    deleteBtn.layer.cornerRadius = 5.0;
    deleteBtn.layer.masksToBounds = YES;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    
    self.btnArray = btnArray;
}
-(void)btnTouchDown:(HGBCustomKeyBordButton *)_b{
    self.promptView.frame=CGRectMake(CGRectGetMidX(_b.frame)-CGRectGetWidth(self.promptView.frame)*0.5,CGRectGetMaxY( _b.frame)-CGRectGetHeight(self.promptView.frame), CGRectGetWidth(self.promptView.frame), CGRectGetHeight(self.promptView.frame));
    self.promptView.titleLable.text=_b.titleLabel.text;
    if(![self.promptView superview]){
        [self addSubview:self.promptView];
    }
}
-(void)btnTouchCancel:(HGBCustomKeyBordButton *)_b{
    if([self.promptView superview]){
        [self.promptView removeFromSuperview];
    }
}
-(void)deleteButtonTouchUp{
    flag=YES;
}
-(void)deleteButtonTouchDown{
    flag=NO;
}
-(void)longPressButtonHandle:(UILongPressGestureRecognizer *)gesture{
    if(flag==NO){
        flag=YES;
        self.responder.text=@"";
        if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardSymbolPadReturnMessage:)]){
            [self.delegate keyboardSymbolPadReturnMessage:@"dels"];
        }
    }
}
- (void)deleteBtnClick{
    
    [self deleteText];
    
}
-(void)deleteText{
    AudioServicesPlaySystemSound(SOUNDID);
    [HGBCustomKeyBordTool deleteStringForResponder:self.responder];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardSymbolPadReturnMessage:)]){
        [self.delegate keyboardSymbolPadReturnMessage:@"del"];
    }
}
- (void)switchBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(keyboardSymbolPadDidClickSwitchBtn:)]) {
        [self.delegate keyboardSymbolPadDidClickSwitchBtn:btn];
    }
}
- (void)okBtnClick{
    BOOL canReturn = YES;
    if ([self.responder respondsToSelector:@selector(textFieldShouldReturn:)]) {
        canReturn = [self.responder.delegate textFieldShouldReturn:self.responder];
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardSymbolPadReturnMessage:)]){
        [self.delegate keyboardSymbolPadReturnMessage:@"ok"];
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnW = (self.frame.size.width - 13*margin)/10;
    CGFloat btnH = (self.frame.size.height - 5*margin)/4;
    
    for (int i = 0; i < 30; i++) {
        HGBCustomKeyBordButton *btn = self.btnArray[i];
        btn.frame = CGRectMake(2*margin + (i%10)*(btnW + margin), margin + (i/10)*(margin + btnH), btnW, btnH);
    }
    
    CGFloat bigBtnW = (self.frame.size.width - 7*margin)/4;
    UIButton *numPadCheckBtn=self.btnArray[self.btnArray.count-4];
    numPadCheckBtn.frame = CGRectMake(2*margin, 4*margin + btnH*3, bigBtnW, btnH);
    UIButton *wordBtn=self.btnArray[self.btnArray.count-3];
    wordBtn.frame = CGRectMake(3*margin+bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    UIButton *deleteBtn=self.btnArray[self.btnArray.count-2];
    deleteBtn.frame = CGRectMake(4*margin + 2*bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(deleteBtn.frame.size.width*0.1,deleteBtn.frame.size.height*0.25,deleteBtn.frame.size.width*0.1,deleteBtn.frame.size.height*0.25)];
    UIButton *okBtn=self.btnArray[self.btnArray.count-1];
    okBtn.frame = CGRectMake(5*margin + 3*bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    
}

#pragma mark - KeyboardBtnDelegate
-(void)keyboardButtonDidClick:(HGBCustomKeyBordButton *)button{
    [HGBCustomKeyBordTool appendString:button.titleLabel.text forResponder:self.responder];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardSymbolPadReturnMessage:)]){
        [self.delegate keyboardSymbolPadReturnMessage:button.titleLabel.text];
    }
}
@end
