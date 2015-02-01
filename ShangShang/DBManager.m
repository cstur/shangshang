//
//  DBManager.m
//  ShangShang
//
//  Created by 史东杰 on 14/12/10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "DBManager.h"

#define DBNAME    @"ssinfo.sqlite"
#define DictTABLENAME    @"DictTable"
#define DictField_Key @"dicKey"
#define DictField_Value @"dicValue"

@implementation DBManager
@synthesize managedObjectContext;
static DBManager *instance = nil;

+(DBManager *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [DBManager new];
        }
    }
    return instance;
}

- (NSManagedObjectContext *) managedObjectContext{
    if(managedObjectContext == nil){
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] lastObject];
        NSURL *storeDatabaseURL = [url URLByAppendingPathComponent:@"Smurf.sqlite"];
        // 设置SQLite 数据库存储路径 /ShoppingCart.sqlite
        NSError *error = nil;
        
        //根据被管理对象模型创建NSPersistentStoreCoordinator 对象实例
        NSPersistentStoreCoordinator *persistentStoreCoordinator =
        [[NSPersistentStoreCoordinator alloc]
         initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
        
        //根据指定的存储类型和路径，创建一个新的持久化存储（Persistent Store）
        if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                     configuration:nil
                                                               URL:storeDatabaseURL options:nil error:&error])
        {
            NSLog(@"Error while loading persistent store ...%@", error);
        }
        
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        
        //设置当前被管理对象上下文的持久化存储协调器
        [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    
    // 返回初始化的被管理对象上下文实例
    return managedObjectContext;
}

-(NSString*)getUserName{
    return [self getDictValue:@"username"];
}

-(NSString*)getPassword{
    return [self getDictValue:@"password"];
}

-(void)initManager{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
}

-(void)execSql:(NSString *)sql
{
    [self initManager];
    NSLog(@"execute sql:%@",sql);
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!%s",err);
    }
}

-(void)createDictTable{
    //NSString *sqlDropTable = [NSString stringWithFormat:@"DROP TABLE  %@ ",DictTABLENAME];
    //[self execSql:sqlDropTable];
    NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, dicKey TEXT,  dicValue TEXT)",DictTABLENAME];
    [self execSql:sqlCreateTable];
}

-(void)InsertOrUpdateDictData:(NSString*)key andValue:(NSString*)value{
    if (![self exists:key]) {
        NSString *insertSql = [NSString stringWithFormat:
                               @"INSERT INTO %@ (%@, %@) VALUES ('%@', '%@')",
                               DictTABLENAME, DictField_Key, DictField_Value, key, value];
        
        [self execSql:insertSql];
    }else{
        [self UpdateDictData:key andValue:value];
    }
}

-(void)UpdateDictData:(NSString*)key andValue:(NSString*)newValue{
    NSString *updateSql = [NSString stringWithFormat:
                           @"UPDATE %@ set %@='%@' where %@='%@'",
                           DictTABLENAME, DictField_Value, newValue, DictField_Key, key];
    
    [self execSql:updateSql];
}

-(void)DeleteDictData:(NSString*)key{
    NSString *deleteSql = [NSString stringWithFormat:
                           @"DELETE FROM %@ where %@='%@'",
                           DictTABLENAME, DictField_Key, key];
    
    [self execSql:deleteSql];
}

-(NSString*)getDictValue:(NSString*)key{
    [self initManager];
    NSString *result=@"";
    @try {
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'", DictTABLENAME,DictField_Key,key];
        sqlite3_stmt * statement;
        
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *value = (char*)sqlite3_column_text(statement, 2);
                NSString *nsValueStr = [[NSString alloc]initWithUTF8String:value];
                
                NSLog(@"GET value:%@",nsValueStr);
                result= nsValueStr;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        sqlite3_close(db);
    }
    return result;
}

