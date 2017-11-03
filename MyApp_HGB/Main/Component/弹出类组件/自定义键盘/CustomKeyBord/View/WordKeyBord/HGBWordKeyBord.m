//
//  HGBWordKeyBord.m
//  Keyboard
//
//  Created by huangguangbao on 16/11/2.
//  Copyright © 2016年 xuqiang. All rights reserved.
//

#import "HGBWordKeyBord.h"
#import "HGBCustomKeyBordButton.h"
#import "HGBCustomKeyBordTool.h"
#import "HGBCustomKeyBordHeader.h"
#import "HGBKeybordPromptView.h"

@interface HGBWordKeyBord()<HGBCustomKeyboardButtonDelegate>
/**
 时间
 */
@property(strong,nonatomic)NSTimer *timer;
/**
 提示
 */
@property(strong,nonatomic)HGBKeybordPromptView *promptView;
@end
@implementation HGBWordKeyBord
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
- (NSArray *)wordArray{
    if (!_wordArray) {
        _wordArray = @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"];
    }
    return _wordArray;
}
- (void)setRandom:(BOOL)random{
    _random = random;
    if (random) {
        
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.wordArray];
        for(int i = 0; i< self.wordArray.count; i++)
        {
            int m = (arc4random() % (self.wordArray.count - i)) + i;
            [newArray exchangeObjectAtIndex:i withObjectAtIndex: m];
        }
        self.wordArray = newArray;
        for (UIButton *btn in self.subviews) {
            [btn removeFromSuperview];
        }
        [self addControl];
    }
    
}
#pragma mark init
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
    for (int i = 0; i< 26; i++) {// 添加26个英文字母
        HGBCustomKeyBordButton *btn = [HGBCustomKeyBordButton buttonWithTitle:self.wordArray[i] tag:i delegate:self];
        [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:(UIControlEventTouchDown)];
         [btn addTarget:self action:@selector(btnTouchCancel:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn addTarget:self action:@selector(btnTouchCancel:) forControlEvents:(UIControlEventTouchUpOutside)];
         [btn addTarget:self action:@selector(btnTouchCancel:) forControlEvents:(UIControlEventTouchCancel)];
        [btnArray addObject:btn];
        [self addSubview:btn];
    }
    
    
    HGBCustomKeyBordButton *blankBtn = [HGBCustomKeyBordButton buttonWithTitle:@"" tag:26 delegate:self];
    if(self.keybordType==HGBCustomKeyBordType_NumWordSymbol||self.keybordType==HGBCustomKeyBordType_WordNumSymbol){
         [blankBtn setTitle:@"空格" forState:UIControlStateNormal];
    }else{
         [blankBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    [self addSubview:blankBtn];
    
    
    UIButton *symbolSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [symbolSwitchBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [symbolSwitchBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    [symbolSwitchBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [symbolSwitchBtn setTitle:@"@%#" forState:UIControlStateNormal];
    [symbolSwitchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     [self addSubview:symbolSwitchBtn];
    if(self.keybordType==HGBCustomKeyBordType_NumWordSymbol){

        symbolSwitchBtn.hidden=YES;
       
    }
    
   
    
    
    
    UIButton *trasitionWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [trasitionWordBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [trasitionWordBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    [trasitionWordBtn setImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/icon_daxie"] forState:UIControlStateNormal];
    [trasitionWordBtn setImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/icon_pressed_daxie"] forState:UIControlStateSelected];
    trasitionWordBtn.layer.cornerRadius = 5;
    trasitionWordBtn.layer.masksToBounds = YES;
    
    [trasitionWordBtn addTarget:self action:@selector(trasitionWord:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:trasitionWordBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/icon_delete"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    deleteBtn.layer.cornerRadius = 5;
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn addTarget:self action:@selector(deleteButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn addTarget:self action:@selector(deleteButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [deleteBtn addTarget:self action:@selector(deleteButtonTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:deleteBtn];
    
    UIButton *numPadCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [numPadCheckBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [numPadCheckBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
     [numPadCheckBtn setTitle:@"123" forState:UIControlStateNormal];
    numPadCheckBtn.layer.cornerRadius = 5;
    numPadCheckBtn.layer.masksToBounds = YES;
    [numPadCheckBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    numPadCheckBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [numPadCheckBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:numPadCheckBtn];
    
    
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
//    [okBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
//    [okBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
   
    okBtn.layer.cornerRadius = 5;
    okBtn.layer.masksToBounds = YES;
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
     okBtn.backgroundColor=[UIColor colorWithRed:16.0/256 green:142.0/256 blue:233.0/256 alpha:256.0/256];
    [self addSubview:okBtn];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressButtonHandle:)];
    press.minimumPressDuration=0.5;
    [deleteBtn addGestureRecognizer:press];
    
    [btnArray addObject:trasitionWordBtn];
    [btnArray addObject:deleteBtn];
    [btnArray addObject:numPadCheckBtn];
    [btnArray addObject:blankBtn];
    [btnArray addObject:symbolSwitchBtn];
    [btnArray addObject:okBtn];
    
    
    numPadCheckBtn.layer.cornerRadius = 5.0;
    numPadCheckBtn.layer.masksToBounds = YES;
    
    okBtn.layer.cornerRadius = 5.0;
    okBtn.layer.masksToBounds = YES;
  
    
    deleteBtn.layer.cornerRadius = 5.0;
    deleteBtn.layer.masksToBounds = YES;
    
    symbolSwitchBtn.layer.cornerRadius = 5.0;
    symbolSwitchBtn.layer.masksToBounds = YES;
    
    
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

- (void)trasitionWord:(UIButton *)trasitionWordBtn{
    AudioServicesPlaySystemSound(SOUNDID);
    trasitionWordBtn.selected = !trasitionWordBtn.selected;
    if (trasitionWordBtn.selected) {
        for (int i = 0; i<26; i++) {
            HGBCustomKeyBordButton *btn = self.btnArray[i];
            [btn setTitle:[btn.titleLabel.text uppercaseString] forState:UIControlStateNormal];
        }
    }else{
        for (int i = 0; i<26; i++) {
            HGBCustomKeyBordButton *btn = self.btnArray[i];
            [btn setTitle:[btn.titleLabel.text lowercaseString] forState:UIControlStateNormal];
        }
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
        if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardWordPadReturnMessage:)]){
            [self.delegate keyboardWordPadReturnMessage:@"dels"];
        }
    }
}
- (void)deleteBtnClick{
    
    [self deleteText];
    
}
-(void)deleteText{
    AudioServicesPlaySystemSound(SOUNDID);
    [HGBCustomKeyBordTool deleteStringForResponder:self.responder];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardWordPadReturnMessage:)]){
        [self.delegate keyboardWordPadReturnMessage:@"del"];
    }
}
- (void)switchBtnClick:(UIButton *)btn{
    AudioServicesPlaySystemSound(SOUNDID);
    if(self.keybordType!=HGBCustomKeyBordType_Word){
        if ([self.delegate respondsToSelector:@selector(keyboardWordPadDidClickSwitchBtn:)]) {
            [self.delegate keyboardWordPadDidClickSwitchBtn:btn];
        }
    }
}
- (void)okBtnClick{
    AudioServicesPlaySystemSound(SOUNDID);
    BOOL canReturn = YES;
    if ([self.responder respondsToSelector:@selector(textFieldShouldReturn:)]) {
        canReturn = [self.responder.delegate textFieldShouldReturn:self.responder];
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardWordPadReturnMessage:)]){
        [self.delegate keyboardWordPadReturnMessage:@"ok"];
    }
}
-(void)setKeybordType:(HGBCustomKeyBordType)keybordType{
    _keybordType=keybordType;
    CGFloat btnH = (self.frame.size.height - 5*margin)/4;
    CGFloat bigBtnW = (self.frame.size.width - 5*margin)/4;
    UIButton *numPadCheckBtn=self.btnArray[28];
    HGBCustomKeyBordButton *blankBtn = [self.btnArray objectAtIndex:29];
    UIButton *symbolBtn = [self.btnArray objectAtIndex:30];
    if(keybordType==HGBCustomKeyBordType_NumWordSymbol||keybordType==HGBCustomKeyBordType_WordNumSymbol){
        blankBtn.frame = CGRectMake(2*margin+bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
        [blankBtn setTitle:@"空格" forState:UIControlStateNormal];
        symbolBtn.hidden=NO;
        symbolBtn.frame = CGRectMake(3*margin + 2*bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
       
    }else if (self.keybordType==HGBCustomKeyBordType_Word) {
        blankBtn.frame = CGRectMake(2*margin+bigBtnW, 4*margin + btnH*3, bigBtnW*2+margin, btnH);
        [blankBtn setTitle:@"空格" forState:UIControlStateNormal];
        [numPadCheckBtn setTitle:@"" forState:UIControlStateNormal];
        symbolBtn.hidden=YES;
    }else{
        blankBtn.frame = CGRectMake(2*margin+bigBtnW, 4*margin + btnH*3, bigBtnW*2+margin, btnH);
        [blankBtn setTitle:@"" forState:UIControlStateNormal];
        symbolBtn.hidden=YES;
        [blankBtn setTitle:@"空格" forState:UIControlStateNormal];
        
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat smallBtnW = (self.frame.size.width - 13*margin)/10;
    CGFloat btnH = (self.frame.size.height - 5*margin)/4;
    
    for (int i = 0; i < 10; i++) {
        HGBCustomKeyBordButton *btn = self.btnArray[i];
        btn.frame = CGRectMake(2*margin + i*(smallBtnW + margin), margin, smallBtnW, btnH);
    }
    
    CGFloat margin2 = (self.frame.size.width - 8*margin - 9*smallBtnW)/2;
    for (int i = 10; i < 19; i++) {
        HGBCustomKeyBordButton *btn = self.btnArray[i];
        btn.frame = CGRectMake(margin2 + (i-10)*(smallBtnW + margin), 2*margin + btnH, smallBtnW, btnH);
    }
    
    CGFloat margin3 = (self.frame.size.width - 9.5*smallBtnW - 6*margin)/4;
    UIButton *trasitionWordBtn=self.btnArray[26];
    
    trasitionWordBtn.frame = CGRectMake(margin3, 3*margin + 2*btnH, smallBtnW*1.5, btnH);
   
    [trasitionWordBtn setImageEdgeInsets:UIEdgeInsetsMake(trasitionWordBtn.frame.size.width*0.3,trasitionWordBtn.frame.size.height*0.3,trasitionWordBtn.frame.size.width*0.3,trasitionWordBtn.frame.size.height*0.3)];
    
    UIButton *deleteBtn=self.btnArray[27];
    deleteBtn.frame = CGRectMake(margin3*3 + 6*margin + 8*smallBtnW, 3*margin + 2*btnH, smallBtnW * 1.5, btnH);
    
     [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(deleteBtn.frame.size.width*0.2,deleteBtn.frame.size.height*0.2,deleteBtn.frame.size.width*0.2,deleteBtn.frame.size.height*0.2)];
    for (int i = 19; i<26; i++) {
        HGBCustomKeyBordButton *btn = self.btnArray[i];
        btn.frame = CGRectMake(margin2 + (i-18)*(smallBtnW + margin), 3*margin + 2*btnH, smallBtnW, btnH);
    }
    CGFloat bigBtnW = (self.frame.size.width - 5*margin)/4;
    
    UIButton *numPadCheckBtn=self.btnArray[28];
    numPadCheckBtn.frame = CGRectMake(margin, 4*margin + btnH*3, bigBtnW, btnH);
    HGBCustomKeyBordButton *blankBtn = [self.btnArray objectAtIndex:29];
     UIButton *symbolBtn = [self.btnArray objectAtIndex:30];
    if(self.keybordType==HGBCustomKeyBordType_NumWordSymbol||self.keybordType==HGBCustomKeyBordType_WordNumSymbol){
        blankBtn.frame = CGRectMake(2*margin+bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
        [blankBtn setTitle:@"空格" forState:UIControlStateNormal];
        symbolBtn.frame = CGRectMake(3*margin + 2*bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
        symbolBtn.hidden=NO;
        
    }else if (self.keybordType==HGBCustomKeyBordType_Word) {
        blankBtn.frame = CGRectMake(2*margin+bigBtnW, 4*margin + btnH*3, bigBtnW*2+margin, btnH);
        [blankBtn setTitle:@"空格" forState:UIControlStateNormal];
        [numPadCheckBtn setTitle:@"" forState:UIControlStateNormal];
        symbolBtn.hidden=YES;
    }else{
        blankBtn.frame = CGRectMake(2*margin+bigBtnW, 4*margin + btnH*3, bigBtnW*2+margin, btnH);
        [blankBtn setTitle:@"" forState:UIControlStateNormal];
        symbolBtn.hidden=YES;
        [blankBtn setTitle:@"空格" forState:UIControlStateNormal];
        
    }
    UIButton *okBtn = [self.btnArray objectAtIndex:31];
    okBtn.frame = CGRectMake(4*margin + 3*bigBtnW, 4*margin + btnH*3, bigBtnW, btnH);
    
}

#pragma mark - KeyboardBtnDelegate
- (void)keyboardButtonDidClick:(HGBCustomKeyBordButton *)button{
    AudioServicesPlaySystemSound(SOUNDID);
    NSString *newText = button.titleLabel.text;
    if (newText.length==0) {
        return;
    }
    if([newText isEqualToString:@"空格"]){
        [HGBCustomKeyBordTool appendString:@" " forResponder:self.responder];
        if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardWordPadReturnMessage:)]){
            [self.delegate keyboardWordPadReturnMessage:@" "];
        }
        return;
    }
    
    [HGBCustomKeyBordTool appendString:newText forResponder:self.responder];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardWordPadReturnMessage:)]){
        [self.delegate keyboardWordPadReturnMessage:button.titleLabel.text];
    }
    
    
}
@end
