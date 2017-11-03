//
//  HGBNumKeyBord.m
//  Keyboard
//
//  Created by huangguangbao on 16/11/2.
//  Copyright © 2016年 xuqiang. All rights reserved.
//

#import "HGBNumKeyBord.h"
#import "HGBCustomKeyBordTool.h"
#import "HGBCustomKeyBordButton.h"
#import "HGBCustomKeyBordHeader.h"

@interface HGBNumKeyBord()<HGBCustomKeyboardButtonDelegate>

/**
 时间
 */
@property(strong,nonatomic)NSTimer *timer;
@end
@implementation HGBNumKeyBord
static  bool flag=NO;
- (UITextField *)responder{
    //    if (!_responder) {  // 防止多个输入框采用同一个inputview
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow valueForKey:@"firstResponder"];
    _responder = (UITextField *)firstResponder;
    //    }
    return _responder;
}
- (NSArray *)numArray{
    if (!_numArray) {
        _numArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
        
    }
    return _numArray;
}
- (void)setRandom:(BOOL)random{
    _random = random;
    if (random) {
        
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.numArray];
        for(int i = 0; i< self.numArray.count; i++)
        {
            int m = (arc4random() % (self.numArray.count - i)) + i;
            [newArray exchangeObjectAtIndex:i withObjectAtIndex: m];
        }
        self.numArray = newArray;
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
    HGBCustomKeyBordButton *btn1 = [HGBCustomKeyBordButton buttonWithTitle:self.numArray[0] tag:0 delegate:self];
    [self addSubview:btn1];
    
    HGBCustomKeyBordButton *btn2 = [HGBCustomKeyBordButton buttonWithTitle:self.numArray[1] tag:1 delegate:self];
    [self addSubview:btn2];
    
    HGBCustomKeyBordButton *btn3 = [HGBCustomKeyBordButton buttonWithTitle:self.numArray[2] tag:2 delegate:self];
    [self addSubview:btn3];
    
    HGBCustomKeyBordButton *btn4 = [HGBCustomKeyBordButton buttonWithTitle:self.numArray[3] tag:3 delegate:self];
    [self addSubview:btn4];
    
    HGBCustomKeyBordButton *btn5 = [HGBCustomKeyBordButton buttonWithTitle:self.numArray[4] tag:4 delegate:self];
    [self addSubview:btn5];
    
   HGBCustomKeyBordButton *btn6 = [HGBCustomKeyBordButton buttonWithTitle:self.numArray[5] tag:5 delegate:self];
    [self addSubview:btn6];
    
    HGBCustomKeyBordButton *btn7 = [HGBCustomKeyBordButton buttonWithTitle:self.numArray[6] tag:6 delegate:self];
    [self addSubview:btn7];
    
    HGBCustomKeyBordButton *btn8 = [HGBCustomKeyBordButton buttonWithTitle:self.numArray[7] tag:7 delegate:self];
    [self addSubview:btn8];
    
    HGBCustomKeyBordButton *btn9 = [HGBCustomKeyBordButton buttonWithTitle:self.numArray[8] tag:8 delegate:self];
    [self addSubview:btn9];
    
    HGBCustomKeyBordButton *btn0 = [HGBCustomKeyBordButton buttonWithTitle:self.numArray[9] tag:9 delegate:self];
    [self addSubview:btn0];
    
    
    UIButton *wordSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wordSwitchBtn.tag = 10;
    [wordSwitchBtn setTitle:@"ABC" forState:UIControlStateNormal];
    [wordSwitchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    wordSwitchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [wordSwitchBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [wordSwitchBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    
    [self addSubview:wordSwitchBtn];
    
    UIButton *symbolSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [symbolSwitchBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [symbolSwitchBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    [symbolSwitchBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    if(self.keybordType==HGBCustomKeyBordType_NumWordSymbol){
         [symbolSwitchBtn setTitle:@"@%#" forState:UIControlStateNormal];
    }
    symbolSwitchBtn.titleLabel.font = wordSwitchBtn.titleLabel.font;
    symbolSwitchBtn.tag =11;
    [self addSubview:symbolSwitchBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    [deleteBtn setImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/icon_delete"] forState:(UIControlStateNormal)];
    [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0.2*deleteBtn.frame.size.width, 0.2*deleteBtn.frame.size.height, 0.6*deleteBtn.frame.size.width,0.6*deleteBtn.frame.size.height)];
    [self addSubview:deleteBtn];
    deleteBtn.tag = 12;
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okBtn.backgroundColor=[UIColor colorWithRed:16.0/256 green:142.0/256 blue:233.0/256 alpha:256.0/256];
    [self addSubview:okBtn];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadLongBtn"] forState:UIControlStateNormal];

    okBtn.tag = 13;
    
    [wordSwitchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if(self.keybordType==HGBCustomKeyBordType_NumWordSymbol){
        [symbolSwitchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn addTarget:self action:@selector(deleteButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn addTarget:self action:@selector(deleteButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [deleteBtn addTarget:self action:@selector(deleteButtonTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressButtonHandle:)];
    press.minimumPressDuration=0.5;
    [deleteBtn addGestureRecognizer:press];
    
    self.btnArray = btnArray;
    [self.btnArray addObject:btn1];
    [self.btnArray addObject:btn2];
    [self.btnArray addObject:btn3];
    [self.btnArray addObject:btn4];
    [self.btnArray addObject:btn5];
    [self.btnArray addObject:btn6];
    [self.btnArray addObject:btn7];
    [self.btnArray addObject:btn8];
    [self.btnArray addObject:btn9];
    [self.btnArray addObject:btn0];
    [self.btnArray addObject:deleteBtn];
     [self.btnArray addObject:okBtn];
    [self.btnArray addObject:symbolSwitchBtn];
    [self.btnArray addObject:wordSwitchBtn];
   
    
    for (int i = 10; i<13; i++) {
        UIButton *btn = self.btnArray[i];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
    }
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    
    
}
-(void)setKeybordType:(HGBCustomKeyBordType)keybordType{
    _keybordType=keybordType;
    UIButton *button=self.btnArray[self.btnArray.count-2];
    if(keybordType==HGBCustomKeyBordType_NumWordSymbol||keybordType==HGBCustomKeyBordType_WordNumSymbol){
        [button setTitle:@"@%#" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [button setTitle:@"" forState:UIControlStateNormal];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnW = (self.frame.size.width - 5*margin)/4;
    CGFloat btnH = (self.frame.size.height - 5*margin)/4;
    
    for (int i=0;i<self.btnArray.count;i++) {
        HGBCustomKeyBordButton *btn =self.btnArray[i];
        if(i<9){
            btn.frame = CGRectMake(margin + btn.tag % 3 * (btnW + margin), margin + btn.tag / 3 * (btnH + margin), btnW, btnH);
        }else if (i==9){
             btn.frame = CGRectMake(margin + 1 * (btnW + margin), margin + 3* (btnH + margin), btnW, btnH);
        }else if (i==10){
            btn.frame = CGRectMake(margin + 3 * (btnW + margin), margin , btnW, btnH*2+margin);
        }else if (i==11){
            btn.frame = CGRectMake(margin + 3* (btnW + margin), margin + 2 * (btnH + margin), btnW, btnH*2+margin);
        }else if (i==12){
            btn.frame = CGRectMake(margin + 2* (btnW + margin), margin + 3 * (btnH + margin), btnW, btnH);
        }else if (i==13){
            btn.frame = CGRectMake(margin, margin + 3 * (btnH + margin), btnW, btnH);
        }
       
    }
    
}
- (void)switchBtnClick:(UIButton *)btn{
    AudioServicesPlaySystemSound(SOUNDID);
    if ([self.delegate respondsToSelector:@selector(keyboardNumPadDidClickSwitchBtn:)]) {
        [self.delegate keyboardNumPadDidClickSwitchBtn:btn];
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
        if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardNumPadReturnMessage:)]){
            [self.delegate keyboardNumPadReturnMessage:@"dels"];
        }
    }
}
- (void)deleteBtnClick{
    
    [self deleteText];
    
}
-(void)deleteText{
    AudioServicesPlaySystemSound(SOUNDID);
    [HGBCustomKeyBordTool deleteStringForResponder:self.responder];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardNumPadReturnMessage:)]){
        [self.delegate keyboardNumPadReturnMessage:@"del"];
    }

}
- (void)okBtnClick{
    AudioServicesPlaySystemSound(SOUNDID);
    BOOL canReturn = YES;
    if ([self.responder respondsToSelector:@selector(textFieldShouldReturn:)]) {
        canReturn = [self.responder.delegate textFieldShouldReturn:self.responder];
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardNumPadReturnMessage:)]){
        [self.delegate keyboardNumPadReturnMessage:@"ok"];
    }
}

#pragma mark - HGBKeyboardBtnDelegate
-(void)keyboardButtonDidClick:(HGBCustomKeyBordButton *)button{
    AudioServicesPlaySystemSound(SOUNDID);
    if (button.tag >10) return;
    [HGBCustomKeyBordTool appendString:button.titleLabel.text forResponder:self.responder];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardNumPadReturnMessage:)]){
        [self.delegate keyboardNumPadReturnMessage:button.titleLabel.text];
    }
}

@end
