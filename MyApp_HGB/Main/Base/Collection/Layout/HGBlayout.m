#import "HGBlayout.h"
@interface HGBlayout()
@property(strong,nonatomic)NSMutableDictionary *maxYDic;
@property(assign,nonatomic)int cellWidth;//列宽
@end

@implementation HGBlayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.columns=3;
        self.columnMagrin=2;
        self.rowMagrin=3;
        }
    return self;
}
//系统在开始计算每一个cell之前调用,做一些初始化工作
-(void)prepareLayout
{
    self.maxYDic=[NSMutableDictionary dictionary];
    int collectionViewWidth=self.collectionView.bounds.size.width-(self.columns-1)*self.columnMagrin;
    self.cellWidth=collectionViewWidth/self.columns;
}
//计算所有cell的frame
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    for(int i=0;i<self.columns;i++){
        self.maxYDic[@(i)]=@(0);}
    NSMutableArray *arr=[NSMutableArray array];
    //得到cell个数
    NSInteger num=[self.collectionView numberOfItemsInSection:0];
    for(int i=0;i<num;i++){
        NSIndexPath *path=[NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr=[self layoutAttributesForItemAtIndexPath:path];
        [arr addObject:attr];
    }
    return arr;
}
//计算某一个cell的frame
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __block int minYCollumn=0;
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber * key, NSNumber * obj, BOOL *  stop) {
        float minY=[self.maxYDic[key] floatValue];
        if([self.maxYDic[@(minYCollumn)] floatValue]>minY){
            minYCollumn=key.intValue;
        }
    }];
    int cellY=[self.maxYDic[@(minYCollumn)] intValue];
    int cellX=(self.cellWidth+self.columnMagrin)*minYCollumn;
    int cellH = 0;
    if(self.delegate&&[self.delegate respondsToSelector:@selector(layout:heightWithWidth:indexPath:)]){
        [self.delegate layout:self heightWithWidth:self.cellWidth indexPath:indexPath];
    }
    self.maxYDic[@(minYCollumn)]=@(cellY+self.columnMagrin+cellH);
    UICollectionViewLayoutAttributes *attr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame=CGRectMake(cellX,cellY, self.cellWidth, cellH);
    return attr;
}
//得到所有布局好后的cell实际大小
-(CGSize)collectionViewContentSize
{
    __block int maxYCollumn=0;
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber * key, NSNumber * obj, BOOL * stop) {
        int  maxY=[self.maxYDic[key] intValue];
        if([self.maxYDic[@(maxYCollumn)] intValue]< maxY){
            maxYCollumn=key.intValue;
        }
    }];
    return CGSizeMake(self.collectionView.bounds.size.width, [self.maxYDic[@(maxYCollumn)] intValue]);
}
@end
