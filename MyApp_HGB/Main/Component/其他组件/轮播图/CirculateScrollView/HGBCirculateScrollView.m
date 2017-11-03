//
//  HGBCirculateScrollView.m
//  CTTX
//
//  Created by huangguangbao on 16/9/20.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import "HGBCirculateScrollView.h"
#import "HGBCirculateScrollPageIControl.h"
@interface HGBCirculateScrollView()
@property(nonatomic,assign) NSInteger tempPage;

/**
 页码控制器
 */
@property (nonatomic, strong) HGBCirculateScrollPageIControl *pageControl;
/**
 view数组
 */
@property (nonatomic, strong) NSMutableArray *viewArr;
/**
 定时器
 */
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation HGBCirculateScrollView

#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.frame=frame;
        [self initScrollView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame andWithStyle:(NSInteger)style
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.frame=frame;
        self.pageControlStyle=1;
        [self initScrollView];
    }
    return self;
}
- (void)initScrollView
{
    //滑动视图设置
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
//    if(self.slideImagesArray.count < 2){
//        self.scrollView.scrollEnabled = NO;
//    }
    self.scrollView.backgroundColor=[UIColor clearColor];
    [self addSubview:self.scrollView];
    
    //页
    self.pageControl = [[HGBCirculateScrollPageIControl alloc] initWithFrame:CGRectMake((self.scrollView.frame.size.width-100)/2,self.scrollView.frame.size.height-18 , 100, 15)];
    if(self.pageControlStyle==1){
        self.pageControl.pageIndicatorImage = [UIImage imageNamed:@"page_normal"];
        self.pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"page_select"];
    }else{
        [self.pageControl setCurrentPageIndicatorTintColor:self.pageControlCurrentPageIndicatorTintColor ? self.pageControlCurrentPageIndicatorTintColor : [UIColor redColor]];
        [self.pageControl setPageIndicatorTintColor:self.PageControlPageIndicatorTintColor ? self.PageControlPageIndicatorTintColor : [UIColor whiteColor]];
    }
   
    if(self.pageSize.width!=0&&self.pageSize.height!=0){
        self.pageControl.frame=CGRectMake((self.scrollView.frame.size.width-self.pageSize.width)/2,self.scrollView.frame.size.height-18 , self.pageSize.width, 15);
    }
    self.pageControl.numberOfPages = self.slideViewsArray.count;
    self.pageControl.currentPage = 0;
    if(self.slideViewsArray.count < 2){
        self.pageControl.hidden = YES;
    }
    
}
#pragma mark run
- (void)startLoading
{
    NSLog(@"%@",self.slideViewsArray);
    for(UIView *v in self.viewArr){
        [v removeFromSuperview];
    }
    [self.timer invalidate];
    if(self.pageSize.width!=0&&self.pageSize.height!=0){
        self.pageControl.frame=CGRectMake((self.scrollView.frame.size.width-self.pageSize.width)/2,self.scrollView.frame.size.height-18 , self.pageSize.width, 15);
        if(self.pageControlStyle==1){
            self.pageControl.pageIndicatorImage = [UIImage imageNamed:@"page_normal"];
            self.pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"page_select"];
        }else{
            [self.pageControl setCurrentPageIndicatorTintColor:self.pageControlCurrentPageIndicatorTintColor ? self.pageControlCurrentPageIndicatorTintColor : [UIColor redColor]];
            [self.pageControl setPageIndicatorTintColor:self.PageControlPageIndicatorTintColor ? self.PageControlPageIndicatorTintColor : [UIColor whiteColor]];
        }
    }
