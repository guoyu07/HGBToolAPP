//
//  HGBXMLModel.h
//  测试
//
//  Created by huangguangbao on 2017/9/5.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBXMLModel : NSObject
/** 节点对应的key*/
@property (nonatomic, copy  ) NSString          *key;
/** 当前节点最终的值 */
@property (nonatomic, strong) id                 value;
/** 子节点 */
@property (nonatomic, strong) NSMutableArray    *subNodes;
/** 父节点 */
@property (nonatomic, strong) HGBXMLModel  *parent;
/** 当前节点参数 */
@property (nonatomic, strong) NSDictionary      *attribute;
@end
