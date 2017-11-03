//
//  HGBSEDataBaseTool.m
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/27.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBSEDataBaseTool.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <sqlite3.h>

@interface HGBSEDataBaseTool()
/**
 数据库
 */
@property(assign,nonatomic)sqlite3 *db;

/**
 数据库打开标志
 */
@property(assign,nonatomic)BOOL openFlag;

/**
 数据库地址
 */
@property(strong,nonatomic)NSString *dbPath;


/**
 数据库加密标志
 */
@property(assign,nonatomic)BOOL dataBaseEncrptFlag;
/**
 数据库加密密钥
 */
@property(strong,nonatomic)NSString *dataBaseEncrptKey;

/**
 数据库加密(表格-表格加密字典)key-表名 value 加密字段
 */
@property(strong,nonatomic)NSMutableDictionary *encryptDataDic;

/**
 数据库加密密钥(表格-表格加密密钥)
 */
@property(strong,nonatomic)NSMutableDictionary *encryptKeyDic;

@end
@implementation HGBSEDataBaseTool
@synthesize dbPath,db;
static HGBSEDataBaseTool *instance=nil;
#pragma mark 单例
/**
 数据库单例
 
 @return 数据库类
 */
+(instancetype)shareInstance{
    if(instance==nil){
        instance=[[[self class]alloc]init];
        
        
        NSString  *documentPath_xxx =[HGBSEDataBaseTool getDocumentFilePath];
        NSString *bundleId=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        
        NSString *dataBasePath=[documentPath_xxx stringByAppendingPathComponent:[NSString stringWithFormat:@"%@data.db",bundleId]];
        
        [instance openDataBaseWithPath:dataBasePath];
    }
    return instance;
}
#pragma mark 打开数据库
/**
 打开数据库-数据库仅能打开一个,该数据打开时上一数据库关闭,上一数据库关闭失败，该数据打开失败
 
 @param dataBasePath 数据库地址
 @return 打开数据库结果
 */
+(BOOL)openDataBaseWithPath:(NSString *)dataBasePath{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return  [instance openDataBaseWithPath:dataBasePath];
}
/**
 打开数据库-数据库仅能打开一个,该数据打开时上一数据库关闭,上一数据库关闭失败，该数据打开失败
 
 @param dataBasePath 数据库地址
 @return 打开数据库结果
 */
-(BOOL)openDataBaseWithPath:(NSString *)dataBasePath{
    
    BOOL closeFlag=YES;
    if(self.openFlag){
        closeFlag=[HGBSEDataBaseTool closeDataBase];
    }
    NSString *copyPath=[dataBasePath copy];
    if(!([copyPath containsString:[HGBSEDataBaseTool getDocumentFilePath]]||[copyPath containsString:[HGBSEDataBaseTool getHomeFilePath]]||[copyPath containsString:[HGBSEDataBaseTool getMainBundlePath]])){
        copyPath=[[HGBSEDataBaseTool getHomeFilePath] stringByAppendingPathComponent:dataBasePath];
    }
    dataBasePath=copyPath;
    if(closeFlag){
        if(sqlite3_open([dataBasePath UTF8String], &db)!=SQLITE_OK){
            NSLog(@"打开数据库失败-关闭上个数据库成功");
            self.openFlag=NO;
            return NO;
        }else{
            NSLog(@"打开数据库成功");
            instance.openFlag=YES;
            instance.dbPath=[NSString stringWithFormat:@"%@",dataBasePath];
            
            return YES;
        }
    }else{
        NSLog(@"打开数据库失败-关闭上个数据库失败");
        self.openFlag=NO;
        return NO;
    }
    
}
#pragma mark 关闭数据库
/**
 关闭数据库
 
 @return 关闭结果
 */
+(BOOL)closeDataBase{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return  [instance closeDataBase];
}

/**
 关闭数据库
 
 @return 关闭结果
 */
-(BOOL)closeDataBase{
    if(self.openFlag){
        if(sqlite3_close(db)!=SQLITE_OK){
            NSLog(@"关闭数据库失败");
            self.openFlag=YES;
            return NO;
        }else{
            
            NSLog(@"关闭数据库成功");
            self.openFlag=NO;
            instance.dataBaseEncrptFlag=NO;
            instance.encryptDataDic=[NSMutableDictionary dictionary];
            instance=nil;
            return YES;
        }
    }else{
        NSLog(@"关闭数据库成功");
        self.openFlag=NO;
        instance=nil;
        
        return YES;
    }
}
#pragma mark 数据库设置-加密
/**
 设置数据库加密标志-打开数据库需重新设置
 
 @param key 加密密钥
 */
+(BOOL)encryptDataBaseWithKey:(NSString *)key{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return [instance encryptDataBaseWithKey:key];
    
}
/**
 设置数据库加密标志-打开数据库需重新设置
 
 @param key 加密密钥
 */
