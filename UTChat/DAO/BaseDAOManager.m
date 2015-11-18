//
//  BaseDAOManager.m
//  BESTKEEP
//
//  Created by dcj on 15/9/29.
//  Copyright © 2015年 YISHANG. All rights reserved.
//

#import "BaseDAOManager.h"
#import <objc/runtime.h>
#import "BaseDaoProperty.h"

#ifdef DEBUG
#define D_Log(...) NSLog(__VA_ARGS__)
#else
#define D_Log(...)
#endif


static NSString* const DBSQL_Attribute_NotNull     =   @"NOT NULL";
static NSString* const DBSQL_Attribute_PrimaryKey  =   @"PRIMARY KEY";
static NSString* const DBSQL_Attribute_Default     =   @"DEFAULT";
static NSString* const DBSQL_Attribute_Unique      =   @"UNIQUE";
static NSString* const DBSQL_Attribute_Check       =   @"CHECK";


static NSString *_DatabaseDirectory;

static inline NSString* DatabaseDirectory() {
    if(!_DatabaseDirectory) {
        NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _DatabaseDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"Database"] copy];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = YES;
        BOOL isExist = [fileManager fileExistsAtPath:_DatabaseDirectory isDirectory:&isDir];
        if (!isExist)
        {
            [fileManager createDirectoryAtPath:_DatabaseDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }
    return _DatabaseDirectory;
}



@interface BaseDAOManager ()

@property (nonatomic,copy) NSString * sqlitePath;
@property (nonatomic,assign) BOOL isOpen;

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;


@end

static BaseDAOManager * manager = nil;

@implementation BaseDAOManager

-(instancetype)init{
    if (self = [super init]) {
        
        self.sqlitePath = [DatabaseDirectory() stringByAppendingPathComponent:@"BestKeep.sqlite"];
        D_Log(@"SQLITE PATH\n\n%@",self.sqlitePath);
        [self openDataBase];
    }
    return self;
}


-(void)asyncTask:(void(^)(BaseDAOManager*))task{
    __weak typeof(self)wSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(self)sSelf = wSelf;
        task(sSelf);
    });
    
}

+(instancetype)cruuentManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BaseDAOManager alloc] init];
    });
    return manager;
}


-(void)insertModelWithDao:(BaseDAO *)dao andCompeletion:(CompeletionBool)compeletion{
    [self asyncTask:^(BaseDAOManager *manager) {
        BOOL sucess = [manager insertModelWithDao:dao];
        compeletion(sucess);
    }];

}

-(BOOL)insertModelWithDao:(BaseDAO *)dao{
    NSMutableArray * propertyList = [[dao class] getPropertyArray];
    NSMutableArray * values = [[NSMutableArray alloc] init];
    NSMutableArray * arguments = [[NSMutableArray alloc] init];
    NSMutableArray * column = [[NSMutableArray alloc] init];
    
    for (BaseDaoProperty * tempProperty in propertyList) {
        id value = [dao valueForProperty:tempProperty];
        if (value) {
            [column addObject:tempProperty.columnName];
            [values addObject:@"?"];
            [arguments addObject:value];
        }
    }

    NSString * columnStr = [column componentsJoinedByString:@","];
    NSString * valueStr  =[values componentsJoinedByString:@","];
    
    NSString * insertSq = [NSString stringWithFormat:@"replace into %@(%@) values(%@)",[[dao class] tableName],columnStr,valueStr];
    __block BOOL success = NO;
    __block sqlite_int64 lastInsertRowId = 0;
    [self execueSqlite:insertSq block:^(FMDatabase *db) {
        success = [db executeUpdate:insertSq withArgumentsInArray:arguments];
        lastInsertRowId = [db lastInsertRowId];
    }];
    dao.rowID = (NSInteger)lastInsertRowId;
    return success;
}

-(BOOL)updateModelWithDao:(BaseDAO *)dao{
    
    
    
    
    return NO;
}

-(void)updateModelWithDao:(BaseDAO *)dao andCompeletion:(CompeletionBool)compeletion{
    [self asyncTask:^(BaseDAOManager *manager) {
        BOOL sucess = [manager updateModelWithDao:dao];
        compeletion(sucess);
    }];

}