//    if(self.slideImagesArray.count>1){
//        self.scrollView.scrollEnabled=YES;
//    }
    if(self.withoutManualScroll){
        for(UIGestureRecognizer *g in self.scrollView.gestureRecognizers){
            [self.scrollView removeGestureRecognizer:g];
        }
    }
    
    NSLog(@"%@",NSStringFromCGRect(self.frame));
    if(!self.isVerticalScroll){
        for (NSInteger i = 0; i < self.slideViewsArray.count; i++) {
            UIView *view=self.slideViewsArray[i];
            view.frame=CGRectMake(self.scrollView.frame.size.width * (i +1) , 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            if(self.slideViewsArray.count==1){
                view.frame=CGRectMake(0 ,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            }
            [self.viewArr addObject:view];
            [self.scrollView addSubview:view];
        }
        
        if(self.slideViewsArray.count>1){
            UIView *firstView =[self duplicate:self.slideViewsArray[self.slideViewsArray.count-1]];
            [self.viewArr addObject:firstView];
            
            firstView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            [self.scrollView addSubview:firstView];
            
            UIView *endView =[self duplicate:self.slideViewsArray[0]];
            [self.viewArr addObject:endView];
            endView.frame = CGRectMake((self.slideViewsArray.count + 1) * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            [self.scrollView addSubview:endView];
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * (self.slideViewsArray.count + 2), self.scrollView.frame.size.height)];
            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];

            if (!self.withoutAutoScroll) {
                if (!self.autoTime) {
                    self.autoTime = [NSNumber numberWithFloat:2.0f];
                }
                self.timer = [NSTimer timerWithTimeInterval:[self.autoTime floatValue] target:self selector:@selector(runTimePage)userInfo:nil repeats:YES];
                
                [[NSRunLoop  currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            }
            
        }else{
             [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width , self.scrollView.frame.size.height)];
             [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
        }
    }else{
        for (NSInteger i = 0; i < self.slideViewsArray.count; i++) {
            UIView *view=self.slideViewsArray[i];
           view.frame=CGRectMake(0, self.scrollView.frame.size.height * (i +1) , self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            NSLog(@"%@",NSStringFromCGRect(view.frame));
            if(self.slideViewsArray.count==1){
                view.frame=CGRectMake(0 ,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            }
            [self.viewArr addObject:view];
            [self.scrollView addSubview:view];
        }
        
        if(self.slideViewsArray.count>1){
            UIView *firstView =[self duplicate:self.slideViewsArray[self.slideViewsArray.count-1]];
            [self.viewArr addObject:firstView];
            
            firstView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            [self.scrollView addSubview:firstView];
            
            UIView *endView =[self duplicate:self.slideViewsArray[0]];
            [self.viewArr addObject:endView];
            endView.frame = CGRectMake(0, (self.slideViewsArray.count + 1) * self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            [self.scrollView addSubview:endView];
            
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height * (self.slideViewsArray.count + 2))];
             [self.scrollView scrollRectToVisible:CGRectMake(0, self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
            if (!self.withoutAutoScroll) {
                if (!self.autoTime) {
                    self.autoTime = [NSNumber numberWithFloat:2.0f];
                }
                self.timer = [NSTimer timerWithTimeInterval:[self.autoTime floatValue] target:self selector:@selector(runTimePage)userInfo:nil repeats:YES];
                
                [[NSRunLoop  currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            }
            
        }else{
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height)];
            [self.scrollView scrollRectToVisible:CGRectMake(0,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
        }
        
    }
    
    
    
    
    if (!self.withoutPageControl) {
        if(![self.pageControl superview]){
            [self addSubview:self.pageControl];
        }
    }
    self.pageControl.numberOfPages = self.slideViewsArray.count;
    self.pageControl.currentPage = 0;
    if(self.slideViewsArray.count >=2){
        self.pageControl.hidden = NO;
    }else{
        self.pageControl.hidden = YES;
    }
}

- (void)startLoadingByIndex:(NSInteger)index
{
    [self startLoading];
    self.tempPage = index;
    if(!self.isVerticalScroll){
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * (index + 1), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    }else{
        [self.scrollView scrollRectToVisible:CGRectMake(0,self.scrollView.frame.size.width * (index + 1), self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    }
}

#pragma mark -scrollView Delegate-
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.timer invalidate];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWith = self.scrollView.frame.size.width;
    CGFloat pageHigh = self.scrollView.frame.size.height;
    
    NSInteger page;
    if(!self.isVerticalScroll){
        page= floor((self.scrollView.contentOffset.x - pageWith/(self.slideViewsArray.count+2))/pageWith) + 1;
    }else{
        page= floor((self.scrollView.contentOffset.y - pageHigh/(self.slideViewsArray.count+2))/pageHigh) + 1;
    }
    page --;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWith = self.scrollView.frame.size.width;
    CGFloat pageHigh = self.scrollView.frame.size.height;
    NSInteger currentPage;
    if(!self.isVerticalScroll){
       currentPage= floor((self.scrollView.contentOffset.x - pageWith/ (self.slideViewsArray.count+2)) / pageWith) + 1;
        if (currentPage == 0) {
            if (self.iCurrentIndex) {
                self.iCurrentIndex(self.slideViewsArray.count-1);
            }
            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * self.slideViewsArray.count, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
        }else if(currentPage == self.slideViewsArray.count + 1){
            if (self.iCurrentIndex){
                self.iCurrentIndex(0);
            }
            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO
             ];
        }else{
            if (self.iCurrentIndex){
                self.iCurrentIndex(currentPage-1);
            }
        }
    }else{
        currentPage= floor((self.scrollView.contentOffset.y - pageHigh/ (self.slideViewsArray.count+2)) / pageHigh) + 1;
        if (currentPage == 0) {
            if (self.iCurrentIndex) {
                self.iCurrentIndex(self.slideViewsArray.count-1);
            }
            [self.scrollView scrollRectToVisible:CGRectMake(0, self.scrollView.frame.size.height * self.slideViewsArray.count, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
        }else if(currentPage == self.slideViewsArray.count + 1){
            if (self.iCurrentIndex){
                self.iCurrentIndex(0);
            }
            [self.scrollView scrollRectToVisible:CGRectMake(0, self.scrollView.frame.size.height, self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO
             ];
        }else{
            if (self.iCurrentIndex){
                self.iCurrentIndex(currentPage-1);
            }
        }
    }
    
    if (!self.withoutAutoScroll) {
        if (!self.autoTime) {
            self.autoTime = [NSNumber numberWithFloat:2.0f];
        }
        self.timer = [NSTimer timerWithTimeInterval:[self.autoTime floatValue] target:self selector:@selector(runTimePage)userInfo:nil repeats:YES];
        
        [[NSRunLoop  currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(!self.isVerticalScroll){
        if (!self.withoutAutoScroll){
            if (self.tempPage == 0) {
                [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * self.slideViewsArray.count, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
            }else if(self.tempPage == self.slideViewsArray.count){
                [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO
                 ];
            }
        }
    }else{
        if (!self.withoutAutoScroll){
            if (self.tempPage == 0) {
                [self.scrollView scrollRectToVisible:CGRectMake(0,self.scrollView.frame.size.height * self.slideViewsArray.count, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
            }else if(self.tempPage == self.slideViewsArray.count){
                [self.scrollView scrollRectToVisible:CGRectMake(0, self.scrollView.frame.size.height, self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:NO
                 ];
            }
        }
    }
    
}

#pragma mark -PageControl Method-
- (void)turnPage:(NSInteger)page
{
    self.tempPage = page;
    if(!self.isVerticalScroll){
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * (page + 1), 0, self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:YES];
    }else{
        [self.scrollView scrollRectToVisible:CGRectMake(0,self.scrollView.frame.size.height * (page + 1), self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:YES];
    }
}

#pragma mark -定时器 Method-
- (void)runTimePage
{
    NSInteger page = self.pageControl.currentPage;
    page ++;
    [self turnPage:page];
}



#pragma mark 复制view
- (UIView*)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}
#pragma mark get
-(NSMutableArray *)viewArr{
    if(_viewArr==nil){
        _viewArr=[NSMutableArray array];
    }
    return _viewArr;
}
@end
