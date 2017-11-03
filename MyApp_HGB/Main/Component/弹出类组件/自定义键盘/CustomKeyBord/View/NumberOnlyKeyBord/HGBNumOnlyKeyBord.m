//
//  HGBNumOnlyKeyBord.m
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBNumOnlyKeyBord.h"
#import "HGBCustomKeyBordTool.h"
#import "HGBCustomKeyBordButton.h"
#import "HGBCustomKeyBordHeader.h"


@interface HGBNumOnlyKeyBord()<HGBCustomKeyboardButtonDelegate>

/**
 时间
 */
@property(strong,nonatomic)NSTimer *timer;
@end

@implementation HGBNumOnlyKeyBord
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
    
    for(int i=0;i<self.numArray.count;i++){
        NSString *num = self.numArray[i];
        UIButton *btn=[UIButton buttonWithType:(UIButtonTypeSystem)];
        [btn setTitle:num forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(keyboardButtonDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.backgroundColor=[UIColor whiteColor];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:24];
        btn.layer.masksToBounds=YES;
        btn.layer.borderColor=[[UIColor grayColor]CGColor];
        btn.layer.borderWidth=0.5;
        btn.tag=i;
        [self addSubview:btn];
        [btnArray addObject:btn];
    }
    
   
    
    
    
    
    UIButton *disappearSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [disappearSwitchBtn setImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/icon_keyword"] forState:(UIControlStateNormal)];
    [disappearSwitchBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [disappearSwitchBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    
    disappearSwitchBtn.tag =10;
    [self addSubview:disappearSwitchBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    [deleteBtn setImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/icon_delete"] forState:(UIControlStateNormal)];
    [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0.2*deleteBtn.frame.size.width, 0.2*deleteBtn.frame.size.height, 0.6*deleteBtn.frame.size.width,0.6*deleteBtn.frame.size.height)];
    [self addSubview:deleteBtn];
    deleteBtn.tag = 11;
    
    
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn addTarget:self action:@selector(deleteButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn addTarget:self action:@selector(deleteButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [deleteBtn addTarget:self action:@selector(deleteButtonTouchUp) forControlEvents:UIControlEventTouchUpOutside];
   
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressButtonHandle:)];
    press.minimumPressDuration=0.5;
    [deleteBtn addGestureRecognizer:press];
    
    self.btnArray = btnArray;
    
    [self.btnArray addObject:disappearSwitchBtn];
    [self.btnArray addObject:deleteBtn];
    
    for (int i = 10; i<12; i++) {
        UIButton *btn = self.btnArray[i];
        btn.backgroundColor=[UIColor whiteColor];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:24];
        btn.layer.masksToBounds=YES;
        btn.layer.borderColor=[[UIColor grayColor]CGColor];
        btn.layer.borderWidth=0.5;
    }
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnW = (self.frame.size.width)/3;
    CGFloat btnH = (self.frame.size.height)/4;
    
    for (int i=0;i<self.btnArray.count;i++) {
        UIButton *btn =self.btnArray[i];
        if(i<9){
            btn.frame = CGRectMake(btn.tag % 3 * (btnW ), btn.tag / 3 * (btnH ), btnW, btnH);
        }else if (i==9){
            btn.frame = CGRectMake( 1 * (btnW ),  3* (btnH ), btnW, btnH);
        }else if (i==10){
            btn.frame = CGRectMake( 0* (btnW ),  3* (btnH ) , btnW, btnH);
            
        }else if (i==11){
            btn.frame = CGRectMake( 2* (btnW ), 3* (btnH ), btnW, btnH);
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
        if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardOnlyNumPadReturnMessage:)]){
            [self.delegate keyboardOnlyNumPadReturnMessage:@"dels"];
        }
    }
}
- (void)deleteBtnClick{
    
    [self deleteText];
    
}
-(void)deleteText{
    AudioServicesPlaySystemSound(SOUNDID);
    [HGBCustomKeyBordTool deleteStringForResponder:self.responder];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardOnlyNumPadReturnMessage:)]){
        [self.delegate keyboardOnlyNumPadReturnMessage:@"del"];
    }
}
#pragma mark - HGBKeyboardBtnDelegate
-(void)keyboardButtonDidClick:(UIButton *)button{
    AudioServicesPlaySystemSound(SOUNDID);
    if (button.tag >10) return;
    [HGBCustomKeyBordTool appendString:button.titleLabel.text forResponder:self.responder];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(keyboardOnlyNumPadReturnMessage:)]){
        [self.delegate keyboardOnlyNumPadReturnMessage:button.titleLabel.text];
    }

}
@end
