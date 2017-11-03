#import "HGBCell.h"

@interface HGBCell()
@property(weak,nonatomic)UIImageView *imgV;
@end

@implementation HGBCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:frame];
        [self.contentView addSubview:imgView];
        self.imgV=imgView;
    }
    return self;
}
-(void)layoutSubviews
{
    self.imgV.frame=self.bounds;
}
-(void)setModel:(HGBCellModel *)model
{
    _model=model;
    self.imgV.image=[UIImage imageNamed:@"cir0"];
//    NSURL *url=[NSURL URLWithString:model.img];
//    NSData *data=[[NSData alloc]initWithContentsOfURL:url];
//    self.imgV.image=[[UIImage alloc]initWithData:data];

}
@end