-(BOOL)encryptDataBaseWithKey:(NSString *)key
{
    self.dataBaseEncrptFlag=YES;
    self.dataBaseEncrptKey=key;
//    [self Encrypt];
//    [self openDataBaseWithPath:self.dbPath];
    return YES;
}
#pragma mark  数据库加密解密
-(void)Encrypt{
        if(self.dataBaseEncrptFlag){
            NSString *flag=[HGBSEDataBaseTool getDefaultsWithKey:dbPath];
            if(!(flag&&[flag isEqualToString:@"1"])){
                [self encryptWithKey:self.dataBaseEncrptKey];
                [HGBSEDataBaseTool saveDefaultsValue:@"1" WithKey:dbPath];
            }
        }
    
}
-(void)Decrypt{
        if(self.dataBaseEncrptFlag){
            NSString *flag=[HGBSEDataBaseTool getDefaultsWithKey:self.dataBaseEncrptKey];
    
            if(flag&&[flag isEqualToString:@"1"]){
                [self decryptWithKey:[NSString stringWithFormat:@"%@",self.dataBaseEncrptKey]];
               [HGBSEDataBaseTool saveDefaultsValue:@"0" WithKey:self.dataBaseEncrptKey];
            }
        }
    
}
-(void)encryptWithKey:(NSString *)key{
    if(self.dataBaseEncrptFlag){
        NSData *fileData=[[NSData alloc]initWithContentsOfFile:self.dbPath];
        fileData=[HGBSEDataBaseTool encryptDataWithAES256:fileData andWithKey:key];
        [fileData writeToFile:self.dbPath atomically:YES];
    }
}
-(void)decryptWithKey:(NSString *)key{
    if(self.dataBaseEncrptFlag){
        NSData *fileData=[[NSData alloc]initWithContentsOfFile:self.dbPath];
        fileData=[HGBSEDataBaseTool decryptDataWithAES256:fileData andWithKey:key];
        [fileData writeToFile:self.dbPath atomically:YES];
    }
}
#pragma mark 表格字段加密
/**
 设置数据库表中数据加密标志-打开数据库需重新设置
 
 @param valueKeys  加密字段
 @param key 加密密钥
 @param tableName 表明
 
 @return 设置结果
 */
+(BOOL)encryptTableWithValueKeys:(NSArray *)valueKeys andWithEncryptSecretKey:(NSString *)key inTableName:(NSString *)tableName{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    if(tableName==nil&&tableName.length==0){
        NSLog(@"设置表格及其加密字段失败");
        return NO;
    }
    if(valueKeys==nil){
        NSLog(@"设置表格及其加密字段失败");
        return NO;
    }
    if(key==nil||key.length==0){
        NSLog(@"设置表格及其加密字段失败");
        return NO;
    }
    
    [instance.encryptDataDic setObject:valueKeys forKey:tableName];
    [instance.encryptKeyDic setObject:key forKey:tableName];
    NSLog(@"设置表格及其加密字段成功");
    return YES;
}


#pragma mark 创建表格-text
/**
 创建表格-默认text类型
 
 @param tableName 表名
 @param keys 字段名集合，可以包含主键名-默认为文本类型-不可为空
 @param primarykey 主键字段名
 */
+(BOOL)createTableWithTableName:(NSString *)tableName andWithKeys:(NSArray *)keys andWithPrimaryKey:(NSString *)primarykey{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return [instance createTableWithTableName:tableName andWithKeys:keys andWithPrimaryKey:primarykey];
}



/**
 创建表格-默认text类型
 
 @param tableName 表名
 @param keys 字段名集合，可以包含主键名-默认为文本类型-不可为空
 @param primarykey 主键字段名
 */
-(BOOL)createTableWithTableName:(NSString *)tableName andWithKeys:(NSArray *)keys andWithPrimaryKey:(NSString *)primarykey{
    if(tableName==nil&&tableName.length==0){
        NSLog(@"创建表格失败");
        return NO;
    }
    if(keys==nil){
        NSLog(@"创建表格失败");
        return NO;
    }
    if(primarykey==nil||primarykey.length==0){
        NSLog(@"创建表格失败");
        return NO;
    }
    
    //sql
    NSString *sqlStr=[NSString stringWithFormat:@"create table if not exists %@(%@ integer primary key autoincrement",tableName,primarykey];
    for(NSString *key in keys){
        if(![key isEqualToString:primarykey]){
            sqlStr=[NSString stringWithFormat:@"%@,%@ text",sqlStr,key];
        }
    }
    sqlStr=[NSString stringWithFormat:@"%@)",sqlStr];
    
    char *error;
    const char *sql=[sqlStr UTF8String];
    NSLog(@"sql:%s",sql);
    //执行
    if(sqlite3_exec(db, sql, NULL, NULL, &error)==SQLITE_OK){
        NSLog(@"创建表格成功");
        return YES;
    }else{
        NSLog(@"创建表格失败");
        NSLog(@"error:%s",error);
        return NO;
    }
}
#pragma mark 创建表格-自定类型
/**
 创建表格-字段类型自定
 
 @param tableName 表名
 @param primarykeykey 主键字段名
 @param keyDic 数据字典 name-value 字段名值-数据类型-主键名要包含在其中
 */
