//
//  ShangShang_Tests.m
//  ShangShang Tests
//
//  Created by 史东杰 on 14-8-9.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SSUser.h"
#import "CommonUtil.h"

@interface ShangShang_Tests : XCTestCase

@end

@implementation ShangShang_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    [SSUser initWith:@"1" andPassword:@"1"];
    SSUser *user=[SSUser getInstance];
    NSLog(@"%@",user.nickName);
}

-(void)testJsonArray{
    SSVote *vote=[SSVote alloc];
    vote.title=@"test1";
    vote.attachids=@"197";
    vote.classid=@"100034";
    
    
    //NSMutableArray *arr=[[NSMutableArray alloc] init];
    SSVoteOption *op=[SSVoteOption alloc];
    op.optionId=@"0";
    op.optionContent=@"op1";
    op.polledCount=@"0";
    op.voteId=@"0";
    op.isAnswer=@"false";
    
    SSVoteOption *op2=[SSVoteOption alloc];
    op2.optionId=@"0";
    op2.optionContent=@"op2";
    op2.polledCount=@"0";
    op2.voteId=@"0";
    op2.isAnswer=@"true";
    
    NSArray *body = [[NSArray alloc] initWithObjects:op.dictionary,op2.dictionary, nil];
    
    vote.options=body;

    [CommonUtil restapi_CreateVote:vote.dictionary];
}

@end
