//
//  HGBXMLReader.m
//  测试
//
//  Created by huangguangbao on 2017/9/5.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBXMLReader.h"
#import "HGBXMLModel.h"
#import <UIKit/UIKit.h>

@interface HGBXMLReader () <NSXMLParserDelegate>

/** 解析结束标志 */
@property (nonatomic, assign) BOOL  parserEnd;

/** 解析结果 */
@property (nonatomic, strong) id                 parserResult;

/** 当前解析到的节点 */
@property (nonatomic, strong) HGBXMLModel  *currNode;

/** 当前节点字符串内容 */
@property (nonatomic, copy  ) NSMutableString   *nodeString;
/** 解析超时定时器 */
@property (nonatomic, strong) NSTimer           *timer;
/** 是否读取底层 */

@end
@implementation HGBXMLReader
static BOOL    _isReadBaseItem=NO;
static NSString  *baseItem=@"";
/**
 *  是否读取最外层Item
 *
 *  @param isReadBaseItem 读取
 *
 */
+(void)isReadBaseItem:(BOOL)isReadBaseItem{
    _isReadBaseItem=isReadBaseItem;

}
#pragma mark 工具方法
/**
 *  XML解析
 *
 *  @param path 待解析的xml路径
 *
 *  @return 解析结果
 */
+ (id)XMLObjectWithXmlPath:(NSString *)path{
    if(path==nil||path.length==0){
        return nil;
    }
    return  [HGBXMLReader XMLObjectWithXmlUrl:[[NSURL fileURLWithPath:path] absoluteString]];
}
/**
 *  XML解析
 *
 *  @param url 待解析的xml URL
 *
 *  @return 解析结果
 */
+ (id)XMLObjectWithXmlUrl:(NSString *)url{
    if(url==nil||url.length==0){
        return nil;
    }
    if(![url containsString:@"http"]){
        NSString *path=[[NSURL URLWithString:url]path];
        path=[HGBXMLReader getCompletePathFromSimplifyFilePath:path];
        if(![HGBXMLReader isExitAtFilePath:path]){
            return nil;
        }
        url=[[NSURL fileURLWithPath:path]absoluteString];
    }else{
        if(![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:url]]){
            return nil;
        }
    }
    NSURL *xmlFileURL = [NSURL URLWithString:url];
    NSData *xmlData = [NSData dataWithContentsOfURL:xmlFileURL options:NSDataReadingUncached error:NULL];
    return [HGBXMLReader XMLObjectWithData:xmlData];
}
/**
 *  XML解析
 *
 *  @param xmlString 待解析的xml字符串
 *
 *  @return 解析结果
 */
+ (id)XMLObjectWithXMLString:(NSString *)xmlString{
    if(xmlString==nil||xmlString.length==0){
        return nil;
    }
    return [HGBXMLReader XMLObjectWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
}
/**
 *  XML解析
 *
 *  @param data 待解析的二进制数据
 *
 *  @return 解析结果
 */
+ (id)XMLObjectWithData:(NSData *)data {
    if(data==nil){
        return nil;
    }
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    return [self XMLObjectWithParser:parser];
}

/**
 *  XML解析
 *
 *  @param parser 带解析的parser
 *
 *  @return 解析结果
 */
+ (id)XMLObjectWithParser:(NSXMLParser *)parser {
    HGBXMLReader *xmlParser = [[self alloc] init];
    baseItem=@"";
    /** 配置解析代理 */
    parser.delegate = xmlParser;
    /** 开始解析 */
    [parser parse];

    /** 创建定时器，用于判断解析超时 */
    xmlParser.timer = [NSTimer scheduledTimerWithTimeInterval:PARSER_TIMEOUT target:xmlParser selector:@selector(timeOut) userInfo:nil repeats:NO];
    [xmlParser.timer fire];

    // 等待解析结束
    while (!xmlParser.parserEnd);
    if(!_isReadBaseItem){
        return xmlParser.parserResult;
    }else{
        // 返回解析结果
        return @{baseItem:xmlParser.parserResult};
    }

}
#pragma mark 解析
/**
 *  解析超时回调，可能是由于XML文件格式错误，导致SAX解析无法结束！
 */
- (void)timeOut {
    if(!self.parserEnd) {
        NSLog(@"解析超时：可能是由于XML文件格式错误！");
        self.parserEnd = TRUE;
    }
}
/********************************************************************
 *
 *                             解析过程
 *
 *******************************************************************/
/**
 *  打开文档
 */
- (void)parserDidStartDocument:(NSXMLParser *)parser {
        NSLog(@"打开文档%@", parser);
}
/**
 *  关闭文件
 *
 *  @note 设置结束标志位，设置解析结果
 */
-(void)parserDidEndDocument:(NSXMLParser *)parser {
    self.parserResult = _currNode.value;
    self.parserEnd    = TRUE;
    /** 停止定时器 */
    [_timer invalidate];
}

/**
 *  开始节点
 *
 *  @param elementName   节点名称
 *  @param attributeDict 节点参数
 *  @note  生成新的节点对象，记录父子关系
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    /** 创建新的节点 */
    HGBXMLModel *newNode = [[HGBXMLModel alloc] init];

    newNode.attribute = attributeDict.copy;
    if(baseItem==nil||baseItem.length==0){
        baseItem=elementName;
    }
    if(_currNode) {
        /** 存储当前节点到父节点 */
        NSDictionary *dict = @{@"key":elementName, @"value":newNode};
        [_currNode.subNodes addObject:dict];
        if(!_currNode.key) {
            _currNode.key = elementName;
        }
        if((_currNode.key != elementName) && ![_currNode.key isEqualToString:@"-1"]) {
            _currNode.key = @"-1";
        }
        newNode.parent = _currNode;
    }
    /** 记录新的节点为当前节点 */
    _currNode = newNode;

    /** 初始化拼接字符串 */
    _nodeString = [NSMutableString string];
}