+(BOOL)createTableWithTableName:(NSString *)tableName andWithKeyDic:(NSDictionary *)keyDic andWithPrimarykeyKey:(NSString *)primarykeykey{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return [instance createTableWithTableName:tableName andWithKeyDic:keyDic andWithPrimarykeyKey:primarykeykey];
}
/**
 创建表格-字段类型自定
 
 @param tableName 表名
 @param primarykey 主键字段名
 @param keyDic 数据字典 name-value 字段名值-数据类型-主键名要包含在其中
 */
-(BOOL)createTableWithTableName:(NSString *)tableName andWithKeyDic:(NSDictionary *)keyDic andWithPrimarykeyKey:(NSString *)primarykey{
    if(tableName==nil&&tableName.length==0){
        NSLog(@"创建表格失败");
        return NO;
    }
    if(keyDic==nil){
        NSLog(@"创建表格失败");
        return NO;
    }
    if(primarykey==nil||primarykey.length==0){
        NSLog(@"创建表格失败");
        return NO;
    }
    
    //sql
    NSString *sqlStr;
    NSString *keyType=[keyDic objectForKey:primarykey];
    if(keyType&&keyType.length!=0){
        sqlStr=[NSString stringWithFormat:@"create table if not exists %@(%@ %@ not null primary key",tableName,primarykey,[keyDic objectForKey:primarykey]];
    }else{
        sqlStr=[NSString stringWithFormat:@"create table if not exists %@(%@ integer primary key autoincrement",tableName,primarykey];
    }
    NSArray *keys=[keyDic allKeys];
    for(NSString *key in keys){
        if(![key isEqualToString:primarykey]){
            NSString *type=[keyDic objectForKey:key];
            if(type&&type.length!=0){
                sqlStr=[NSString stringWithFormat:@"%@,%@ %@",sqlStr,key,[keyDic objectForKey:key]];
            }else{
                sqlStr=[NSString stringWithFormat:@"%@,%@ text",sqlStr,key];
            }
        }
    }
    sqlStr=[NSString stringWithFormat:@"%@)",sqlStr];
    
    char *error;
    const char *sql=[sqlStr UTF8String];
    NSLog(@"sql:%s",sql);
    //执行
    if(sqlite3_exec(db, sql, NULL, NULL, &error)==SQLITE_OK){
        NSLog(@"创建表格成功");
        return YES;
    }else{
        NSLog(@"创建表格失败");
        NSLog(@"error:%s",error);
        return NO;
    }
}
#pragma mark 查询数据库表名集合
/**
 查询数据库表名集合
 
 @return 数据库表名集合
 */
+(NSArray *)queryTableNames{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return [instance queryTableNames];
}
/**
 查询数据库表名集合
 
 @return 数据库表名集合
 */
-(NSArray *)queryTableNames{
    sqlite3_stmt *stmt;
    const char *sql = "select * from sqlite_master where type='table' order by name";
    NSMutableArray *namesArr=[NSMutableArray array];
    if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL)==SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            char *nameData = (char *)sqlite3_column_text(stmt, 1);
            NSString *tableName = [[NSString alloc] initWithUTF8String:nameData];
            [namesArr addObject:tableName];
        }
    }
    return namesArr;
}
#pragma mark 表格字段名查询

/**
 表格查询字段名
 
 @param tableName 表格名称
 @return 查询结果-array[dic] key 字段名 value 字段类型
 */
+(NSArray *)queryNodeKeysWithTableName:(NSString *)tableName{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return [instance queryNodeKeysWithTableName:tableName];
}
/**
 表格查询字段名
 
 @param tableName 表格名称
 @return 查询结果-array[dic] key 字段名 value 字段类型
 */
-(NSArray *)queryNodeKeysWithTableName:(NSString *)tableName{
    //sql
    sqlite3_stmt *stmt;
    NSString *sqlStr=[NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
    
    //执行
    const char *sql = [sqlStr UTF8String];
    NSMutableArray *names=[NSMutableArray array];
    if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL)==SQLITE_OK){
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            char *nameData = (char *)sqlite3_column_text(stmt, 1);
            int nType = sqlite3_column_type(stmt, 1);
            NSString *columnName = [[NSString alloc] initWithUTF8String:nameData];
            NSString *nameType=@"text";
            switch (nType)
            {
                case 1:
                    //SQLITE_INTEGER
                    nameType=@"integer";
                    break;
                case 2:
                    //SQLITE_FLOAT
                    nameType=@"float";
                    break;
                case 3:
                    //SQLITE_TEXT
                    nameType=@"text";
                    break;
                case 4:
                    //SQLITE_BLOB
                    nameType=@"blob";
                    break;
                case 5:
                    //SQLITE_NULL
                    nameType=@"null";
                    break;
            }
            
            [names addObject:@{columnName:nameType}];
        }
    }
    sqlite3_finalize(stmt);
    return names;
}
#pragma mark 删除表格
/**
 删除表格
 
 @param tableName 表格名称
 @return 删除结果
 */
