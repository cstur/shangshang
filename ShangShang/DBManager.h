//
//  DBManager.h
//  ShangShang
//
//  Created by 史东杰 on 14/12/10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h> 
#import <CoreData/CoreData.h>

@interface DBManager : NSObject
{
    sqlite3 *db; 
}
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

+(DBManager*)getInstance;
-(void)initManager;
-(void)createDictTable;
-(void)InsertOrUpdateDictData:(NSString*)key andValue:(NSString*)value;
-(void)UpdateDictData:(NSString*)key andValue:(NSString*)newValue;
-(void)PrintAllDictData;
-(void)DeleteDictData:(NSString*)key;
-(NSString*)getDictValue:(NSString*)key;

-(NSString*)getUserName;
-(NSString*)getPassword;
@end
