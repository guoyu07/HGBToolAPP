//
//  HGBInstructionView.m
//  CTTX
//
//  Created by huangguangbao on 2017/3/3.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBInstructionView.h"
#import "HGBInstructionHeader.h"
@interface HGBInstructionView()
/**
 滑动背景
 */
@property(strong,nonatomic)UIScrollView *scrollView;
/**
 详情
 */
@property(nonatomic,strong)UITextView *aboutTextView;
/**
 标题
 */
@property(nonatomic,strong)UILabel *nameLab;
@end
@implementation HGBInstructionView
#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame andWithTitle:(NSString *)title andWithSubTitles:(NSArray *)subTitles andWithPrompt:(NSString *)prompt
{
    self = [super initWithFrame:frame];
    if (self) {
        self.subTitles=subTitles;
        self.promptStr=prompt;
        self.name=title;
        [self p_setupViewWithFrame:frame];
        
    }
    return self;
}
#pragma mark view
- (void)p_setupViewWithFrame:(CGRect)frame
{
    
    self.backgroundColor=[UIColor colorWithRed:255.0/256 green:245.0/256 blue:242.0/256 alpha:1];
    
    //滑动
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [self addSubview:self.scrollView];
    
    //标题
    CGFloat height=[self heightForString:self.name fontSize:36*hScale andWidth:kWidth-60*wScale]*1.3+60*hScale;
    self.nameLab=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale,30*hScale,kWidth-60*wScale, height)];
    self.nameLab.font=[UIFont boldSystemFontOfSize:36*hScale];
    self.nameLab.numberOfLines=0;
    self.nameLab.textAlignment=NSTextAlignmentCenter;
    self.nameLab.textColor=[UIColor blackColor];
    
    self.nameLab.text=self.name;
    [self.scrollView addSubview:self.nameLab];
    
    //详情
    self.aboutTextView=[[UITextView alloc]initWithFrame:CGRectMake(30*wScale,height+60*hScale,kWidth-2*30*wScale, kHeight-height-80*hScale)];
    self.aboutTextView.editable=NO;
    self.aboutTextView.backgroundColor=[UIColor colorWithRed:255.0/256 green:245.0/256 blue:242.0/256 alpha:1];
    self.aboutTextView.font=[UIFont systemFontOfSize:32*hScale];
    self.aboutTextView.textColor=[UIColor colorWithRed:166.0/256 green:166.0/256 blue:166.0/256 alpha:1];
    self.aboutTextView.scrollEnabled=NO;
    self.aboutTextView.text=self.promptStr;
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 20*hScale;// 字体的行间距
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:32*hScale],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor colorWithRed:166.0/256 green:166.0/256 blue:166.0/256 alpha:1]};
    
    self.aboutTextView.attributedText = [[NSAttributedString alloc] initWithString:self.aboutTextView.text attributes:attributes];
    
    NSMutableAttributedString *noteStr= [[NSMutableAttributedString alloc] initWithString:self.aboutTextView.text];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:32*hScale] range:NSMakeRange(0, self.aboutTextView.text.length)];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:76.0/256 green:76.0/256 blue:76.0/256 alpha:1] range:NSMakeRange(0, self.aboutTextView.text.length)];
    for(NSString *str in self.subTitles){
        NSRange range=[self.aboutTextView.text rangeOfString:str];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:32*hScale] range:range];
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:76.0/256 green:76.0/256 blue:76.0/256 alpha:1] range:range];
        
    }
    [self.aboutTextView setAttributedText:noteStr];
    
    [self.aboutTextView setSelectable:NO];
    self.aboutTextView.frame=CGRectMake(30*wScale,height+60*hScale,kWidth-2*30*wScale,[self.aboutTextView sizeThatFits:CGSizeMake(CGRectGetWidth(self.aboutTextView.frame), FLT_MAX)].height);
    [self.scrollView addSubview:self.aboutTextView];
    //滑动
    CGFloat max_height=kHeight-64;
    if(CGRectGetMaxY(self.aboutTextView.frame)>=max_height){
        max_height=CGRectGetMaxY(self.aboutTextView.frame)+50*hScale;
    }
    self.scrollView.contentSize=CGSizeMake(kWidth, max_height);
    
}
#pragma mark 获取字符串宽高
/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (CGFloat)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGRect r = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil];
    return r.size.height;
}
/**
 @method 获取指定高度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param height 限制字符串显示区域的高度
 @result float 返回的宽度
 */
- (CGFloat)widthForString:(NSString *)value fontSize:(float)fontSize andheight:(float)height{
    CGRect r = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil];
    return r.size.width;
}
@end
