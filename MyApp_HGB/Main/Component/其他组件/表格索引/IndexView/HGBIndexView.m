//
//  HGBIndexView.m
//  测试
//
//  Created by huangguangbao on 2017/6/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBIndexView.h"

@interface HGBIndexView ()

/**
 所要添加索引视图的tableView
 */
@property (nonatomic, weak) UITableView *tableView;
/**
 关联的 tableView 的数量
 */
@property (nonatomic, assign) NSInteger sectionsCount;

/**
 上一次选中的按钮
 */
@property (nonatomic, strong) UIButton *lastSelectedBtn;
/**
 button的高度
 */
@property (nonatomic, assign) CGFloat buttonH;

@end
@implementation HGBIndexView

- (instancetype)initWithFrame:(CGRect)frame indexTitles:(NSArray *)indexTitles tableView:(UITableView *)tableView tableViewSectionsCount:(NSInteger)sectionsCount{
    self = [super initWithFrame:frame];
    if (self) {
        if (indexTitles.count) {
            if (self.indexTitles.count > self.sectionsCount){
#ifdef DEBUG
                NSLog(@"Error: sectionsCount必须大于或等于indexTitles的数量");
#endif
                return nil;
            }
            self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
            self.tableView = tableView;
            self.sectionsCount = sectionsCount;
            self.indexTitles = indexTitles;
            self.btnEdgeInsets = UIEdgeInsetsZero;
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInWhichIndexButton:)];
            [self addGestureRecognizer:panGesture];
            [self creatIndexBtnsWithIndexs:self.indexTitles];
        }
    }
    return self;
}

+ (instancetype)viewWithFrame:(CGRect)frame indexTitles:(NSArray *)indexTitles tableView:(UITableView *)tableView tableViewSectionsCount:(NSInteger)sectionsCount{
    HGBIndexView *indexView = [[HGBIndexView alloc] initWithFrame:frame indexTitles:indexTitles tableView:tableView tableViewSectionsCount:sectionsCount];
    return indexView;
}

- (void)setIndexTitles:(NSArray *)indexTitles{
    if (indexTitles.count) {
        _indexTitles = indexTitles;
        [self creatIndexBtnsWithIndexs:_indexTitles];
    }
}

- (void)creatIndexBtnsWithIndexs:(NSArray *)indexTitles{
    
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
    
    CGFloat btnW = self.bounds.size.width;
    CGFloat btnH = self.bounds.size.height/indexTitles.count;
    self.buttonH = btnH;
    
    for (int i = 0 ; i < indexTitles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*btnH, btnW, btnH);
        if ([indexTitles[i] isKindOfClass:[NSString class]]) {//设置标题
            [btn setTitle:indexTitles[i] forState:UIControlStateNormal];
        }else if ([indexTitles[i] isKindOfClass:[UIImage class]]){//设置图片
            [btn setImage:indexTitles[i] forState:UIControlStateNormal];
            [btn setContentEdgeInsets:self.btnEdgeInsets];
        }
        
        [self setButtonStyleWithBtn:btn];
        [self addSubview:btn];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        
    }
    
}

- (void)buttonClick:(UIButton *)btn{
    if (self.tapIndexTitleBtn == nil) {
        if (self.indexTitles.count > self.sectionsCount) return;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:btn.tag];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:self.isHaveAnimation];
    }else{
        NSInteger section = self.tapIndexTitleBtn(btn.tag, btn.titleLabel.text);
        if (self.indexTitles.count > self.sectionsCount) return;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:self.isHaveAnimation];
        self.lastSelectedBtn = btn;
    }
}

- (void)setButtonStyleWithBtn:(UIButton *)btn{
    btn.backgroundColor = [UIColor clearColor];
    UIColor *titleColor = [UIColor colorWithRed:0 green:91/255.0 blue:255/255.0 alpha:1];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
}

- (void)panInWhichIndexButton:(UIGestureRecognizer *)gesture{
    
    CGPoint point = [gesture locationInView:self];
    CGFloat point_Y = point.y;
    int index = floorf(point_Y/self.buttonH);
    
    for (UIButton *btn in self.subviews) {
        if (btn.tag == index) {
            NSString *title = btn.titleLabel.text;
            if (![self.lastSelectedBtn.titleLabel.text isEqualToString:title]) {
                if (self.tapIndexTitleBtn == nil) {
                    if (self.indexTitles.count > self.sectionsCount) return;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:btn.tag];
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:self.isHaveAnimation];
                }else{
                    NSInteger section = self.tapIndexTitleBtn(btn.tag, title);
                    if (self.indexTitles.count > self.sectionsCount) return;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:self.isHaveAnimation];
                }
            }
            self.lastSelectedBtn = btn;
        }
    }
    
}

- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor{
    self.backgroundColor = viewBackgroundColor;
}

- (void)setTitleColor:(UIColor *)titleColor{
    if (!titleColor) return;
    _titleColor = titleColor;
    for (UIButton *btn in self.subviews) {
        [btn setTitleColor:_titleColor forState:UIControlStateNormal];
    }
}

- (void)setTitleFont:(UIFont *)titleFont{
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        btn.titleLabel.font = titleFont;
    }
}

- (void)setTitleColor:(UIColor *)titleColor titleIndex:(NSInteger)index{
    for (int i = 0; i < self.subviews.count; i++) {
        if (i == index) {
            UIButton *btn = self.subviews[index];
            if ([self.indexTitles[index] isKindOfClass:[NSString class]]){
                [btn setTitleColor:titleColor forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setTitleFont:(UIFont *)titleFont titleIndex:(NSInteger)index{
    for (int i = 0; i < self.subviews.count; i++) {
        if (i == index) {
            UIButton *btn = self.subviews[index];
            if ([self.indexTitles[index] isKindOfClass:[NSString class]]){
                btn.titleLabel.font = titleFont;
            }
        }
    }
}

- (void)setBtnContentEdgeInsets:(UIEdgeInsets)edgeInsets imageIndex:(NSInteger)index{
    for (int i = 0; i < self.subviews.count; i++) {
        if (i == index) {
            UIButton *btn = self.subviews[index];
            if (btn.imageView.image != nil){
                [btn setImageEdgeInsets:edgeInsets];
            }
        }
    }
}


@end
