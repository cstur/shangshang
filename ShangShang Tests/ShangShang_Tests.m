//
//  ShangShang_Tests.m
//  ShangShang Tests
//
//  Created by 史东杰 on 14-8-9.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HttpUtil.h"
#import "SmurfFramework.h"
#import "DBManager.h"
#import "CommonUtil.h"
#import "NSManagedObject.h"

@interface ShangShang_Tests : XCTestCase

@end

@implementation ShangShang_Tests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testPost
{
    [[HttpUtil getInstance] post:@"http://115.28.155.74:8080/SmurfWeb/rest/ios/userinfo?username=Admin&password=@Admin" withCompletionBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary *obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        XCTAssertEqual(@"0", [obj objectForKey:@"role"],"user should be admin");
    }];
}

-(void) testGetNoneExistObject{
    NSManagedObjectContext* managedObjectContext=[[DBManager getInstance] managedObjectContext];
    NSError * error = nil;
    
    ConfigData *user = (ConfigData *)[NSEntityDescription insertNewObjectForEntityForName:@"ConfigData"
                                                                 inManagedObjectContext:managedObjectContext];

    
    if (![managedObjectContext save:&error])
    {
        NSLog(@"add entity error = %@",error);
    }
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * configObj = [NSEntityDescription entityForName:@"ConfigData" inManagedObjectContext:managedObjectContext];
    [request setEntity:configObj];
    
    NSArray * result = [managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"%d",result.count);
    if (!error)
    {
        [result enumerateObjectsUsingBlock:^(ConfigData * obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"DICT:%@",[obj getDictionary]);
        }];
    }
    else
    {
        NSLog(@"error seach  = %@",error);
    }
}

- (void) testSmurfDB{
    
    NSManagedObjectContext* managedObjectContext=[[DBManager getInstance] managedObjectContext];
    NSError * error = nil;
    

    SmurfUser *user = (SmurfUser *)[NSEntityDescription insertNewObjectForEntityForName:@"SmurfUser"
                                                                 inManagedObjectContext:managedObjectContext];
    user.username=@"CCC1";
    user.password=@"DDD";
    user.age=[NSNumber numberWithInt:1];
    
    
    if (![managedObjectContext save:&error])
    {
        NSLog(@"add entity error = %@",error);
    }
     /*
    NSDictionary *user=[CommonUtil iosapi_userinfo:@"t" Password:@"t"];
    SmurfUser *userModel = (SmurfUser *)[NSEntityDescription insertNewObjectForEntityForName:@"SmurfUser"
                                                                 inManagedObjectContext:managedObjectContext];
    [userModel safeSetValuesForKeysWithDictionary:user dateFormatter:nil];
    NSLog(@"%@",userModel.username);  */
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * desption = [NSEntityDescription entityForName:@"SmurfUser" inManagedObjectContext:managedObjectContext];
    [request setEntity:desption];

    NSArray * result = [managedObjectContext executeFetchRequest:request error:&error];
    if (!error)
    {
        [result enumerateObjectsUsingBlock:^(SmurfUser * obj, NSUInteger idx, BOOL *stop) {
            //NSLog(@"--%d,%@,%@,%@--/n",idx,obj.username,obj.password,obj.age);
            NSLog(@"DI0CT:%@",[obj getDictionary]);
        }];
    }
    else
    {
        NSLog(@"error seach  = %@",error);
    }

    if (result && [result count])
    {
        for (NSManagedObject *obj in result)
        {
            [managedObjectContext deleteObject:obj];
        }
        if (![managedObjectContext save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
  
}
@end
