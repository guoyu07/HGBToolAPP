#import "HGBCellModel.h"


@implementation HGBCellModel
- (instancetype)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.w=[dic[@"w"] intValue];
        self.h=[dic[@"h"] intValue];
        self.price=dic[@"price"];
        self.img=dic[@"img"];
        //属性的名称的必须和字典<=
        //[self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+(instancetype)cellModelWithDict:(NSDictionary *)dic
{
    return [[self alloc]initWithDict:dic];
}
@end