-(void)searchModelWithDao:(BaseDAO *)dao condition:(BaseDAOSerchCondition *)condition andCompeletion:(CompeletionId)compeletion{
    [self asyncTask:^(BaseDAOManager *manager) {
        id result = [manager searchModelWihtDao:dao condition:condition];
        compeletion(result);
    }];
    
    
}

-(id)searchModelWihtDao:(BaseDAO *)dao condition:(BaseDAOSerchCondition *)condition{
    NSMutableArray * argument = [[NSMutableArray alloc] init];
    NSString * columnStr = [condition cloumString];
    NSString * conditionStr = [condition conditionStringAddValues:argument];
    columnStr = [columnStr length]>0 ? columnStr : @"*";
    conditionStr  = [conditionStr length]>0 ? conditionStr : @"";
    NSMutableString * searchSq = [[NSMutableString alloc] initWithFormat:@"select %@, rowid from %@ %@",columnStr,[[dao class] tableName],conditionStr];
    __block NSMutableArray * results = nil;
    [self execueSqlite:searchSq block:^(FMDatabase *db) {
        FMResultSet* set = nil;
        if(![argument count])
        {
            set = [db executeQuery:searchSq];
        }
        else
        {
            set = [db executeQuery:searchSq withArgumentsInArray:argument];
        }
        
        results = [self explainSetWithSet:set baseDao:dao];
        
        [set close];
    }];
    
    return results;
}

-(void)deleteModelWithDao:(BaseDAO *)dao andCompeletion:(CompeletionBool)compeletion{
    [self asyncTask:^(BaseDAOManager *manager) {
        BOOL sucess = [manager deleteModelWithDao:dao];
        compeletion(sucess);
    }];

}

-(BOOL)deleteModelWithDao:(BaseDAO *)dao{
    
    NSMutableString * deleteSq = [NSMutableString stringWithFormat:@"DELETE FROM %@",[[dao class] tableName]];
    NSMutableArray * arguments = [[NSMutableArray alloc] init];
    NSMutableString * conditionStr = [[NSMutableString alloc] init];
    if (dao.rowID >0) {
        [conditionStr appendFormat:@"rowId=%ld",dao.rowID];
    }else{
        NSArray * propertyList = [[dao class] getPropertyArray];
        NSMutableArray * condtions = [[NSMutableArray alloc] init];

        for (BaseDaoProperty * property in propertyList) {
            
            id value = [dao valueForProperty:property];
            if (value) {
                NSString * joinStr = property.columnName;
                if ([joinStr length]) {
                    [arguments addObject:value];
                    [condtions addObject:joinStr];
                }
            }
        }
        
        [conditionStr appendString:[condtions componentsJoinedByString:@" and "]];
        
    }
    if ([conditionStr length]) {
        [conditionStr insertString:@" where " atIndex:0];
    }
    [deleteSq appendString:conditionStr];
    BOOL sucess = [self executeSQL:deleteSq withArgumentsInArray:arguments];
    if (sucess) {
        dao.rowID = 0;
    }else{
        D_Log(@"delete failed deleteSq \n\n\n%@",deleteSq);
    }
    return sucess;
}