+(BOOL)dropTableWithTableName:(NSString *)tableName{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return [instance dropTableWithTableName:tableName];
}
/**
 删除表格
 
 @param tableName 表格名称
 @return 删除结果
 */
-(BOOL)dropTableWithTableName:(NSString *)tableName{
    if(tableName==nil&&tableName.length==0){
        NSLog(@"删除表格失败");
        return NO;
    }
    char *error;
    
    //sql
    NSString *sqlStr=[NSString stringWithFormat:@"drop table if exists %@",tableName];
    
    const char *sql=[sqlStr UTF8String];
    
    NSLog(@"sql:%s",sql);
    //执行
    if(sqlite3_exec(db, sql, NULL, NULL, &error)==SQLITE_OK){
        NSLog(@"删除表格成功");
        return  YES;
    }else{
        NSLog(@"删除表格失败");
        NSLog(@"error:%s",error);
        return  NO;
    }
}
#pragma mark 表格改名
/**
 表格改名
 
 @param tableName 原表名
 @param newTableName 新表名
 @return 表格改名结果
 */
+(BOOL)renameTableWithTableName:(NSString *)tableName andWithNewTableName:(NSString *)newTableName{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return [instance renameTableWithTableName:tableName andWithNewTableName:newTableName];
}
/**
 表格改名
 
 @param tableName 原表名
 @param newTableName 新表名
 @return 表格改名结果
 */
-(BOOL)renameTableWithTableName:(NSString *)tableName andWithNewTableName:(NSString *)newTableName{
    if(tableName==nil&&tableName.length==0){
        NSLog(@"表格改名失败");
        return NO;
    }
    if(newTableName==nil&&newTableName.length==0){
        NSLog(@"表格改名失败");
        return NO;
    }
    char *error;
    //sql
    NSString *sqlStr=[NSString stringWithFormat:@"alter table %@ rename to %@",tableName,newTableName];
    const char *sql=[sqlStr UTF8String];
    NSLog(@"sql:%s",sql);
    //执行
    if(sqlite3_exec(db, sql, NULL, NULL, &error)==SQLITE_OK){
        NSLog(@"表格改名成功");
        return YES;
    }else{
        NSLog(@"表格改名失败");
        NSLog(@"error:%s",error);
        return NO;
    }
}

#pragma mark 数据库表增加记录
/**
 数据库表增加记录
 
 @param nodes 记录数据
 @param tableName 表名
 @return 增加记录结果
 */
+(BOOL)addNode:(NSDictionary *)nodes  withTableName:(NSString *)tableName{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return [instance addNode:nodes withTableName:tableName];
}
/**
 数据库表增加记录
 
 @param nodes 记录数据
 @param tableName 表名
 @return 增加记录结果
 */
-(BOOL)addNode:(NSDictionary *)nodes  withTableName:(NSString *)tableName{
    if(tableName==nil&&tableName.length==0){
        NSLog(@"表格增加记录失败");
        return NO;
    }
    if(nodes==nil||[nodes count]==0){
        NSLog(@"表格增加记录失败");
        return NO;
    }
    
    //加密数据
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:nodes];
    NSLog(@"%@",dic);
    
    NSMutableArray *encryptTableDataArr=[self.encryptDataDic objectForKey:tableName];
    NSString *key=[self.encryptKeyDic objectForKey:tableName];
    if(key&&key.length==0){
        key=tableName;
    }
    
    
    NSArray *names=[nodes allKeys];
    for(NSString *name in names){
        if([encryptTableDataArr containsObject:name]){
            id value=[nodes objectForKey:name];
            NSLog(@"%@-%@",name,value);
            if([value isKindOfClass:[NSData class]]){
                NSData *data=(NSData *)value;
                [dic setObject:[HGBSEDataBaseTool encryptDataWithAES256:data andWithKey:key] forKey:name];
                
            }else{
                NSString *string=[NSString stringWithFormat:@"%@",value];
                NSLog(@"%@-%@-%@",name,string,key);
                NSLog(@"%@",[HGBSEDataBaseTool encryptStringWithAES256:string andWithKey:key]);
                [dic setObject:[HGBSEDataBaseTool encryptStringWithAES256:string andWithKey:key] forKey:name];
            }
        }
    }
    NSLog(@"%@",dic);
    
    //sql
    NSString *sqlStrKey=[NSString stringWithFormat:@"insert into %@(",tableName];
    
    NSString *sqlStrValue=[NSString stringWithFormat:@"values("];
    int i=0;
    for(NSString *name in names){
        if(i==0){
            sqlStrKey=[NSString stringWithFormat:@"%@%@",sqlStrKey,name];
            sqlStrValue=[NSString stringWithFormat:@"%@'%@'",sqlStrValue,[dic objectForKey:name]];
            
        }else{
            sqlStrKey=[NSString stringWithFormat:@"%@,%@",sqlStrKey,name];
            sqlStrValue=[NSString stringWithFormat:@"%@,'%@'",sqlStrValue,[dic objectForKey:name]];
        }
        i++;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"%@) %@)",sqlStrKey,sqlStrValue];
    char *error;
    const char *sql=[sqlStr UTF8String];
    NSLog(@"sql:%s",sql);
    //执行
    if(sqlite3_exec(db, sql, NULL, NULL, &error)==SQLITE_OK){
        NSLog(@"表格增加记录成功");
        return YES;
    }else{
        NSLog(@"表格增加记录失败");
        NSLog(@"error:%s",error);
        
        return NO;
    }
}
#pragma mark 表格删除记录
/**
 数据库表删除记录
 
 @param conditionDic 记录条件-为空则删除全部记录
 @param tableName 表名
 @return 删除记录结果
 */
