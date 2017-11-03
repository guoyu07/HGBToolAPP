//
//  HGBXMLWriter.m
//  测试
//
//  Created by huangguangbao on 2017/9/5.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBXMLWriter.h"

#define PREFIX_STRING_FOR_ELEMENT @"@"

@interface HGBXMLWriter(){
@private
    NSMutableArray* nodes;
    NSString* xml;
    NSMutableArray* treeNodes;
    BOOL isRoot;
    NSString* passDict;
    BOOL withHeader;
}

@end
@implementation HGBXMLWriter

-(void)serialize:(id)root
{
    if([root isKindOfClass:[NSArray class]])
    {
        int mula = (int)[root count];
        mula--;
        [nodes addObject:[NSString stringWithFormat:@"%i",(int)mula]];

        for(id objects in root)
        {
            if ([[nodes lastObject] isEqualToString:@"0"] || [nodes lastObject] == NULL || ![nodes count])
            {
                [nodes removeLastObject];
                [self serialize:objects];
            }
            else
            {
                [self serialize:objects];
                if(!isRoot)
                xml = [xml stringByAppendingFormat:@"</%@><%@>",[treeNodes lastObject],[treeNodes lastObject]];
                else
                isRoot = FALSE;
                int value = [[nodes lastObject] intValue];
                [nodes removeLastObject];
                value--;
                [nodes addObject:[NSString stringWithFormat:@"%i",(int)value]];
            }
        }
    }
    else if ([root isKindOfClass:[NSDictionary class]])
    {
        for (NSString* key in root)
        {
            if(!isRoot)
            {
                //                    NSLog(@"We came in");
                [treeNodes addObject:key];
                xml = [xml stringByAppendingFormat:@"<%@>",key];
                [self serialize:[root objectForKey:key]];
                xml =[xml stringByAppendingFormat:@"</%@>",key];
                [treeNodes removeLastObject];
            } else {
                isRoot = FALSE;
                [self serialize:[root objectForKey:key]];
            }
        }
    }
    else if ([root isKindOfClass:[NSString class]] || [root isKindOfClass:[NSNumber class]] || [root isKindOfClass:[NSURL class]])
    {
        //            if ([root hasPrefix:"PREFIX_STRING_FOR_ELEMENT"])
        //            is element
        //            else
        xml = [xml stringByAppendingFormat:@"%@",root];
    }
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        // Initialization code here.
        xml = @"";
        if (withHeader)
        xml = @"<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
        nodes = [[NSMutableArray alloc] init];
        treeNodes = [[NSMutableArray alloc] init];
        isRoot = YES;
        passDict = [[dictionary allKeys] lastObject];
        xml = [xml stringByAppendingFormat:@"<%@>\n",passDict];
        [self serialize:dictionary];
    }

    return self;
}
- (id)initWithDictionary:(NSDictionary *)dictionary withHeader:(BOOL)header {
    withHeader = header;
    self = [self initWithDictionary:dictionary];
    return self;
}

-(void)dealloc
{
    //    [xml release],nodes =nil;
     nodes = nil ;
    treeNodes = nil;
}

-(NSString *)getXML
{
    xml = [xml stringByReplacingOccurrencesOfString:@"</(null)><(null)>" withString:@"\n"];
    xml = [xml stringByAppendingFormat:@"\n</%@>",passDict];
    xml=[@"<?xml version='1.0' encoding='utf-8'?>\n" stringByAppendingFormat:@"%@", xml];
    return xml;
}
#pragma mark 字典数据源
+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary
{
    if (dictionary==nil||[[dictionary allKeys] count]==0){
        return nil;
    }
    HGBXMLWriter* fromDictionary = [[HGBXMLWriter alloc]initWithDictionary:dictionary];
    return [fromDictionary getXML];
}

+ (NSString *) XMLStringFromDictionary:(NSDictionary *)dictionary withHeader:(BOOL)header {
    if (dictionary==nil||[[dictionary allKeys] count]==0){
        return nil;
    }
    HGBXMLWriter* fromDictionary = [[HGBXMLWriter alloc]initWithDictionary:dictionary withHeader:header];
    return [fromDictionary getXML];
}