-(BOOL)createTableWithDao:(Class)dao{
    
    NSMutableArray * propertyList = [dao getPropertyArray];
    NSMutableArray * columns = [[NSMutableArray alloc] init];
    NSMutableArray * alertColumns = [[NSMutableArray alloc] init];
    NSMutableArray * primaryKeys = [[NSMutableArray alloc] init];

    for(BaseDaoProperty* property in propertyList)
    {
        NSMutableString* tmpColumns = [[NSMutableString alloc] init];
        [tmpColumns appendFormat:@"%@ %@",property.columnName, property.columnType];
        
        
        NSString * sqToAlertTable;
        
        if (property.isIgnore) {
            
        }
        if (property.isUnique){
            [tmpColumns appendFormat:@" %@",DBSQL_Attribute_Unique];
        }
        if (property.isNotNull){
            [tmpColumns appendFormat:@" %@",DBSQL_Attribute_NotNull];
        }
        if (property.isPrimary){
            [primaryKeys addObject:property.columnName];
        }
        if (property.columnStatus == DBColumaStatuRemove) {
            sqToAlertTable = [NSString stringWithFormat:@"ALTER TABLE %@ DROP COLUMN %@",[[dao class] tableName],property.columnName];
            [alertColumns addObject:sqToAlertTable];
            continue;
        }
        if (property.columnStatus == DBColumaStatuAddition){
            sqToAlertTable = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@",[[dao class] tableName],tmpColumns];
            [alertColumns addObject:sqToAlertTable];
            continue;
            
        }else{
            
        }
        [columns addObject:tmpColumns];

        
    }
    
    NSMutableString * columnStr = [[NSMutableString alloc] initWithString:[columns componentsJoinedByString:@", "]];
    NSMutableString * primaryKeyStr = [[NSMutableString alloc] initWithString:[primaryKeys componentsJoinedByString:@", "]];
    NSString * createSq;
    if([primaryKeyStr length])
    {
        [primaryKeyStr insertString:@", primary key(" atIndex:0];
        [primaryKeyStr appendString:@")"];
    }
    
    createSq = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@%@)",[[dao class] tableName],columnStr,primaryKeyStr];

    
    BOOL execue = [self executeSQL:createSq withArgumentsInArray:nil];
    

    if (!execue) {
        
        D_Log(@"create table fail \n%@",createSq);
        return NO;
    }
    
    for (NSString * tempAlterSq in alertColumns) {
        BOOL sucess = [self executeSQL:tempAlterSq withArgumentsInArray:nil];
        if (sucess) {
            
        }else{
            D_Log(@"alter table fail \n\n\n%@",tempAlterSq);
        }
    }
    
    
    
    return YES;
}
#pragma mark -- 数据库操作
-(BOOL)executeSQL:(NSString *)sql withArgumentsInArray:(NSArray *)arguments{
    
    __block BOOL execute = NO;
    [self execueSqlite:sql block:^(FMDatabase *db) {
        if ([arguments count]>0) {
            execute = [db executeUpdate:sql withArgumentsInArray:arguments];
        }else{
            execute = [db executeUpdate:sql];
        }
    }];
    return execute;
}

#pragma mark -- 执行数据库操作时的一些设置
-(void)execueSqlite:(NSString *)execueSq block:(void(^)(FMDatabase*db))block{

    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        
#ifdef DEBUG
        db.logsErrors = YES;
#endif
        block(db);
    }];
}


#pragma 开启关闭release 数据库
-(void)openDataBase{
    
    _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:self.sqlitePath];
    if (!_databaseQueue) {
        self.isOpen = NO;
        return;
    }
    self.isOpen = YES;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        [db setShouldCacheStatements:YES];
    }];
}
-(void)closeDataBase{
    
    if (!self.isOpen) {
        return;
    }
    
    self.isOpen = NO;
    [_databaseQueue close];
    
    
}
-(void)releaseManager{
    
    if (manager) {
        manager = nil;
    }
    
}

-(NSMutableArray *)explainSetWithSet:(FMResultSet *)set baseDao:(BaseDAO *)dao{

    NSMutableArray * resultArr = [[NSMutableArray alloc] init];
    NSMutableDictionary * propertyDcit = [[dao class] getPropertyDict];
    NSInteger columnCount = [set columnCount];
    while ([set next]) {
        BaseDAO * tempDao = [[[dao class] alloc] init];
        for(int i = 0; i < columnCount; i++)
        {
            NSString* columnName = [set columnNameForIndex:i];
            BaseDaoProperty* property = [propertyDcit objectForKey:columnName];
            if(!property)
            {
                if([[columnName lowercaseString] isEqualToString:@"rowid"])
                {
                    dao.rowID = [set longForColumnIndex:i];
                }
                
                continue;
            }
            
            if([property.columnType isEqualToString:DB_Type_Blob])
            {
                [tempDao modelWithProperty:property value:[set dataForColumnIndex:i]];
            }
            else
            {
                [tempDao modelWithProperty:property value:[set stringForColumnIndex:i]];
            }
        }
        [resultArr addObject:tempDao];
    }
    
    return resultArr;
}



@end
