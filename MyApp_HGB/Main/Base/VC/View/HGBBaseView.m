//
//  HGBBaseView.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/25.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBaseView.h"

@implementation HGBBaseView
#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frameRect=frame;
        [self viewSetUp];
    }
    return self;
}
#pragma mark view
-(void)viewSetUp{

}
@end
