//
//  BasicUsage.m
//  ShangShang
//
//  Created by 史东杰 on 15/5/19.
//  Copyright (c) 2015年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface BasicUsage : XCTestCase

@end

@implementation BasicUsage

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

-(void)testNSUserDefaultsUsage{
    //this is a sample code, show how to use NSUserDefaults
    
    //output all as dictionary
    NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSLog(@"Defaults:%@", defaults);
    
    //set example
    NSString* nameKey=@"username";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:nameKey]==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"stur" forKey:nameKey];
    }
    NSLog(@"my name set:%@",[[NSUserDefaults standardUserDefaults] objectForKey:nameKey]);
    
}

@end
