//
//  HGBDataBaseTool.h
//  测试
//
//  Created by huangguangbao on 2017/6/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBDataBaseTool : NSObject
#pragma mark 数据库单例
/**
 数据库封装-打开默认数据库
 
 @return 数据库类
 */
+(instancetype)shareInstance;

#pragma mark 打开数据库
/**
 打开数据库-数据库仅能打开一个,该数据打开时上一数据库关闭,上一数据库关闭失败，该数据打开失败
 
 @param dataBasePath 数据库地址
 @return 打开数据库结果
 */
+(BOOL)openDataBaseWithPath:(NSString *)dataBasePath;

#pragma mark 关闭数据库
/**
 关闭数据库
 
 @return 关闭结果
 */
+(BOOL)closeDataBase;

#pragma mark 数据库设置-加密

/**
 设置数据库加密标志-打开数据库需重新设置
 
 @param key 加密密钥
 */
+(BOOL)encryptDataBaseWithKey:(NSString *)key;

/**
 设置数据库表中数据加密标志-打开数据库需重新设置
 
 @param valueKeys  加密字段
 @param key 加密密钥
 @param tableName 表明
 
 @return 设置结果
 */
+(BOOL)encryptTableWithValueKeys:(NSArray *)valueKeys andWithEncryptSecretKey:(NSString *)key inTableName:(NSString *)tableName;

#pragma mark 创建表格
/**
 创建表格-默认text类型

 @param tableName 表名
 @param keys 字段名集合，可以包含主键名-默认为文本类型-不可为空
 @param primarykey 主键字段名
 */
+(BOOL)createTableWithTableName:(NSString *)tableName andWithKeys:(NSArray *)keys andWithPrimaryKey:(NSString *)primarykey;
#pragma mark 查询数据库表名集合
/**
 查询数据库表名集合
 
 @return 数据库表名集合
 */
+(NSArray *)queryTableNames;
/**
 表格查询字段名
 
 @param tableName 表格名称
 @return 查询结果-array[dic] key 字段名 value 字段类型
 */
+(NSArray *)queryNodeKeysWithTableName:(NSString *)tableName;
#pragma mark 删除表格
/**
 删除表格

 @param tableName 表格名称
 @return 删除结果
 */
+(BOOL)dropTableWithTableName:(NSString *)tableName;
#pragma mark 表格改名
/**
 表格改名

 @param tableName 原表名
 @param newTableName 新表名
 @return 表格改名结果
 */
+(BOOL)renameTableWithTableName:(NSString *)tableName andWithNewTableName:(NSString *)newTableName;

#pragma mark 表格增加记录
/**
 数据库表增加记录

 @param nodes 记录数据
 @param tableName 表名
 @return 增加记录结果
 */
+(BOOL)addNode:(NSDictionary *)nodes  withTableName:(NSString *)tableName;

#pragma mark 表格删除记录

/**
 数据库表删除记录
 
 @param conditionDic 记录条件-为空则删除全部记录
 @param tableName 表名
 @return 删除记录结果
 */
+(BOOL)removeNodesWithCondition:(NSDictionary *)conditionDic inTableWithTableName:(NSString *)tableName;
#pragma mark 表格修改记录
/**
 数据库表修改记录

 @param conditionDic 条件-条件为空查询所有数据
 @param changeDic   修改内容
 @param tableName 表名
 @return 修改记录结果
 */
+(BOOL)updateNodeWithCondition:(NSDictionary *)conditionDic  andWithChangeDic:(NSDictionary *)changeDic inTableWithTableName:(NSString *)tableName;


#pragma mark 表格记录查询
/**
 表格查询

 @param conditionDic 查询条件
 @param tableName 表格名称
 @return 查询结果
 */
+(NSArray *)queryNodesWithCondition:(NSDictionary *)conditionDic inTableWithTableName:(NSString *)tableName;

#pragma mark 执行sql语句
/**
 执行sql语句

 @param sqlString sql语句
 @return 执行结果
 */
+(BOOL)alterDataBySqlString:(NSString *)sqlString;

/**
 执行sql语句并返回数据结果-目前仅支持text结果

 @param sqlString sql语句
 @param tableName 表格
 @return 返回结果
 */
+(NSArray *)queryDataBySqlString:(NSString *)sqlString  andWithNodeAttributeCount:(NSString *)count andWithTableName:(NSString *)tableName;
@end
