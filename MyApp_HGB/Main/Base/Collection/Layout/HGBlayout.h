#import <UIKit/UIKit.h>

@class HGBlayout;
@class NSIndexPath;

@protocol HGBlayoutDelegate<NSObject>
-(CGFloat)layout:(HGBlayout *) layout heightWithWidth:(int)height indexPath:(NSIndexPath *)indexPath;
@end

@interface HGBlayout : UICollectionViewLayout
@property(weak,nonatomic)id<HGBlayoutDelegate>delegate;
@property(assign,nonatomic) int columns;//列数
@property(assign,nonatomic) int columnMagrin;//列距离
@property(assign,nonatomic) int rowMagrin;//行距离


@end
