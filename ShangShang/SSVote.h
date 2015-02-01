//
//  SSVote.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-17.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSVote : NSObject
{
    NSString *voteid_;
    NSString *title_;
    NSString *attachids_;
    NSString *classid_;
    NSArray *options_;
    NSString *attachName_;
}

@property (nonatomic, retain) NSString *voteid;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *attachids;
@property (nonatomic, retain) NSString *attachName;
@property (nonatomic, retain) NSString *classid;
@property (nonatomic, retain) NSArray *options;
@property (nonatomic, assign) bool hasAttach;

-(NSDictionary *)dictionary;
-(NSDictionary *)dictionarywithAttach;
@end
