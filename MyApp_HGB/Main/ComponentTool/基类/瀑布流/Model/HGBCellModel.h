#import <Foundation/Foundation.h>

@interface HGBCellModel : NSObject
@property(assign,nonatomic)int h;
@property(assign,nonatomic)int w;
@property(copy,nonatomic)NSString *price;
@property(copy,nonatomic)NSString *img;

+(instancetype)cellModelWithDict:(NSDictionary *)dic;
- (instancetype)initWithDict:(NSDictionary *)dic;
@end
