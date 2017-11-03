
//
//  HGBKeybordPromptView.m
//  Keyboard
//
//  Created by huangguangbao on 16/11/3.
//  Copyright © 2016年 xuqiang. All rights reserved.
//

#import "HGBKeybordPromptView.h"
#import "HGBCustomKeyBordHeader.h"
@implementation HGBKeybordPromptView
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
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.frame];
    backImageView.image=[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/icon_keywordone"];
    [self addSubview:backImageView];
    
    self.titleLable=[[UILabel alloc]initWithFrame:CGRectMake(20*wScale, 20*hScale, self.frame.size.width-40*wScale, self.frame.size.height-40*hScale)];
   self.titleLable.textColor=[UIColor blackColor];
    self.titleLable.font=[UIFont systemFontOfSize:self.frame.size.height-40*hScale];
    self.titleLable.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.titleLable];
}
@end
