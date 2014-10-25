//
//  SSUser.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-21.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSUser : NSObject
{
    NSString *userid_;
    NSString *nickName_;
    NSString *password_;
    NSString *userName_;
    NSString *tel_;
    NSString *email_;
    NSString *imgData_;
    NSString *address_;
    NSString *role_;
    NSString *sex_;
    NSString *vip_;
    
    NSString *questionid1_;
    NSString *questionindex1_;
    NSString *answer1_;
    NSString *questionid2_;
    NSString *questionindex2_;
    NSString *answer2_;
    NSString *questionid3_;
    NSString *questionindex3_;
    NSString *answer3_;
    
    NSString *needUpdateFace_;
    
    //NSString *grade_;
    NSString *score_;
    
}

@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *imgData;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *role;
@property (nonatomic, retain) NSString *sex;
@property (nonatomic, retain) NSString *vip;

@property (nonatomic, retain) NSString *questionid1;
@property (nonatomic, retain) NSString *questionindex1;
@property (nonatomic, retain) NSString *answer1;
@property (nonatomic, retain) NSString *questionid2;
@property (nonatomic, retain) NSString *questionindex2;
@property (nonatomic, retain) NSString *answer2;
@property (nonatomic, retain) NSString *questionid3;
@property (nonatomic, retain) NSString *questionindex3;
@property (nonatomic, retain) NSString *answer3;

@property (nonatomic, retain) NSString *needUpdateFace;

@property (nonatomic, assign) NSNumber *grade;
//@property (nonatomic, assign) NSNumber *score;
//@property (nonatomic, retain) NSString *grade;
@property (nonatomic, retain) NSString *score;
+(SSUser*)getInstance;

+ (NSString *)urlencode:(NSString*)input;

-(NSDictionary *)dictionary;

-(NSDictionary *)dictionary_Register;

+(BOOL) initWith:(NSString*) userName andPassword:(NSString*)password;
@end
