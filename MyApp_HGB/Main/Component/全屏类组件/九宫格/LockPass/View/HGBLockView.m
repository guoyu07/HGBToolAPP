//
//  HGBLockView.m
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/23.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBLockView.h"
#import "HGBLockButton.h"
#import "HGBLockPassHeader.h"

#define BUTTON_COUNT 9
#define BUTTON_COL_COUNT 3

@interface HGBLockView()

/** 已选择按钮数组 */
@property(nonatomic, strong) NSMutableArray *selectedButtons;

/** 触摸位置 */
@property(nonatomic, assign) CGPoint currentTouchLocation;
@property(nonatomic, assign)BOOL endFlag;
@end

@implementation HGBLockView

/** 初始化数组 */
- (NSMutableArray *)selectedButtons {
    if (nil == _selectedButtons) {
        _selectedButtons = [NSMutableArray array];
    }
    return _selectedButtons;
}

#pragma mark - 初始化方法
/** 使用文件初始化 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

/** 使用代码初始化 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

/** 初始化view内的控件(按钮) */
- (void) initView {
    // 设置透明背景
    self.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0];
    
    for (int i=0; i<BUTTON_COUNT; i++) {
        HGBLockButton *button = [HGBLockButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:self.style.buttonUnSelectImage forState:UIControlStateNormal];
        
        // 设置选中状态图片
        [button setBackgroundImage:self.style.buttonSelectImage forState:UIControlStateSelected];
        
        // 设置指标tag，用来记录轨迹
        button.tag = i;
        
        // 加入按钮到lock view
        [self addSubview:button];
    }
}

/** 设置按钮位置尺寸 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 取出所有按钮
    for (int i=0; i<self.subviews.count; i++) {
        HGBLockButton *button = self.subviews[i];
        CGFloat buttonWidth = kWidth*0.125;
        CGFloat buttonHeight = kWidth*0.125;
        
        // 此按钮所在列号
        int col = i % BUTTON_COL_COUNT;
        // 此按钮所在行号
        int row = i / BUTTON_COL_COUNT;
        // 等分水平多余空间，计算出间隙
        CGFloat marginX = (self.frame.size.width - BUTTON_COL_COUNT * buttonWidth) / (BUTTON_COL_COUNT + 1);
        CGFloat marginY = marginX;
        
        // x坐标
        CGFloat buttonX = marginX + col * (buttonWidth + marginX);
        // y坐标
        CGFloat buttonY = marginY + row * (buttonHeight + marginY);
        
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    }
}

#pragma mark - 触摸事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.endFlag=NO;
    [self.selectedButtons removeAllObjects];
    //[self touchesMoved:touches withEvent:event];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    
    // 检测哪个按钮被点中了
    for (HGBLockButton *button in self.subviews) {
        
        // 如果触碰到了此按钮
        if (CGRectContainsPoint(button.touchFrame, touchLocation)) {
            button.selected = YES;
            
            // 如果此按钮没有被触碰过才进行处理
            if (![self.selectedButtons containsObject:button]) {
                // 加入到数组
                if(self.endFlag==NO){
                    [self.selectedButtons addObject:button];
                }
                
            }
        }
        
        // 当前触摸位置
        self.currentTouchLocation = touchLocation;
    }
    
    // 重绘
    if(self.endFlag==NO){
        NSLog(@"move");
        [self setNeedsDisplay];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // 轨迹序列
    NSMutableString *passPath = [NSMutableString string];
    
    // 合成轨迹序列
    for (HGBLockButton *button in self.selectedButtons) {
        // 清除选中状态
        button.selected = NO;
        
        // 添加到轨迹序列
        [passPath appendFormat:@"%ld",(long)button.tag];
    }
    
    // 清空数组
    if(self.autoRemoveSelected){
        [self removeSelector];
    }
    // 重绘
    self.endFlag=YES;
    NSLog(@"stop");
    [self setNeedsDisplay];
    
    // 调用代理方法
    if ([self.delegate respondsToSelector:@selector(lockView:didFinishedWithPath:)]) {
        [self.delegate lockView:self didFinishedWithPath:passPath];
    }
}

-(void)removeSelector{
    [self.selectedButtons makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    [self.selectedButtons removeAllObjects];
    [self setNeedsDisplay];
}
#pragma mark - 绘图方法
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 遍历已选择按钮数组
    for (int i=0; i<self.selectedButtons.count; i++) {
        HGBLockButton *button = self.selectedButtons[i];
        
        if (0 == i) {
            [path moveToPoint:button.center];
        } else {
            [path addLineToPoint:button.center];
        }
    }
    if (self.selectedButtons.count) {
        if(self.endFlag==NO){
            [path addLineToPoint:self.currentTouchLocation];
        }
    }
    // 设置画笔
    [self.style.pathColor set];
    [path setLineWidth:10];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinBevel];
    [path stroke];
}
#pragma mark get
-(HGBLockPassStyle *)style{
    if(_style==nil){
        _style=[[HGBLockPassStyle alloc]init];
        _style.backgrondImage=[UIImage imageNamed:@"HGBLockPass.bundle/Home_refresh_bg"];
        _style.navColor=[UIColor colorWithRed:25.0/256 green:41.0/256 blue:60.0/256 alpha:1];
        _style.navTextColor=[UIColor whiteColor];
        _style.promptTextColor=[UIColor whiteColor];
        _style.buttonUnableForeColor=[UIColor colorWithRed:187.0/256 green:187.0/256 blue:191.0/256 alpha:1];
        _style.buttonUnableBackColor=[UIColor colorWithRed:230.0/256 green:230.0/256 blue:230.0/256 alpha:1];
        _style.buttonEnableBackColor=[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1];
        _style.buttonEnableForeColor=[UIColor whiteColor];
        _style.pathColor=[UIColor redColor];
        _style.buttonSelectImage=[UIImage imageNamed:@"HGBLockPass.bundle/gesture_node_highlighted"];
        _style.buttonUnSelectImage=[UIImage imageNamed:@"HGBLockPass.bundle/gesture_node_normal"];
        
    }
    return _style;
}
@end