/**
 *  遍历节点内容
 *
 *  @param string 节点内容
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    // 拼接节点内容
    [_nodeString appendString:string];
}

/**
 *  结束节点
 *
 *  @param elementName  结束节点名称
 *  @note  根据节点内容，判断当前节点类型：
 1.没有参数，且没有子节点           ---- NSString （例：<test>abc</test>）
 2.含有子节点，且子节点key值不同     ---- NSArray (例：<test>  <sub1>abc</sub1>  <sub2>cde</sub2>  </test>)
 3.含有参数或者子节点key值唯一       ---- NSDictionary (例：<test> <sub1>abc</sub1> <sub1>abc</sub1> </test>或<test para="p" />)
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if(_currNode.subNodes.count == 0 && _currNode.attribute.allKeys.count == 0) {

        /** 没有参数，且没有子节点 */
        _currNode.value = (NSString *)_nodeString.copy;
    }else if((_currNode.key != nil) && ![_currNode.key isEqualToString:@"-1"]) {

        /** 含有参数或者子节点key值唯一 */
        NSMutableArray *subNods = [NSMutableArray array];
        [_currNode.subNodes enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            HGBXMLModel *subNode = dict[@"value"];
            [subNods addObject:subNode.value];
        }];
        _currNode.value = subNods.copy;
    }else {

        /** 含有子节点，且子节点key值不同 */
        NSMutableDictionary *subNodes = [NSMutableDictionary dictionaryWithDictionary:_currNode.attribute];
        [_currNode.subNodes enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            HGBXMLModel *subNode = dict[@"value"];
            [subNodes setValue:subNode.value forKey:dict[@"key"]];
        }];
        _currNode.value = subNodes.copy;
    }
    if(_currNode.parent) {
        _currNode = _currNode.parent;
    }
}

#pragma mark 获取文件完整路径

/**
 将简化路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
+(NSString *)getCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    NSString *path=[simplifyFilePath copy];
    if(![HGBXMLReader isExitAtFilePath:path]){
        path=[[HGBXMLReader getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
        if(![HGBXMLReader isExitAtFilePath:path]){
            path=[[HGBXMLReader getDocumentFilePath] stringByAppendingPathComponent:simplifyFilePath];
            if(![HGBXMLReader isExitAtFilePath:path]){
                path=[[HGBXMLReader getMainBundlePath] stringByAppendingPathComponent:simplifyFilePath];
                if(![HGBXMLReader isExitAtFilePath:path]){
                    path=simplifyFilePath;
                }

            }

        }

    }
    return path;
}
/**
 将简化目标路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
+(NSString *)getDestinationCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    if(!([simplifyFilePath containsString:[HGBXMLReader getHomeFilePath]]||[simplifyFilePath containsString:[HGBXMLReader getMainBundlePath]])){
        simplifyFilePath=[[HGBXMLReader getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
    }
    return simplifyFilePath;
}
#pragma mark bundle
/**
 获取主资源文件路径

 @return 主资源文件路径
 */
+(NSString *)getMainBundlePath{
    return [[NSBundle mainBundle]resourcePath];
}
#pragma mark 沙盒
/**
 获取沙盒根路径

 @return 根路径
 */
+(NSString *)getHomeFilePath{
    NSString *path_huang=NSHomeDirectory();
    return path_huang;
}
/**
 获取沙盒Document路径

 @return Document路径
 */
+(NSString *)getDocumentFilePath{
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    return path_huang;
}
#pragma mark 文件
/**
 文档是否存在

 @param filePath 归档的路径
 @return 结果
 */
+(BOOL)isExitAtFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:filePath];
    return isExit;
}
/**
 删除文档

 @param filePath 归档的路径
 @return 结果
 */
+ (BOOL)removeFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return YES;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:filePath];
    BOOL deleteFlag=NO;
    if(isExit){
        deleteFlag=[filemanage removeItemAtPath:filePath error:nil];
    }else{
        deleteFlag=NO;
    }
    return deleteFlag;
}
@end
