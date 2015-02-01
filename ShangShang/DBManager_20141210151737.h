//
//  DBManager.h
//  ShangShang
//
//  Created by 史东杰 on 14/12/10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h> 

@interface DBManager : NSObject
{
    sqlite3 *db; 
}

-(void)initManager;
-(void)createDictTable;
-(void)InsertDictData:(NSString*)key andValue:(NSString*)value;
-(void)UpdateDictData:(NSString*)key andValue:(NSString*)newValue;
-(void)DeleteDictData:(NSString*)key;
@end
