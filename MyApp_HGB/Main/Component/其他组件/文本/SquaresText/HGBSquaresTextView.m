//
//  HGBSquaresTextView.m
//  密码格子
//
//  Created by huangguangbao on 2017/6/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBSquaresTextView.h"
#import "HGBSquareTextField.h"
@interface HGBSquaresTextView ()<HGBSquareTextFieldDelegate>
@property(nonatomic,assign)NSInteger length;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong)NSMutableArray *texts;
@end
@implementation HGBSquaresTextView
#pragma mark 初始化
//实例化整个view
-(instancetype)initWithFrame:(CGRect)frame length:(NSInteger)length
{
    if (self=[super init]) {
        int width=frame.size.width/length;
        _length=length;
        _count=0;
        self.texts=[NSMutableArray array];
        for (int i=0; i<length; i++) {
            HGBSquareTextField *text=[[HGBSquareTextField alloc] initWithFrame:CGRectMake(i*width-2*i, 0, width, width)];
            if (i==0) {
                [text becomeFirstResponder];
                _index=0;
            }

            text.squareTextFieldDelegate=self;
            text.tag=i;
            text.textAlignment=NSTextAlignmentCenter;
            text.tintColor=[UIColor clearColor];
            text.layer.borderWidth=2;
            text.layer.borderColor=[[UIColor lightGrayColor] CGColor];
            text.borderStyle=UITextBorderStyleRoundedRect;
            text.secureTextEntry=YES;
            text.keyboardType=UIKeyboardTypeNumberPad;
            text.font=[UIFont systemFontOfSize:30];
            [text addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];


            //为每个textfield添加遮罩 防止点击
            UIView *cover=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
            [cover setBackgroundColor:[UIColor clearColor]];
            [text addSubview:cover];
            [self addSubview:text];
            [self.texts addObject:text];
        }
        [self setFrame:frame];

    }
    return self;
}
#pragma mark 设置键盘
-(void)setKeybord:(UIView *)keybord{
    _keybord=keybord;
    for (UITextField *text in self.texts) {
        text.inputView=keybord;
    }
    //    self.inputView=keybord;
}
#pragma mark text
//textfield值
-(void)textValueChanged:(UITextField *)textField
{

    if (textField.text.length > 1) {
        textField.text = [NSString stringWithFormat:@"%@",[textField.text substringToIndex:1]];

    }

    if (textField.tag<_length) {
        if ([self getTextLength]>_count) {
            _count=[self getTextLength];
            if (textField.tag!=_length-1) {
                _index++;
                HGBSquareTextField *text= [self.texts objectAtIndex:_index];
                [text becomeFirstResponder];
            }
            else{
                HGBSquareTextField *text= [self.texts objectAtIndex:textField.tag];
                _index=textField.tag;
                [text resignFirstResponder];
                for (UITextField *t in self.texts) {
                    [t resignFirstResponder];
                }
                [self resignFirstResponder];
                if ([self.squareViewDelegate respondsToSelector:@selector(squaresTextView: didFinishWithResult:)]) {
                    [self.squareViewDelegate squaresTextView:self didFinishWithResult:[self getTextString]];
                }
            }
        }
    }

}



//实现键盘删除键的代理方法
-(void)deleteBackward
{
    if (_index>0) {
        if ([self getTextLength]<_count) {
            HGBSquareTextField *text= [self.texts objectAtIndex:_index];
            [text becomeFirstResponder];
            _count=[self getTextLength];
        }else
        {
            _index--;
            _count--;
            HGBSquareTextField *text= [self.texts objectAtIndex:_index];
            text.text=@"";
            [text becomeFirstResponder];
        }
    }
}

#pragma mark 获取
-(NSInteger)getTextLength
{
    NSInteger count=0;
    for (UITextField *text in self.texts) {
        if (text.text.length!=0) {
            count++;
        }else{
            break;
        }
    }
    return count;
}

-(NSString *)getTextString
{
    NSString *textResult=@"";
    for (UITextField *text in self.texts) {
        textResult = [NSString stringWithFormat:@"%@%@",textResult,text.text];
    }
    return textResult;
}
#pragma mark get
-(NSMutableArray *)texts{
    if(_texts==nil){
        _texts=[NSMutableArray array];
    }
    return _texts;
}
@end