-(BOOL)exists:(NSString*)key{
    [self initManager];
    BOOL flag=FALSE;
    @try {
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'", DictTABLENAME,DictField_Key,key];
        sqlite3_stmt * statement;
        
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *value = (char*)sqlite3_column_text(statement, 2);
                NSString *nsValueStr = [[NSString alloc]initWithUTF8String:value];
                
                NSLog(@"GET value:%@",nsValueStr);
                flag=true;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        sqlite3_close(db);
    }
    return flag;
}

-(void)PrintAllDictData{
    [self initManager];
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@", DictTABLENAME];
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *key = (char*)sqlite3_column_text(statement, 1);
            NSString *nsKeyStr = [[NSString alloc]initWithUTF8String:key];
            
            char *value = (char*)sqlite3_column_text(statement, 2);
            NSString *nsValueStr = [[NSString alloc]initWithUTF8String:value];
            
            NSLog(@"key:%@ value:%@",nsKeyStr,nsValueStr);
        }
    }
    sqlite3_close(db);
}

/*
-(void)add:(id)sender
{
    Student * stu = (Student *)[NSEntityDescription insertNewObjectForEntityForName:TABLE_NAME inManagedObjectContext:[CoreDataManage GetManagedObjectContext]];
    stu.studentnumber = [NSNumber numberWithInt:[self.tf_studentnumber.text intValue]];
    stu.name = self.tf_name.text;
    stu.age = [NSNumber numberWithInt:[self.tf_age.text intValue]];
    stu.gender=[NSNumber numberWithInt:[self.tf_gender.text intValue]];
    
    NSError * error = nil;
    if ([[CoreDataManage GetManagedObjectContext] save:&error])
    {
        self.tf_studentnumber.text = @"";
        self.tf_name.text = @"";
        self.tf_age.text = @"";
        self.tf_gender.text = @"";
    }
    else
    {
        NSLog(@"add entity error = %@",error);
    }
}

-(IBAction)delete:(id)sender
{
    NSArray * arr = [self searchResult];
    __block Student * deletemp ;
    [arr enumerateObjectsUsingBlock:^(Student * obj, NSUInteger idx, BOOL *stop) {
        if ([obj.studentnumber intValue] == [self.tf_studentnumber.text intValue])
        {
            deletemp = obj;
            *stop = YES;
        }
    }];
    if (deletemp)
    {
        [[CoreDataManage GetManagedObjectContext] deleteObject:deletemp];
        NSLog(@"====ok===delete");
    }
}

-(IBAction)search:(id)sender
{
    [self searchResult];
}

-(NSArray *)searchResult
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * desption = [NSEntityDescription entityForName:TABLE_NAME inManagedObjectContext:[CoreDataManage GetManagedObjectContext]];
    [request setEntity:desption];
    
    NSError * error = nil;
    NSArray * result = [[CoreDataManage GetManagedObjectContext] executeFetchRequest:request error:&error];
    if (!error)
    {
        [result enumerateObjectsUsingBlock:^(Student * obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"--%d,%@,%@,%@,%@--/n",idx,obj.studentnumber,obj.name,obj.age,obj.gender);
        }];
        
    }
    else
    {
        NSLog(@"error seach  = %@",error);
    }
    return result;
}

-(IBAction)edit:(id)sender
{
    NSArray * arr = [self searchResult];
    [arr enumerateObjectsUsingBlock:^(Student * obj, NSUInteger idx, BOOL *stop) {
        if ([obj.studentnumber intValue] == [self.tf_studentnumber.text intValue])
        {
            obj.name = self.tf_name.text;
            obj.gender = [NSNumber numberWithInt:[self.tf_gender.text intValue]];
            obj.age = [NSNumber numberWithInt:[self.tf_age.text intValue]];
            
            NSError * error = nil;
            if ([[CoreDataManage GetManagedObjectContext] save:&error])
            {
                ;
            }
            else
            {
                NSLog(@"error=====%@",error);
            }
            *stop = YES;
        }
    }];
}
*/
@end