+(BOOL)removeNodesWithCondition:(NSDictionary *)conditionDic inTableWithTableName:(NSString *)tableName{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return [instance removeNodesWithCondition:conditionDic inTableWithTableName:tableName];
}
/**
 数据库表删除记录
 
 @param conditionDic 记录条件-为空则删除全部记录
 @param tableName 表名
 @return 删除记录结果
 */
-(BOOL)removeNodesWithCondition:(NSDictionary *)conditionDic inTableWithTableName:(NSString *)tableName{
    if(tableName==nil&&tableName.length==0){
        NSLog(@"表格删除记录失败");
        return NO;
    }
    
    //加密
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:conditionDic];
    
    NSMutableArray *encryptTableDataArr=[self.encryptDataDic objectForKey:tableName];
    NSString *key=[self.encryptKeyDic objectForKey:tableName];
    if(key&&key.length==0){
        key=tableName;
    }
    
    NSArray *names=[conditionDic allKeys];
    for(NSString *name in names){
        
        if([encryptTableDataArr containsObject:name]){
            id value=[conditionDic objectForKey:name];
            if([value isKindOfClass:[NSData class]]){
                NSData *data=(NSData *)value;
                [dic setObject:[HGBSEDataBaseTool encryptDataWithAES256:data andWithKey:key] forKey:name];
                
            }else{
                NSString *string=[NSString stringWithFormat:@"%@",value];
                [dic setObject:[HGBSEDataBaseTool encryptStringWithAES256:string andWithKey:key] forKey:name];
            }
        }
    }
    
    //sql
    NSString *sqlStr=[NSString stringWithFormat:@"delete from %@ where",tableName];
    
    if(dic==nil||[dic count]==0){
        sqlStr=[NSString stringWithFormat:@"delete from %@",tableName];
    }
    int i=0;
    for(NSString *name in names){
        if(i==0){
            sqlStr=[NSString stringWithFormat:@"%@ %@='%@'",sqlStr,name,[dic objectForKey:name]];
        }else{
            sqlStr=[NSString stringWithFormat:@"%@ and %@='%@'",sqlStr,name,[dic objectForKey:name]];
        }
        i++;
    }
    char *error;
    
    const char *sql=[sqlStr UTF8String];
    NSLog(@"sql:%s",sql);
    //执行
    if(sqlite3_exec(db, sql, NULL, NULL, &error)==SQLITE_OK){
        NSLog(@"表格删除记录成功");
        return YES;
    }else{
        NSLog(@"表格删除记录失败");
        NSLog(@"error:%s",error);
        return NO;
    }
}
#pragma mark 表格修改记录
/**
 数据库表修改记录
 
 @param conditionDic 条件-条件为空查询所有数据
 @param changeDic   修改内容
 @param tableName 表名
 @return 修改记录结果
 */
+(BOOL)updateNodeWithCondition:(NSDictionary *)conditionDic  andWithChangeDic:(NSDictionary *)changeDic inTableWithTableName:(NSString *)tableName{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return [instance updateNodeWithCondition:conditionDic  andWithChangeDic:changeDic inTableWithTableName:tableName];
}
/**
 数据库表修改记录
 
 @param conditionDic 条件-条件为空查询所有数据
 @param changeDic   修改内容
 @param tableName 表名
 @return 修改记录结果
 */
