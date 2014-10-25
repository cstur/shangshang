//
//  CommonUtil.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-27.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "NIDropDown.h"
#import "SSUser.h"
#import "HttpUtil.h"
#import "UpdateManager.h"
#import "ImageUtil.h"
#import "SmurfClass.h"
#import "QREncoder.h"
#import "SSVote.h"
#import "SSVoteOption.h"
#import "SPollVote.h"
#import "AFHTTPRequestOperationManager.h"

extern NSString *TITLE_SHANGSHANG;
extern NSString *deviceToken;

@interface CommonUtil : NSObject
+ (void)showWaiting:(UINavigationController*)nav whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion;

+(NSArray*)getArrayFromJsonData:(NSData*) jsonData;
+(NSDictionary*)getDictionaryFromJsonData:(NSData*) jsonData;
+(NSDictionary*)restapi_InitUser:(NSString*)username Password:(NSString*)password;
+(BOOL)restapi_CreateClass:(NSDictionary*)body;
+(BOOL)restapi_CreateVote:(NSDictionary*)body;
+(BOOL)restapi_CreateGroup:(NSDictionary*)body;
+(BOOL)restapi_CreateTopic:(NSDictionary*)body;
+(void)restapi_RegisterDevice;
+(NSArray*)restapi_Student_GetGroupList:(NSString*)userid andTopicId:(NSString*)topicid;
+(NSArray*)restapi_GetGroupList:(NSString*)topicid;
+(BOOL)restapi_PollVote:(NSDictionary*)body;
+(NSArray*)restapi_PendingStudent:(NSString*)classid;
+(NSArray*)restapi_StudentList:(NSString*)classid;
+(NSArray*)restapi_GetVoteList:(NSString*)classid;
+(NSArray*)restapi_GetVideoList:(NSString*)classid;
+(NSArray*)restapi_GetClassList:(NSString*)classid;
+(NSArray*)restapi_GetTopicList:(NSString*)classid;
+(NSArray*)restapi_Student_GetTopicList:(NSString*)classid;
+(void)restapi_PushVote:(NSString*)classid;
+(NSArray*)restapi_Student_GetVoteList:(NSString*)classid;
+(NSArray*)restapi_Student_GetVoteOptions:(NSString*)voteid;
+(NSArray*)restapi_GetVoteOptions:(NSString*)voteid;
+(BOOL)restapi_AgreeStudent:(NSArray*)body;
+(BOOL)restapi_DeclineStudent:(NSArray*)body;
+(BOOL)parseString:(NSString*)boolStr;


@end