+(BOOL)XMLDataFromDictionary:(NSDictionary *)dictionary toPath:(NSString *)path  Error:(NSError **)error
{

    if (dictionary==nil||[[dictionary allKeys] count]==0){
        return NO;
    }
    if(path==nil||path.length==0){
        path=[[HGBXMLWriter getDocumentFilePath]stringByAppendingPathComponent:@"test.xml"];
    }
    path=[HGBXMLWriter getDestinationCompletePathFromSimplifyFilePath:path];
    HGBXMLWriter* fromDictionary = [[HGBXMLWriter alloc]initWithDictionary:dictionary];
    [[fromDictionary getXML] writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:error];
    if (error)
    return FALSE;
    else
    return TRUE;

}
#pragma mark 数组数据源
/**
 *  XML生成
 *
 *  @param array 数据源
 *
 *  @return xml结果
 */
+(NSString *)XMLStringFromArray:(NSArray *)array{
    if (array==nil||[array count]==0){
        return nil;
    }
    return [HGBXMLWriter XMLStringFromDictionary:@{@"items":array}];
}
/**
 *  XML生成
 *
 *  @param array 数据源
 *  @param header 是否是属性
 *
 *  @return xml结果
 */
+(NSString *)XMLStringFromArray:(NSArray *)array withHeader:(BOOL)header{
    if (array==nil||[array count]==0){
        return nil;
    }
    return [HGBXMLWriter XMLStringFromDictionary:@{@"items":array} withHeader:header];
}
/**
 *  XML生成
 *
 *  @param array 数据源
 *  @param path xml文件地址
 *  @param error 错误
 *
 *  @return xml结果
 */
+(BOOL)XMLDataFromArray:(NSArray *)array toPath:(NSString *) path  Error:(NSError **)error{
    if (array==nil||[array count]==0){
        return NO;
    }
    if(path==nil||path.length==0){
        path=[[HGBXMLWriter getDocumentFilePath]stringByAppendingPathComponent:@"test.xml"];
    }
    path=[HGBXMLWriter getDestinationCompletePathFromSimplifyFilePath:path];
    return [HGBXMLWriter XMLDataFromDictionary:@{@"items":array} toPath:path Error:error];
}
#pragma mark JSON字符串
/**
 *  XML生成
 *
 *  @param jsonString 数据源
 *
 *  @return xml结果
 */
+(NSString *)XMLStringFromJSONString:(NSString *)jsonString{
    id xmlObject=[HGBXMLWriter JSONStringToObject:jsonString];
    if([xmlObject isKindOfClass:[NSArray class]]){
        return [HGBXMLWriter XMLStringFromArray:xmlObject];
    }else if ([xmlObject isKindOfClass:[NSDictionary class]]){
        return [HGBXMLWriter XMLStringFromDictionary:xmlObject];
    }else{
        return nil;
    }
}
/**
 *  XML生成
 *
 *  @param  jsonString 数据源
 *  @param header 是否是属性
 *
 *  @return xml结果
 */