-(BOOL)updateNodeWithCondition:(NSDictionary *)conditionDic  andWithChangeDic:(NSDictionary *)changeDic inTableWithTableName:(NSString *)tableName{
    if(tableName==nil&&tableName.length==0){
        NSLog(@"表格修改记录失败");
        return NO;
    }
    //加密
    NSMutableDictionary *dic_condition=[NSMutableDictionary dictionaryWithDictionary:conditionDic];
    
    
    NSMutableArray *encryptTableDataArr=[self.encryptDataDic objectForKey:tableName];
    NSString *key=[self.encryptKeyDic objectForKey:tableName];
    if(key&&key.length==0){
        key=tableName;
    }
    
    //加密条件
    NSArray *names_condition=[conditionDic allKeys];
    for(NSString *name in names_condition){
        
        if([encryptTableDataArr containsObject:name]){
            id value=[conditionDic objectForKey:name];
            if([value isKindOfClass:[NSData class]]){
                NSData *data=(NSData *)value;
                [dic_condition setObject:[HGBSEDataBaseTool encryptDataWithAES256:data andWithKey:key] forKey:name];
                
            }else{
                NSString *string=[NSString stringWithFormat:@"%@",value];
                [dic_condition setObject:[HGBSEDataBaseTool encryptStringWithAES256:string andWithKey:key] forKey:name];
            }
        }
    }
    //加密修改内容
    NSMutableDictionary *dic_change=[NSMutableDictionary dictionaryWithDictionary:changeDic];
    
    NSArray *names_change=[changeDic allKeys];
    for(NSString *name in names_change){
        
        if([encryptTableDataArr containsObject:name]){
            id value=[changeDic objectForKey:name];
            if([value isKindOfClass:[NSData class]]){
                NSData *data=(NSData *)value;
                [dic_change setObject:[HGBSEDataBaseTool encryptDataWithAES256:data andWithKey:key] forKey:name];
                
            }else{
                NSString *string=[NSString stringWithFormat:@"%@",value];
                [dic_change setObject:[HGBSEDataBaseTool encryptStringWithAES256:string andWithKey:key] forKey:name];
            }
        }
    }
    //sql
    NSString *sqlChange=[NSString stringWithFormat:@"update %@ set",tableName];
    NSString *sqlCondition=@"";
    if(sqlCondition&&names_condition.count!=0){
        sqlCondition=[NSString stringWithFormat:@"where"];
    }
    
    int i=0;
    for(NSString *name in names_change){
        if(i==0){
            sqlChange=[NSString stringWithFormat:@"%@ %@='%@'",sqlChange,name,[dic_change objectForKey:name]];
        }else{
            sqlChange=[NSString stringWithFormat:@"%@,%@='%@'",sqlChange,name,[dic_change objectForKey:name]];
        }
        i++;
    }
    
    i=0;
    for(NSString *name in names_condition){
        if(i==0){
            sqlCondition=[NSString stringWithFormat:@"%@ %@='%@'",sqlCondition,name,[dic_condition objectForKey:name]];
        }else{
            sqlCondition=[NSString stringWithFormat:@"%@ and %@='%@'",sqlCondition,name,[dic_condition objectForKey:name]];
        }
        i++;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"%@ %@",sqlChange,sqlCondition];
    char *error;
    const char *sql=[sqlStr UTF8String];
    
    NSLog(@"sql:%s",sql);
    
    //执行
    if(sqlite3_exec(db, sql, NULL, NULL, &error)==SQLITE_OK){
        NSLog(@"表格修改记录成功");
        ;
        return YES;
    }else{
        NSLog(@"表格修改记录失败");
        NSLog(@"error:%s",error);
        return NO;
    }
}

#pragma mark 表格记录查询
/**
 表格查询
 
 @param conditionDic 查询条件
 @param tableName 表格名称
 @return 查询结果
 */
+(NSArray *)queryNodesWithCondition:(NSDictionary *)conditionDic inTableWithTableName:(NSString *)tableName{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return [instance queryNodesWithCondition:conditionDic inTableWithTableName:tableName];
}
/**
 表格查询
 
 @param conditionDic 查询条件
 @param tableName 表格名称
 @return 查询结果
 */
