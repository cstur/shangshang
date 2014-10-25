//
//  SSUser.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-21.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "SSUser.h"
#import "HttpUtil.h"
#import "UpdateManager.h"
#import "CommonUtil.h"
@implementation SSUser

@synthesize userid = userid_;
@synthesize userName = userName_;
@synthesize tel = tel_;
@synthesize address = address_;
@synthesize email = email_;
@synthesize imgData = imgData_;
@synthesize password = password_;
@synthesize role = role_;
@synthesize sex = sex_;
@synthesize vip = vip_;
@synthesize nickName = nickName_;

@synthesize questionid1 = questionid1_;
@synthesize questionindex1 = questionindex1_;
@synthesize answer1 = answer1_;
@synthesize questionid2 = questionid2_;
@synthesize questionindex2 = questionindex2_;
@synthesize answer2 = answer2_;
@synthesize questionid3 = questionid3_;
@synthesize questionindex3 = questionindex3_;
@synthesize answer3 = answer3_;

@synthesize needUpdateFace = needUpdateFace_;

//@synthesize grade = grade_;
@synthesize score = score_;

-(void) dealloc {
    self.userid = nil;
    self.userName = nil;
    self.tel = nil;
    self.address = nil;
    self.email = nil;
    self.imgData = nil;
    self.password= nil;
    self.role= nil;
    self.sex= nil;
    self.vip= nil;
    
    self.questionid1=nil;
    self.questionindex1=nil;
    self.answer1=nil;
    self.questionid2=nil;
    self.questionindex2=nil;
    self.answer2=nil;
    self.questionid3=nil;
    self.questionindex3=nil;
    self.answer3=nil;
    
    self.needUpdateFace=nil;
    [super dealloc];
}

static SSUser *instance = nil;

+(SSUser *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [SSUser new];
            instance.needUpdateFace=@"1";
        }
    }
    return instance;
}

-(NSDictionary *)dictionary_Register {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.userName,@"username",
            self.password,@"password",
            self.role,@"role",
            self.sex,@"sex",
            self.vip, @"vip",
            self.questionid1,@"questionid1",
            self.questionindex1,@"questionindex1",
            self.answer1,@"answer1",
            self.questionid2,@"questionid2",
            self.questionindex2,@"questionindex2",
            self.answer2,@"answer2",
            self.questionid3,@"questionid3",
            self.questionindex3,@"questionindex3",
            self.answer3,@"answer3",
            nil];
}

-(NSDictionary *)dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.userid,@"id",
            self.nickName,@"nickname",
            self.address,@"address",
            self.email,@"email",
            self.tel, @"telephone",
            self.imgData, @"picture",
            nil];
}

+ (NSString *)urlencode:(NSString*)input {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)input;
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

+(BOOL) initWith:(NSString *)userName andPassword:(NSString *)password{
    NSDictionary *user=[CommonUtil restapi_InitUser:userName Password:password];
    
    if (user==nil) {
        return FALSE;
    }else{
        [SSUser getInstance].userid=[user objectForKey:@"id"];
        [SSUser getInstance].nickName=[user objectForKey:@"nickName"];
        [SSUser getInstance].userName=[user objectForKey:@"username"];
        [SSUser getInstance].imgData=[user objectForKey:@"picture"];
        [SSUser getInstance].password=[user objectForKey:@"password"];
        [SSUser getInstance].email=[user objectForKey:@"email"];
        [SSUser getInstance].address=[user objectForKey:@"address"];
        [SSUser getInstance].tel=[user objectForKey:@"telephone"];
        [SSUser getInstance].role=[user objectForKey:@"role"];
        [SSUser getInstance].grade=[user objectForKey:@"grade"];
        [SSUser getInstance].score=[user objectForKey:@"score"];
        [SSUser getInstance].needUpdateFace=@"1";
        UpdateManager *um=[[UpdateManager alloc] initwithType:0];
        [um updateValuebykey:@"username" value:[SSUser getInstance].userName];
        [um updateValuebykey:@"password" value:[SSUser getInstance].password];
        return TRUE;
    }
    return true;
}
@end