+(NSString *)XMLStringFromJSONString:(NSString *)jsonString withHeader:(BOOL)header{
    id xmlObject=[HGBXMLWriter JSONStringToObject:jsonString];
    if([xmlObject isKindOfClass:[NSArray class]]){
        return [HGBXMLWriter XMLStringFromArray:xmlObject withHeader:header];
    }else if ([xmlObject isKindOfClass:[NSDictionary class]]){
        return [HGBXMLWriter XMLStringFromDictionary:xmlObject withHeader:header];
    }else{
        return nil;
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
    if(![HGBXMLWriter isExitAtFilePath:path]){
        path=[[HGBXMLWriter getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
        if(![HGBXMLWriter isExitAtFilePath:path]){
            path=[[HGBXMLWriter getDocumentFilePath] stringByAppendingPathComponent:simplifyFilePath];
            if(![HGBXMLWriter isExitAtFilePath:path]){
                path=[[HGBXMLWriter getMainBundlePath] stringByAppendingPathComponent:simplifyFilePath];
                if(![HGBXMLWriter isExitAtFilePath:path]){
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
    if(!([simplifyFilePath containsString:[HGBXMLWriter getHomeFilePath]]||[simplifyFilePath containsString:[HGBXMLWriter getMainBundlePath]])){
        simplifyFilePath=[[HGBXMLWriter getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
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
/**
 把Json对象转化成json字符串

 @param object json对象
 @return json字符串
 */
+ (NSString *)ObjectToJSONString:(id)object
{
    if(!([object isKindOfClass:[NSDictionary class]]||[object isKindOfClass:[NSArray class]]||[object isKindOfClass:[NSString class]])){
        return nil;
    }
    if([object isKindOfClass:[NSString class]]){
        return object;
    }
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return myString;
}
/**
 把Json字符串转化成json对象

 @param jsonString json字符串
 @return json字符串
 */
+ (id)JSONStringToObject:(NSString *)jsonString{
    if(![jsonString isKindOfClass:[NSString class]]){
        return nil;
    }
    jsonString=[HGBXMLWriter jsonStringHandle:jsonString];
    //    NSLog(@"%@",jsonString);
    NSError *error = nil;
    NSData  *data=[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if(jsonString.length>0&&[[jsonString substringToIndex:1] isEqualToString:@"{"]){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(error){
            NSLog(@"%@",error);
            return jsonString;
        }else{
            return dic;
        }
    }else if(jsonString.length>0&&[[jsonString substringToIndex:1] isEqualToString:@"["]){
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(error){
            NSLog(@"%@",error);
            return jsonString;
        }else{
            return array;
        }
    }else{
        return jsonString;
    }


}
/**
 json字符串处理

 @param jsonString 字符串处理
 @return 处理后字符串
 */
+(NSString *)jsonStringHandle:(NSString *)jsonString{
    NSString *string=jsonString;
    //大括号

    //中括号
    while ([string containsString:@"【"]) {
        string=[string stringByReplacingOccurrencesOfString:@"【" withString:@"]"];
    }
    while ([string containsString:@"】"]) {
        string=[string stringByReplacingOccurrencesOfString:@"】" withString:@"]"];
    }

    //小括弧
    while ([string containsString:@"（"]) {
        string=[string stringByReplacingOccurrencesOfString:@"（" withString:@"("];
    }

    while ([string containsString:@"）"]) {
        string=[string stringByReplacingOccurrencesOfString:@"）" withString:@")"];
    }


    while ([string containsString:@"("]) {
        string=[string stringByReplacingOccurrencesOfString:@"(" withString:@"["];
    }

    while ([string containsString:@")"]) {
        string=[string stringByReplacingOccurrencesOfString:@")" withString:@"]"];
    }


    //逗号
    while ([string containsString:@"，"]) {
        string=[string stringByReplacingOccurrencesOfString:@"，" withString:@","];
    }
    while ([string containsString:@";"]) {
        string=[string stringByReplacingOccurrencesOfString:@";" withString:@","];
    }
    while ([string containsString:@"；"]) {
        string=[string stringByReplacingOccurrencesOfString:@"；" withString:@","];
    }
    //引号
    while ([string containsString:@"“"]) {
        string=[string stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    }
    while ([string containsString:@"”"]) {
        string=[string stringByReplacingOccurrencesOfString:@"”" withString:@"\""];
    }
    while ([string containsString:@"‘"]) {
        string=[string stringByReplacingOccurrencesOfString:@"‘" withString:@"\""];
    }
    while ([string containsString:@"'"]) {
        string=[string stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    }
    //冒号
    while ([string containsString:@"："]) {
        string=[string stringByReplacingOccurrencesOfString:@"：" withString:@":"];
    }
    //等号
    while ([string containsString:@"="]) {
        string=[string stringByReplacingOccurrencesOfString:@"=" withString:@":"];
    }
    while ([string containsString:@"="]) {
        string=[string stringByReplacingOccurrencesOfString:@"=" withString:@":"];
    }
    return string;
    
}
@end