-(NSArray *)queryNodesWithCondition:(NSDictionary *)conditionDic inTableWithTableName:(NSString *)tableName{
    if(tableName==nil&&tableName.length==0){
        NSLog(@"查询表格记录失败");
        return @[];
    }
    
    
    //加密
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:conditionDic];
    
    NSMutableArray *encryptTableDataArr=[self.encryptDataDic objectForKey:tableName];
    NSString *key=[self.encryptKeyDic objectForKey:tableName];
    if(key&&key.length==0){
        key=tableName;
    }
    
    NSArray *names=[conditionDic allKeys];
    for(NSString *name in names){
        
        if([encryptTableDataArr containsObject:name]){
            id value=[conditionDic objectForKey:name];
            if([value isKindOfClass:[NSData class]]){
                NSData *data=(NSData *)value;
                [dic setObject:[HGBSEDataBaseTool encryptDataWithAES256:data andWithKey:key] forKey:name];
                
            }else{
                NSString *string=[NSString stringWithFormat:@"%@",value];
                [dic setObject:[HGBSEDataBaseTool encryptStringWithAES256:string andWithKey:key] forKey:name];
            }
        }
    }
    
    //sql
    NSString *sqlStr=[NSString stringWithFormat:@"select * from %@ where",tableName];
    if(dic==nil||[dic count]==0){
        sqlStr=[NSString stringWithFormat:@"select * from %@",tableName];
    }
    
    int i=0;
    for(NSString *name in names){
        if(i==0){
            sqlStr=[NSString stringWithFormat:@"%@ %@='%@'",sqlStr,name,[dic objectForKey:name]];
        }else{
            sqlStr=[NSString stringWithFormat:@"%@ and %@='%@'",sqlStr,name,[dic objectForKey:name]];
        }
        i++;
    }
    
    const char *sql=[sqlStr UTF8String];
    sqlite3_stmt *stmt;
    NSMutableArray *searchArr=[NSMutableArray array];
    if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL)==SQLITE_OK){
        NSArray *searchNames=[HGBSEDataBaseTool queryNodeKeysWithTableName:tableName];
        //遍历
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            for(int i=0;i<searchNames.count;i++){
                NSDictionary *nameDic=[searchNames objectAtIndex:i];
                NSArray *subnames=[nameDic allKeys];
                if(subnames.count!=0){
                    NSString *subname=subnames[0];
                    NSString *type=[nameDic objectForKey:subname];
                    if([type isEqualToString:@"text"]){
                        
                        
                        
                    }else{
                        
                    }
                    const unsigned char *value=sqlite3_column_text(stmt, i);
                    NSString *valueStr=[NSString stringWithFormat:@"%s",value];
                    if([encryptTableDataArr containsObject:subname]){
                        [dic setObject:[HGBSEDataBaseTool decryptStringWithAES256:valueStr andWithKey:key] forKey:subname];
                    }else{
                        [dic setObject:valueStr forKey:subname];
                    }
                    
                }
                
            }
            [searchArr addObject:dic];
            
        }
        
    }
    sqlite3_finalize(stmt);
    return searchArr;
}
#pragma mark 执行sql语句-返回执行状态
/**
 执行sql语句
 
 @param sqlString sql语句
 @return 执行结果
 */
+(BOOL)alterDataBySqlString:(NSString *)sqlString{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return [instance alterDataBySqlString:sqlString];
}
/**
 执行sql语句
 
 @param sqlString sql语句
 @return 执行结果
 */
-(BOOL)alterDataBySqlString:(NSString *)sqlString{
    char *error;
    
    if(sqlString&&sqlString.length==0){
        NSLog(@"执行失败");
        return NO;
    }
    const char *sql=[sqlString UTF8String];
    
    NSLog(@"sql:%s",sql);
    //执行
    if(sqlite3_exec(db, sql, NULL, NULL, &error)==SQLITE_OK){
        NSLog(@"执行成功");
        return  YES;
    }else{
        NSLog(@"执行失败");
        NSLog(@"error:%s",error);
        return  NO;
    }
}
#pragma mark 执行sql语句-返回数据结果
/**
 执行sql语句并返回数据结果-目前仅支持text结果
 
 @param sqlString sql语句
 @param tableName 表格
 @return 返回结果
 */
+(NSArray *)queryDataBySqlString:(NSString *)sqlString  andWithNodeAttributeCount:(NSString *)count andWithTableName:(NSString *)tableName
{
    if(!instance){
        [HGBSEDataBaseTool shareInstance];
    }
    return [instance queryDataBySqlString:sqlString andWithNodeAttributeCount:count andWithTableName:tableName];
}
/**
 执行sql语句并返回数据结果-目前仅支持text结果
 
 @param sqlString sql语句
 @param tableName 表格
 @return 返回结果
 */
