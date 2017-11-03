//
//  HGBCenterPopCell.m
//  CTTX
//
//  Created by huangguangbao on 16/12/28.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import "HGBCenterPopCell.h"

#pragma mark 颜色
/**
 颜色

 @param r 红色
 @param g 绿色
 @param b 蓝色
 @param a 透明度
 @return 颜色
 */
#define HGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/**
 颜色-不透明

 @param r 红色
 @param g 绿色
 @param b 蓝色
 @return 颜色
 */
#define HGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号

//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0

@implementation HGBCenterPopCell
#pragma mark - Init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self viewSetUp];
    }
    return self;
}

#pragma mark - View

-(void)viewSetUp{
    self.contentView.backgroundColor=[UIColor whiteColor];
    self.promptImgV=[[UIImageView alloc]initWithFrame:CGRectMake(15,12.5,20,20)];
    [self.contentView addSubview:self.promptImgV];
    
    CGFloat w=[self widthForString:@"使用工行其他卡支付" fontSize:17 andheight:17.7];
    
    self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(15 + self.promptImgV.frame.size.width, 0,w, self.frame.size.height)];
    self.titleLab.text=@"title";
    
    self.titleLab.font=[UIFont  systemFontOfSize:17];
    self.titleLab.textColor=HGBColor(110, 110, 100);
    
    self.titleLab.textAlignment=NSTextAlignmentLeft;
    self.titleLab.text=@"畅通卡支付";
    [self.contentView addSubview:self.titleLab];
    
    
    self.indicatorImgV=[[UIImageView alloc]initWithFrame:CGRectMake(75*wScale+25+w,16,30,18)];
    [self.contentView addSubview:self.indicatorImgV];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = [self widthForString:self.titleLab.text fontSize:17 andheight:17.7];
    self.titleLab.frame=CGRectMake(15 + 25, 0, w, self.frame.size.height);
    self.indicatorImgV.frame=CGRectMake(15 + self.promptImgV.frame.size.width + 5 + w + 5,(self.frame.size.height - 18)/2,30,18);
}
/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (CGFloat)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
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
