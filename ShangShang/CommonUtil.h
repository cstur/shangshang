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
#import "ImageUtil.h"
#import "SmurfClass.h"
#import "QREncoder.h"
#import "SSVote.h"
#import "SSVoteOption.h"
#import "SPollVote.h"
#import "AFHTTPRequestOperationManager.h"
#import <CoreMedia/CoreMedia.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DBManager.h"
#import "SmurfUI.h"

extern NSString *TITLE_SHANGSHANG;
extern NSString *DEVICETOKEN;
extern NSString *SEARCHFROM;
extern int limitClass;
extern int limitVote;
extern int limitTopic;

@interface SPostData: NSObject

@property (nonatomic, retain) NSURL *filePath;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *flag;

@end

@interface CommonUtil : NSObject
+(void)clearUserNameandPassword;
+(NSDictionary*)getConfig;
+(void)write:(NSMutableArray*)array toFilePath:(NSString*)path;
+(void)UpdateConfig:(NSDictionary *)newConfig;
+ (void)showWaiting:(UINavigationController*)nav whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion;
+ (void)showWaiting1:(UIView*)view whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion;

+(NSArray*)getArrayFromJsonData:(NSData*) jsonData;
+(NSDictionary*)getDictionaryFromJsonData:(NSData*) jsonData;
+(NSDictionary*)restapi_InitUser:(NSString*)username Password:(NSString*)password;
+(BOOL)restapi_CreateClass:(NSDictionary*)body;
+(BOOL)restapi_CreateVote:(NSDictionary*)body;
+(BOOL)restapi_CreateGroup:(NSDictionary*)body;
+(BOOL)restapi_CreateTopic:(NSDictionary*)body;
+(NSArray*)restapi_GetGroupList:(NSString*)topicid;
+(BOOL)restapi_PollVote:(NSDictionary*)body;
+(NSArray*)restapi_PendingStudent:(NSString*)classid;
+(NSArray*)restapi_StudentList:(NSString*)classid;

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
+(NSArray*)restapi_GetMediaList:(NSString*)userid;
/*Teacher Service API*/
+(BOOL) teacherapi_deletemedia:(NSDictionary*)body;

/*Student Service API*/
+(NSDictionary*)restapi_ChatMessage:(NSString*)groupid;
+(NSArray*)restapi_Student_GetGroupList:(NSString*)userid andTopicId:(NSString*)topicid;
+(NSArray*)restapi_Student_GetVoteRecord:(NSString*)userid andVoteId:(NSString*)voteid;
+(BOOL)restapi_SendChat:(NSDictionary*)body;

/*Image Util*/
+(void) saveImage:(UIImage*)image withPath:(NSString*)path;
+(UIImage*) getImage:(NSString*)userid;
+(UIImage*) getMedia:(NSString*)mediaid;
+(UIImage*) getAttach:(NSString*)voteid withFileName:(NSString*)fileName;

/*Video Util*/
+(NSString*) downloadVideo:(NSString*)url withFileName:(NSString*)fileName;

/*IOS Service API*/
+(NSString*) iosapi_headphoto:(NSString*)userid;
+(NSString*) iosapi_logotext;
+(NSString*) iosapi_abouttext;
+(NSString*) iosapi_voteImage:(NSString*)voteid;
+(NSString*) getImageByUrl:(NSString*) url;
+(NSDictionary*) iosapi_userinfo:(NSString*)username Password:(NSString*)password;
+(NSArray*)getList:(NSString*)url;
+(BOOL) post:(NSString*)url withBody:(NSDictionary*)body;

+(NSArray*)iosapi_VoteList:(NSString*)classid;
+(NSArray*)iosapi_VoteDetails:(NSString*)voteid withClassID:(NSString*)classid;
+(BOOL) iosapi_addspace:(NSDictionary*)body;
+(BOOL) iosapi_addresource:(NSDictionary*)body;
+(BOOL) iosapi_updateUserInfo:(NSDictionary*)body;

/*Common Util*/
+(void)ShowAlert:(NSString*)msg withDelegate:(id)delegate;
+(NSString*)getTagName:(int)index;
+(UIViewController*)getView:(NSString*)stringIdentifier;
+ (NSString*)doUpload:(SPostData*)data withProgressInView:(UIViewController*) view;
+ (NSDate*)dateFromMillis:(long long)millis;
/*Servlet API*/
+(void)restapi_RegisterDevice:(NSString*)token;
@end
