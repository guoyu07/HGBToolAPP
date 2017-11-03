//
//  HGBSearchBar.m
//  CTTX
//
//  Created by huangguangbao on 2017/2/21.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBSearchBar.h"



#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0

@interface HGBSearchBar()<UITextFieldDelegate>
@property(strong,nonatomic)UITextField *seachbarText;
@property(strong,nonatomic)UIButton *backview;
@property(strong,nonatomic)UIButton *searchButton;
@end
@implementation HGBSearchBar
#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewSetUp];
    }
    return self;
}
#pragma mark view
-(void)viewSetUp{
    self.backview=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.backview.backgroundColor=[UIColor clearColor];
    self.backview.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.backview.layer.masksToBounds=YES;
    self.backview.layer.borderColor=[UIColor colorWithRed:217.0/256 green:217.0/256 blue:217.0/256 alpha:1].CGColor;;
    [self.backview addTarget:self action:@selector(backButtonHandle:) forControlEvents:(UIControlEventTouchDown)];
    self.backview.layer.borderWidth=0.5;
  self.backview.layer.cornerRadius=4*hScale;
    [self addSubview:self.backview];
    
    self.seachbarText=[[UITextField alloc]initWithFrame:CGRectMake(24*wScale,(self.backview.frame.size.height-30)*0.5,self.backview.frame.size.width-96*wScale, 30)];
    self.seachbarText.delegate=self;
//    self.seachbarText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.seachbarText addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:(UIControlEventEditingChanged)];
    self.seachbarText.returnKeyType=UIReturnKeyDone;
    self.seachbarText.placeholder=_placeholder;
    self.seachbarText.text=_text;
    self.seachbarText.backgroundColor=[UIColor clearColor];
    [self.backview addSubview:self.seachbarText];
    
    self.searchButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.searchButton.frame=CGRectMake(self.backview.frame.size.width-62*wScale,(self.backview.frame.size.height-31*hScale)*0.5 ,31*wScale, 31*hScale);
    
    [self.searchButton addTarget:self action:@selector(searchButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.searchButton setBackgroundImage:[UIImage imageNamed:@"HGBSearchBarBundle.bundle/search.png"] forState:(UIControlStateNormal)];
    [self.backview addSubview:self.searchButton];
    
}
#pragma mark set
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder=placeholder;
    self.seachbarText.placeholder=_placeholder;
}
-(void)setText:(NSString *)text{
    _text=text;
    self.seachbarText.text=_text;
}
-(void)setTextColor:(UIColor *)textColor{
    _textColor=textColor;
    self.seachbarText.textColor=textColor;
}
-(void)setSearchImage:(UIImage *)searchImage{
    _searchImage=searchImage;
     [self.searchButton setBackgroundImage:searchImage forState:(UIControlStateNormal)];
}
-(void)setBackgroundImage:(UIImage *)backgroundImage{
    self.backgroundColor=[UIColor colorWithPatternImage:backgroundImage];
}
-(void)setFont:(CGFloat)font{
    _font=font;
    self.seachbarText.font=[UIFont systemFontOfSize:font];
   
}
#pragma mark handle
/**
 成为第一响应者
 */
-(void)becomeFirstResponder{
    [self.seachbarText becomeFirstResponder];
}
/**
 取消第一响应
 */
-(void)resignFirstResponder{
    [self.seachbarText resignFirstResponder];
}
#pragma mark buttonHandle
-(void)searchButtonHandle:(UIButton *)_b{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(searchButtonDidClicked:)]){
        [self.delegate searchButtonDidClicked:self];
    }
}
-(void)backButtonHandle:(UIButton *)_b{
    [self.seachbarText becomeFirstResponder];
}
#pragma mark text
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clearButtonDidClicked:)]){
        [self.delegate clearButtonDidClicked:self];
    }
    return YES;
}
-(void)textFieldDidChanged:(UITextField *)textField{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(searchBar:stringDidChanged:)]){
        [self.delegate searchBar:self stringDidChanged:textField.text];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(searchBarDidEndEdit:)]){
        [self.delegate searchBarDidEndEdit:self];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(searchBarDidBecomeEdit:)]){
        [self.delegate searchBarDidBecomeEdit:self];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(searchBarCompeleteButtonClicked:)]){
        [self.delegate searchBarCompeleteButtonClicked:self];
    }
    [self.seachbarText resignFirstResponder];
    return YES;
}
@end
