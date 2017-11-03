
//
//  HGBFileImageView.m
//  测试
//
//  Created by huangguangbao on 2017/8/17.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBFileImageView.h"
@interface HGBFileImageView()
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@end
@implementation HGBFileImageView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        [self attachTapHandler];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self attachTapHandler];
}
#pragma mark action

#pragma mark 添加功能
-(void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.type==HGBFileImageViewTypeNOLimit||self.type== HGBFileImageViewTypeOnlyAction){
        //如果self.target表示的对象中, self.action表示的方法存在的话
        if([self.target respondsToSelector:self.action])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
        }
    }
}

#pragma mark handle
-(void)attachTapHandler

{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    touch.numberOfTapsRequired = 2;
    [self addGestureRecognizer:touch];


    UILongPressGestureRecognizer *touch2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    touch2.minimumPressDuration = 1;
    [self addGestureRecognizer:touch2];
}
#pragma mark action
-(void)handleTap:(UIGestureRecognizer*) recognizer

{
    [self becomeFirstResponder];

    NSString *titleString=@"复制链接";
    if(self.codeTitle){
        titleString=self.codeTitle;
    }
    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:titleString action:@selector(copyCodeString:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];

    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
}
-(BOOL)canBecomeFirstResponder

{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(self.type==HGBFileImageViewTypeNOLimit||self.type==HGBFileImageViewTypeOnlyTool){
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        if(self.image&&pboard.image&&self.codeString){
            return (action == @selector(copy:) ||action == @selector(delete:)|| action == @selector(paste:)||action == @selector(copyCodeString:));
        }else if (self.image&&pboard.image){
            return (action == @selector(copy:)||action == @selector(delete:) || action == @selector(paste:));
        }else if (pboard.image&&self.codeString){
            return (action == @selector(paste:)||action == @selector(copyCodeString:));
        }else if (self.image&&self.codeString){
            return (action == @selector(copy:) ||action == @selector(delete:)|| action == @selector(copyCodeString:));
        }else if (pboard.image){
            return  (action == @selector(paste:));
        }else if (self.image){
            return (action == @selector(copy:))||action == @selector(delete:);
        }else if (self.codeString){
            return  (action == @selector(copyCodeString:));
        }
    }else if(self.type==HGBFileImageViewTypeOnlyCopyTool){
        if (self.image&&self.codeString){
            return (action == @selector(copy:) || action == @selector(copyCodeString:));
        }else if (self.image){
            return (action == @selector(copy:));
        }else if (self.codeString){
            return  (action == @selector(copyCodeString:));
        }
    }
    return NO;

}
-(void)copy:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.image = self.image;
}
-(void)copyCodeString:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.codeString;
}
-(void)paste:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    self.image = pboard.image;
}
-(void)delete:(id)sender{
    self.image=nil;
}
@end