-(NSArray *)queryDataBySqlString:(NSString *)sqlString  andWithNodeAttributeCount:(NSString *)count andWithTableName:(NSString *)tableName
{
    if(sqlString&&sqlString.length==0){
        NSLog(@"执行失败");
        return @[];
    }
    
    NSMutableArray *encryptTableDataArr=[self.encryptDataDic objectForKey:tableName];
    NSString *key=[self.encryptKeyDic objectForKey:tableName];
    if(key&&key.length==0){
        key=tableName;
    }
    const char *sql=[sqlString UTF8String];
    sqlite3_stmt *stmt;
    NSMutableArray *searchArr=[NSMutableArray array];
    if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL)==SQLITE_OK){
        //遍历
        NSArray *searchNames=[HGBSEDataBaseTool queryNodeKeysWithTableName:tableName];
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            for(int i=0;i<searchNames.count;i++){
                NSDictionary *nameDic=[searchNames objectAtIndex:i];
                NSArray *subnames=[nameDic allKeys];
                if(subnames.count!=0){
                    NSString *subname=subnames[0];
                    NSString *type=[nameDic objectForKey:subname];
                    if([type isEqualToString:@"text"]){
                        
                        
                        
                    }else{
                        
                    }
                    const unsigned char *value=sqlite3_column_text(stmt, i);
                    NSString *valueStr=[NSString stringWithFormat:@"%s",value];
                    if([encryptTableDataArr containsObject:subname]){
                        [dic setObject:[HGBSEDataBaseTool decryptStringWithAES256:valueStr andWithKey:key] forKey:subname];
                    }else{
                        [dic setObject:valueStr forKey:subname];
                    }
                    
                }
                
            }
            [searchArr addObject:dic];
        }
    }
    sqlite3_finalize(stmt);
    return searchArr;
}
#pragma mark get
-(NSMutableDictionary *)encryptDataDic{
    if(_encryptDataDic==nil){
        _encryptDataDic=[NSMutableDictionary dictionary];
    }
    return _encryptDataDic;
}
-(NSMutableDictionary *)encryptKeyDic{
    if(_encryptKeyDic==nil){
        _encryptKeyDic=[NSMutableDictionary dictionary];
    }
    return _encryptKeyDic;
}
#pragma mark AES256-string
/**
 AES256加密
 
 @param string 字符串
 @param key  加密密钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithAES256:(NSString *)string andWithKey:(NSString *)key{
    if(key==nil||key.length==0){
        return nil;
    }
    if(string==nil){
        return nil;
    }
    NSString *encryptString= [HGBSEDataBaseTool AES256StringEncrypt:string WithKey:key];
    return encryptString;
}
/**
 AES256解密
 
 @param string 字符串
 @param key  解密密钥
 @return 解密后字符串
 */
+(NSString *)decryptStringWithAES256:(NSString *)string
                          andWithKey:(NSString *)key{
    if(key==nil||key.length==0){
        return nil;
    }
    if(string==nil){
        return nil;
    }
    NSString *decryptString= [HGBSEDataBaseTool AES256StringDecrypt:string WithKey:key];
    return decryptString;
}
#pragma mark AES256-data
/**
 AES256加密
 
 @param data 数据
 @param key  加密密钥
 @return 加密后数据
 */
+(NSData *)encryptDataWithAES256:(NSData *)data andWithKey:(NSString *)key{
    if(key==nil||key.length==0){
        return nil;
    }
    NSData *encryptData= [HGBSEDataBaseTool AES256DataEncrypt:data WithKey:key];
    return encryptData;
}
/**
 AES256解密
 
 @param data 数据
 @param key  解密密钥
 @return 解密后数据
 */
+(NSData *)decryptDataWithAES256:(NSData *)data andWithKey:(NSString *)key{
    if(key==nil||key.length==0){
        return nil;
    }
    NSData *decryptData= [HGBSEDataBaseTool AES256DataEncrypt:data WithKey:key];
    return decryptData;
}
#pragma mark AES256-data
+ (NSData *)AES256DataEncrypt:(NSData *)data WithKey:(NSString *)key   //加密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)AES256DataDecrypt:(NSData *)data WithKey:(NSString *)key   //解密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}
#pragma mark AES256-string
+ (NSString *)AES256StringEncrypt:(NSString *)string  WithKey:(NSString *)keyString
{
    
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [keyString getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *sourceData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [sourceData length];
    size_t buffersize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(buffersize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCBlockSizeAES128, NULL, [sourceData bytes], dataLength, buffer, buffersize, &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *encryptData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        //对加密后的二进制数据进行base64转码
        return [encryptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    else
    {
        free(buffer);
        return nil;
    }
    
}

+ (NSString *)AES256StringDecrypt:(NSString *)string WithKey:(NSString *)keyString
{
    //先对加密的字符串进行base64解码
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [keyString getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [decodeData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCBlockSizeAES128, NULL, [decodeData bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return result;
    }
    else
    {
        free(buffer);
        return nil;
    }
    
}
#pragma mark 首选项
/**
 *  Defaults保存
 *
 *  @param value   要保存的数据
 *  @param key   关键字
 *  @return 保存结果
 */
+(BOOL)saveDefaultsValue:(id)value WithKey:(NSString *)key{
    if((!value)||(!key)||key.length==0){
        return NO;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
    return YES;
}
/**
 *  Defaults取出
 *
 *  @param key     关键字
 *  return  返回已保存的数据
 */
+(id)getDefaultsWithKey:(NSString *)key{
    if(key==nil||key.length==0){
        return nil;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id  value=[defaults objectForKey:key];
    [defaults synchronize];
    return value;
}
#pragma mark bundleid
/**
 获取BundleID
 
 @return BundleID
 */
+(NSString*) getBundleID

{
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    
}
#pragma mark 获取沙盒文件路径
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
/**
 获取主资源文件路径

 @return 主资源文件路径
 */
+(NSString *)getMainBundlePath{
    return [[NSBundle mainBundle]resourcePath];
}

@end
