//
//  CommonUtil.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-27.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "CommonUtil.h"

NSString *TITLE_SHANGSHANG = @"上商微课堂";
NSString *Interface_InitUser = @"SmurfWeb/rest/user/login";
NSString *DEVICETOKEN = @"";
int limitClass = 20;
int limitVote = 5;
int limitTopic = 5;
int ROLE_Teacher=1;
int ROLE_Student=2;
NSString *SMURF_KEY_USERNAME = @"smurf_username";
NSString *SMURF_KEY_PASSWORD = @"smurf_password";
NSString *SMURF_KEY_USER = @"smurf_user";
NSString *SMURF_KEY_CCLASS=@"smurf_cclass";
NSString *SMURF_KEY_TITLE = @"smurf_title";
NSString *SMURF_KEY_UID = @"smurf_user_id";
@implementation SPostData
@synthesize filePath;
@synthesize data;
@synthesize type;
@synthesize fileName;
@synthesize flag;
@end

@implementation CommonUtil
/*
   +(void)clearUserNameandPassword{
    DBManager *dbManager=[[DBManager alloc] init];
    [dbManager UpdateDictData:@"username" andValue:@""];
    [dbManager UpdateDictData:@"password" andValue:@""];
   }*/

+ (void)showWaiting:(UINavigationController *)nav whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:nav.view];
	[nav.view addSubview:hud];
	hud.labelText = @"请稍候...";

	[hud showAnimated:YES whileExecutingBlock:block completionBlock: ^{
	    [hud removeFromSuperview];
	    [hud release];
	    completion();
	}];
}

+ (void)showWaiting1:(UIView *)view whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	hud.labelText = @"请稍候...";

	[hud showAnimated:YES whileExecutingBlock:block completionBlock: ^{
	    [hud removeFromSuperview];
	    [hud release];
	    completion();
	}];
}

+ (void)restapi_RegisterDevice:(NSString *)token {
	/*
	   @try {
	   NSString* userid=[SSUser getInstance].userid;
	   HttpUtil *httpUtil=[[HttpUtil alloc] init];
	   NSString* url = [NSString stringWithFormat:@"SmurfWeb/View/UserServlet"];
	   url = [url stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
	   NSDictionary *parameters = @{@"action":@"registerdevice", @"userid": userid,@"deviceToken":deviceToken};
	   NSString *response=[httpUtil SendPostRequestWithParam:parameters withURL:url];
	   if (response==nil) {
	   NSException *e;
	   [e raise];
	   }

	   NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	   if ([newStr isEqualToString:@"-1"]) {

	   }
	   NSDictionary *obj=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];

	   }
	   @catch (NSException *exception) {
	   NSLog(@"error register");
	   }*/

	if (token == nil || [token isEqualToString:@""]) {
		return;
	}

	NSString *userid = [SSUser getInstance].userid;
	NSString *postURL = [NSString stringWithFormat:@"http://%@/SmurfWeb/View/UserServlet", [ServerIP getConfigIP]];

	//debug
	//NSString *device=@"90c4ddff1845f51595639db9dc17bb94b7ba5f3deaf6aff6b046cf659ee2b144";
	//NSDictionary *parameters = @{@"action":@"registerdevice", @"userid": userid,@"deviceToken":device};
	NSDictionary *parameters = @{ @"action":@"registerdevice", @"userid": userid, @"deviceToken":token };
	// 使用AFHTTPRequestOperationManager发送POST请求
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];

	[manager
	 POST:postURL
	       parameters:parameters
	 // 获取服务器响应成功时激发的代码块
	 success: ^(AFHTTPRequestOperation *operation, id responseObject)
	{
	    NSString *result = [[NSString alloc] initWithData:responseObject encoding:
	                        NSUTF8StringEncoding];
	    NSLog(@"%@", result);
	}
	 // 获取服务器响应失败时激发的代码块
	 failure: ^(AFHTTPRequestOperation *operation, NSError *error)
	{
	    NSLog(@"获取服务器响应出错！");
	}];
}

+ (void)restapi_PushVote:(NSString *)classid {
	NSString *postURL = [NSString stringWithFormat:@"http://%@/SmurfWeb/View/UserServlet", [ServerIP getConfigIP]];

	NSDictionary *parameters = @{ @"action":@"pushvote", @"classid": classid };
	// 使用AFHTTPRequestOperationManager发送POST请求
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];

	[manager
	 POST:postURL
	       parameters:parameters
	 // 获取服务器响应成功时激发的代码块
	 success: ^(AFHTTPRequestOperation *operation, id responseObject)
	{
	    NSString *result = [[NSString alloc] initWithData:responseObject encoding:
	                        NSUTF8StringEncoding];
	    NSLog(@"%@", result);
	}
	 // 获取服务器响应失败时激发的代码块
	 failure: ^(AFHTTPRequestOperation *operation, NSError *error)
	{
	    NSLog(@"获取服务器响应出错！");
	}];
}

+ (NSArray *)getArrayFromJsonData:(NSData *)jsonData {
	NSString *newStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
}

+ (NSDictionary *)getDictionaryFromJsonData:(NSData *)jsonData {
	return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
}

+ (NSDictionary *)restapi_InitUser:(NSString *)userName Password:(NSString *)password {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];
		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/user/login?username=%@&password=%@", userName, password];
		url = [url stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
		NSData *response = [httpUtil SendGetRequest:url];
		if (response == nil) {
			NSException *e;
			[e raise];
		}
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		if ([newStr isEqualToString:@"-1"]) {
			return nil;
		}
		NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
		return obj;
	}
	@catch (NSException *exception)
	{
		return nil;
	}
}

+ (BOOL)restapi_CreateClass:(NSDictionary *)body {
	HttpUtil *httpUtil = [[HttpUtil alloc] init];
	NSString *url = @"SmurfWeb/rest/teacher/createclass";
	NSString *result = [httpUtil SendPostRequest:url withBody:body];
	if ([result isEqualToString:@"-1"])
		return FALSE;

	return YES;
}

+ (BOOL)restapi_CreateTopic:(NSDictionary *)body {
	HttpUtil *httpUtil = [[HttpUtil alloc] init];
	NSString *url = @"SmurfWeb/rest/teacher/createtopic";
	NSString *result = [httpUtil SendPostRequest:url withBody:body];
	if ([result isEqualToString:@"-1"])
		return FALSE;

	return YES;
}

/*
   body sample:
   {"bigGroupId":7,"comments":null,"endTime":null,"id":0,"name":"vvv","ownerId":100247,"startTime":null,"summary":null}
 */
+ (BOOL)restapi_CreateGroup:(NSDictionary *)body {
	HttpUtil *httpUtil = [[HttpUtil alloc] init];
	NSString *url = @"SmurfWeb/rest/student/creategroup";
	NSString *result = [httpUtil SendPostRequest:url withBody:body];
	if ([result isEqualToString:@"-1"])
		return FALSE;

	return YES;
}

+ (BOOL)restapi_PollVote:(NSDictionary *)body {
	HttpUtil *httpUtil = [[HttpUtil alloc] init];
	NSString *url = @"SmurfWeb/rest/student/pollvote";
	NSString *result = [httpUtil SendPostRequest:url withBody:body];
	if ([result isEqualToString:@"-1"])
		return FALSE;

	return YES;
}

+ (BOOL)restapi_CreateVote:(NSDictionary *)body {
	HttpUtil *httpUtil = [[HttpUtil alloc] init];
	NSString *url = @"SmurfWeb/rest/teacher/createvote";
	NSString *result = [httpUtil SendPostRequest:url withBody:body];
	if ([result isEqualToString:@"-1"])
		return FALSE;

	return YES;
}

+ (BOOL)restapi_AgreeStudent:(NSDictionary *)body {
	HttpUtil *httpUtil = [[HttpUtil alloc] init];
	NSString *url = @"SmurfWeb/rest/teacher/agree";
	NSString *result = [httpUtil SendPostRequest:url withBody:body];
	if ([result isEqualToString:@"-1"])
		return FALSE;
	return YES;
}

+ (BOOL)restapi_DeclineStudent:(NSDictionary *)body {
	HttpUtil *httpUtil = [[HttpUtil alloc] init];
	NSString *url = @"SmurfWeb/rest/teacher/decline";
	NSString *result = [httpUtil SendPostRequest:url withBody:body];
	if ([result isEqualToString:@"-1"])
		return FALSE;
	return YES;
}

+ (NSArray *)restapi_PendingStudent:(NSString *)classid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/verify?classid=%@", classid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		return nil;
	}
}

/*
   +(NSArray*)restapi_PendingStudent:(NSString*)classid{
   @try {
   HttpUtil *httpUtil=[[HttpUtil alloc] init];

   NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/verify?classid=%@",classid];
   NSData *response=[httpUtil SendGetRequest:url];
   NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
   return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
   }
   @catch (NSException *exception) {
   return nil;
   }
   }*/

+ (NSArray *)restapi_StudentList:(NSString *)classid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/students?classid=%@", classid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		return nil;
	}
}

+ (NSArray *)restapi_Student_GetVoteList:(NSString *)classid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/student/getclassvotes?classid=%@", classid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		return nil;
	}
}

+ (NSArray *)restapi_GetClassList:(NSString *)classid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];
		SSUser *user = [SSUser getInstance];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/classes?id=%@", user.userid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		NSLog(@"%@", exception);
	}
}

+ (NSArray *)restapi_GetTopicList:(NSString *)classid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/gettopics?classid=%@", classid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		NSLog(@"%@", exception);
	}
}

+ (NSArray *)restapi_Student_GetTopicList:(NSString *)classid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/student/gettopics?classid=%@", classid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		NSLog(@"%@", exception);
	}
}

+ (NSArray *)restapi_GetGroupList:(NSString *)topicid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/getgroups?topicid=%@", topicid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		NSLog(@"%@", exception);
	}
}

+ (NSArray *)restapi_GetVoteOptions:(NSString *)voteid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/getvoteoptions?voteid=%@", voteid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		return nil;
	}
}

+ (NSArray *)restapi_GetVideoList:(NSString *)userid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/getvideos?userid=%@", userid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		return nil;
	}
}

+ (NSArray *)restapi_GetMediaList:(NSString *)userid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/getimages?userid=%@", userid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		return nil;
	}
}

/*return sample:
   [{"id":100512,"polledCount":1,"optionContent":"答案1","isAnswer":true,"voteId":100115},{"id":100513,"polledCount":1,"optionContent":"答案2","isAnswer":true,"voteId":100115},{"id":100514,"polledCount":0,"optionContent":"不是答案","isAnswer":false,"voteId":100115}]
 */
+ (NSArray *)restapi_Student_GetVoteOptions:(NSString *)voteid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/student/getvoteoptions?voteid=%@", voteid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		return nil;
	}
}

+ (BOOL)parseString:(NSString *)boolStr {
	if ([boolStr isEqualToString:@"true"])
		return YES;
	else if ([boolStr isEqualToString:@"false"])
		return NO;
	return NO;
}

/*Teacher Service API*/
+ (BOOL)teacherapi_deletemedia:(NSDictionary *)body {
	NSString *url = @"SmurfWeb/rest/teacher/deletemedia";
	return [self post:url withBody:body];
}

/*Student Service PAI*/

/*return sample:
   {"users":[{"isEnable":false,"sex":true,"score":0,"space":"","password":"s","pictureId":279,"startTime":null,"id":100370,"vip":false,"username":"s","title":"","nickName":"新用户","email":"","address":"","description":"","voteScore":0,"role":2,"grade":6,"experience":297,"telephone":"","signature":""},{"isEnable":false,"sex":true,"score":0,"space":"","password":"s1","pictureId":259,"startTime":null,"id":100371,"vip":false,"username":"s1","title":"","nickName":"新用户","email":"","address":"","description":"","voteScore":0,"role":2,"grade":5,"experience":99,"telephone":"","signature":""}],"chatinfo":[{"id":99,"smallGroupId":30,"messageTime":{"time":1414250331570},"messageContent":"tt","mediaContentId":0,"senderId":100371},{"id":100,"smallGroupId":30,"messageTime":{"time":1414250336413},"messageContent":"yy","mediaContentId":0,"senderId":100370},{"id":101,"smallGroupId":30,"messageTime":{"time":1414250347070},"messageContent":"ii","mediaContentId":0,"senderId":100371},{"id":102,"smallGroupId":30,"messageTime":{"time":1414250348383},"messageContent":"oo","mediaContentId":0,"senderId":100371},{"id":103,"smallGroupId":30,"messageTime":{"time":1414250351100},"messageContent":"oo","mediaContentId":0,"senderId":100371},{"id":104,"smallGroupId":30,"messageTime":{"time":1414250353087},"messageContent":"lll","mediaContentId":0,"senderId":100371},{"id":105,"smallGroupId":30,"messageTime":{"time":1414250355727},"messageContent":"ppp","mediaContentId":0,"senderId":100371}]}
 */
+ (NSDictionary *)restapi_ChatMessage:(NSString *)groupid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/student/getchatinfo1?groupid=%@", groupid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
		return obj;
	}
	@catch (NSException *exception)
	{
		return nil;
	}
}

/*return sample:
   [{"id":30,"startTime":{"time":1414161108087},"summary":"","bigGroupId":29,"ownerId":100370,"name":"kk                                                ","endTime":{"time":1412173908087},"comments":""}]
 */
+ (NSArray *)restapi_Student_GetGroupList:(NSString *)userid andTopicId:(NSString *)topicid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/student/getgroups?userid=%@&topicid=%@", userid, topicid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		NSLog(@"%@", exception);
	}
}

/*return sample:
   [{"id":100512,"polledCount":1,"optionContent":"答案1","isAnswer":true,"voteId":100115},{"id":100513,"polledCount":1,"optionContent":"答案2","isAnswer":true,"voteId":100115},{"id":100512,"polledCount":1,"optionContent":"答案1","isAnswer":true,"voteId":100115},{"id":100513,"polledCount":1,"optionContent":"答案2","isAnswer":true,"voteId":100115},{"id":100512,"polledCount":1,"optionContent":"答案1","isAnswer":true,"voteId":100115},{"id":100513,"polledCount":1,"optionContent":"答案2","isAnswer":true,"voteId":100115}]
 */
+ (NSArray *)restapi_Student_GetVoteRecord:(NSString *)userid andVoteId:(NSString *)voteid {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];

		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/student/getvoterecord?userid=%@&voteid=%@", userid, voteid];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		NSLog(@"%@", exception);
	}
}

+ (BOOL)restapi_SendChat:(NSDictionary *)body {
	HttpUtil *httpUtil = [[HttpUtil alloc] init];
	NSString *url = @"SmurfWeb/rest/student/sendchat";
	NSString *result = [httpUtil SendPostRequest:url withBody:body];
	if ([result isEqualToString:@"-1"])
		return FALSE;

	return YES;
}

/*Image Util*/
+ (void)saveImage:(UIImage *)image withPath:(NSString *)path {
	NSString *savePath = [NSHomeDirectory() stringByAppendingString:path];
	NSLog(@"path: %@", savePath);
	BOOL ok = [[NSFileManager defaultManager] createFileAtPath:savePath
	                                                  contents:nil attributes:nil];

	if (!ok) {
		NSLog(@"Error creating file %@", savePath);
	}
	else {
		NSFileHandle *myFileHandle = [NSFileHandle fileHandleForWritingAtPath:savePath];
		[myFileHandle writeData:UIImagePNGRepresentation(image)];
		[myFileHandle closeFile];
	}
}

+ (UIImage *)achiveHeadPhoto:(NSString *)userid {
	@try {
		NSString *imgPath = [NSString stringWithFormat:@"/Documents/%@.png", userid];
		NSString *path = [NSHomeDirectory() stringByAppendingString:imgPath];
		NSLog(@"image path:%@", path);
		NSFileManager *fileManager = [NSFileManager defaultManager];

		if ([fileManager fileExistsAtPath:path]) {
			NSFileHandle *myFileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
			UIImage *loadedImage = [UIImage imageWithData:[myFileHandle readDataToEndOfFile]];
			NSLog(@"use local image");
			return loadedImage;
		}
		else {
			NSString *imgData = [self iosapi_headphoto:userid];

			if (imgData == nil) {
				NSLog(@"use default image");
				return [UIImage imageNamed:@"default_phone.jpg"];
			}
			NSData *imageData = [[ImageUtil alloc] dataFromBase64EncodedString:imgData];
			UIImage *myImage = [UIImage imageWithData:imageData];
			[self saveImage:myImage withPath:imgPath];
			NSLog(@"use download image");
			return myImage;
		}
	}
	@catch (NSException *exception)
	{
		UIImage *image = [UIImage imageNamed:@"default_phone.jpg"];
		NSLog(@"use default image");
		return image;
	}
}

+ (UIImage *)getMedia:(NSString *)mediaid {
	if (mediaid == nil) {
		NSLog(@"use default image");
		return [UIImage imageNamed:@"logo_ss"];
	}
	@try {
		NSString *imgPath = [NSString stringWithFormat:@"/Documents/%@.png", mediaid];
		NSString *path = [NSHomeDirectory() stringByAppendingString:imgPath];
		NSLog(@"image path:%@", path);
		NSFileManager *fileManager = [NSFileManager defaultManager];

		if ([fileManager fileExistsAtPath:path]) {
			NSFileHandle *myFileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
			UIImage *loadedImage = [UIImage imageWithData:[myFileHandle readDataToEndOfFile]];
			NSLog(@"use local image");
			return loadedImage;
		}
		else {
			NSString *imgData = [self iosapi_media:mediaid];

			if (imgData == nil) {
				NSLog(@"use default image");
				return [UIImage imageNamed:@"logo_ss"];
			}
			NSData *imageData = [[ImageUtil alloc] dataFromBase64EncodedString:imgData];
			UIImage *myImage = [UIImage imageWithData:imageData];
			[self saveImage:myImage withPath:imgPath];
			NSLog(@"use download image");
			return myImage;
		}
	}
	@catch (NSException *exception)
	{
		UIImage *image = [UIImage imageNamed:@"logo_ss"];
		NSLog(@"use default image");
		return image;
	}
}

+ (UIImage *)getAttach:(NSString *)voteid withFileName:(NSString *)fileName {
	@try {
		NSString *imgPath = [NSString stringWithFormat:@"/Documents/%@", fileName];
		NSString *path = [NSHomeDirectory() stringByAppendingString:imgPath];
		NSLog(@"image path:%@", path);
		NSFileManager *fileManager = [NSFileManager defaultManager];

		if ([fileManager fileExistsAtPath:path]) {
			NSFileHandle *myFileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
			UIImage *loadedImage = [UIImage imageWithData:[myFileHandle readDataToEndOfFile]];
			NSLog(@"use local image");
			return loadedImage;
		}
		else {
			NSString *imgData = [self iosapi_voteImage:voteid];

			if (imgData == nil) {
				NSLog(@"image not found");
				return nil;
			}
			NSData *imageData = [[ImageUtil alloc] dataFromBase64EncodedString:imgData];
			UIImage *myImage = [UIImage imageWithData:imageData];
			[self saveImage:myImage withPath:imgPath];
			NSLog(@"use download image");
			return myImage;
		}
	}
	@catch (NSException *exception)
	{
		UIImage *image = [UIImage imageNamed:@"default_phone.jpg"];
		NSLog(@"use default image");
		return image;
	}
}

+ (UIImage *)getAttachVideo:(NSString *)voteid withFileName:(NSString *)fileName {
	@try {
		NSString *imgPath = [NSString stringWithFormat:@"/Documents/%@", fileName];
		NSString *path = [NSHomeDirectory() stringByAppendingString:imgPath];
		NSLog(@"image path:%@", path);
		NSFileManager *fileManager = [NSFileManager defaultManager];

		if ([fileManager fileExistsAtPath:path]) {
			NSFileHandle *myFileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
			UIImage *loadedImage = [UIImage imageWithData:[myFileHandle readDataToEndOfFile]];
			NSLog(@"use local image");
			return loadedImage;
		}
		else {
			NSString *imgData = [self iosapi_voteImage:voteid];

			if (imgData == nil) {
				NSLog(@"image not found");
				return nil;
			}
			NSData *imageData = [[ImageUtil alloc] dataFromBase64EncodedString:imgData];
			UIImage *myImage = [UIImage imageWithData:imageData];
			[self saveImage:myImage withPath:imgPath];
			NSLog(@"use download image");
			return myImage;
		}
	}
	@catch (NSException *exception)
	{
		UIImage *image = [UIImage imageNamed:@"default_phone.jpg"];
		NSLog(@"use default image");
		return image;
	}
}

/*Video Util*/
+ (NSString *)downloadVideo:(NSString *)url withFileName:(NSString *)fileName {
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:path]) {
		NSLog(@"file exists:%@", path);
		return path;
	}

	operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];

	[operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject)
	{
	    NSLog(@"Successfully downloaded file to %@", path);
	}                                failure: ^(AFHTTPRequestOperation *operation, NSError *error)
	{
	    NSLog(@"Error: %@", error);
	}];
	[operation setDownloadProgressBlock: ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
	{
	    float progress = (float)totalBytesRead / totalBytesExpectedToRead;
	    NSLog(@"Download = %f", progress);
	}];
	[operation start];
	return @"";
}

/*IOS Service API*/
+ (NSString *)getImageByUrl:(NSString *)url {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];
		url = [url stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
		NSData *response = [httpUtil SendGetRequest:url];
		if (response == nil) {
			NSLog(@"get image error");
		}
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		if ([newStr isEqualToString:@"-1"]) {
			return nil;
		}
		NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
		return [obj objectForKey:@"picture"];
	}
	@catch (NSException *exception)
	{
		return nil;
	}
}

+ (NSString *)iosapi_headphoto:(NSString *)userid {
	NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/ios/headphoto?userid=%@", userid];
	return [self getImageByUrl:url];
}

+ (NSString *)iosapi_media:(NSString *)mediaid {
	NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/ios/media?mediaid=%@", mediaid];
	return [self getImageByUrl:url];
}

+ (NSString *)iosapi_voteImage:(NSString *)voteid {
	NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/ios/voteimage?voteid=%@", voteid];
	return [self getImageByUrl:url];
}

/**
   JSON KEYS:
   id
   nickName
   username
   password
   email
   address
   telephone
   role
   grade
   score
   signature
 */
+ (NSMutableDictionary *)iosapi_userinfo:(NSString *)username Password:(NSString *)password {
	@try {
		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/ios/userinfo?username=%@&password=%@", username, password];
		url = [url stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
		NSData *response = [[HttpUtil getInstance] SendGetRequest:url];
		if (response == nil) {
			NSLog(@"response error");
			return nil;
		}
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		if ([newStr isEqualToString:@"-1"]) {
			return nil;
		}
		NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
		NSLog(@"%@", obj);
        obj=[self remvoeNullValue:obj];
        
		return [obj mutableCopy];
	}
	@catch (NSException *exception)
	{
		return nil;
	}
}

+(NSDictionary*)remvoeNullValue:(NSDictionary*)input{
    NSMutableDictionary *m = [NSMutableDictionary dictionary];
    for (NSString *k in [input allKeys]) {
        id v = input[k];
        if (![v isKindOfClass:[NSNull class]]) {
            m[k] = v;
        }
        else {
            m[k] = @"";
        }
    }
    input=[m copy];
    return input;
}

+ (NSArray *)getList:(NSString *)url {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];
		NSData *response = [httpUtil SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		return nil;
	}
}

+ (NSString *)iosapi_logotext {
	NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/user/logotext"];
	NSString *str = [self getString:url];
	NSLog(@"config title:%@", str);
	return str;
}

+ (NSString *)iosapi_abouttext {
	NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/user/about"];
	return [self getString:url];
}

+ (NSString *)getString:(NSString *)url {
	@try {
		HttpUtil *httpUtil = [[HttpUtil alloc] init];
		url = [url stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
		NSData *response = [httpUtil SendGetRequest:url];
		if (response == nil) {
			NSLog(@"response error");
		}
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		if ([newStr isEqualToString:@"-1"]) {
			return nil;
		}
		return newStr;
	}
	@catch (NSException *exception)
	{
		return nil;
	}
}

+ (NSArray *)iosapi_VoteList:(NSString *)classid {
	NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/ios/votelist?classid=%@", classid];
	return [self getList:url];
}

+ (NSArray *)iosapi_VoteDetails:(NSString *)voteid withClassID:(NSString *)classid {
	NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/ios/votedetails?voteid=%@&classid=%@", voteid, classid];
	return [self getList:url];
}

+ (BOOL)post:(NSString *)url withBody:(NSDictionary *)body {
	HttpUtil *httpUtil = [[HttpUtil alloc] init];
	NSString *result = [httpUtil SendPostRequest:url withBody:body];
	if ([result isEqualToString:@"-1"])
		return FALSE;
	return YES;
}

+ (BOOL)iosapi_addspace:(NSDictionary *)body {
	NSString *url = @"SmurfWeb/rest/ios/addspace";
	return [self post:url withBody:body];
}

+ (BOOL)iosapi_updateUserInfo:(NSDictionary *)body {
	NSString *url = @"SmurfWeb/rest/ios/updateuserinfo";
	return [self post:url withBody:body];
}

+ (BOOL)iosapi_addresource:(NSDictionary *)body {
	NSString *url = @"SmurfWeb/rest/ios/addresource";
	return [self post:url withBody:body];
}

/*Common Util*/
+ (NSMutableArray *)readFromArray:(NSString *)path {
	NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
	NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
	return array;
}

+ (void)write:(NSMutableArray *)array toFilePath:(NSString *)path {
	NSData *data = [NSPropertyListSerialization dataWithPropertyList:array format:NSPropertyListBinaryFormat_v1_0 options:NSPropertyListMutableContainersAndLeaves error:NULL];
	BOOL success = [data writeToFile:path atomically:YES];
	if (!success) {
		NSLog(@"write error");
	}
}

+ (NSDictionary *)getConfig {
	NSString *configFile = [NSString stringWithFormat:@"/Documents/config.plist"];
	NSString *path = [NSHomeDirectory() stringByAppendingString:configFile];
	NSMutableArray *configArray = [self readFromArray:path];
	NSDictionary *config = [configArray objectAtIndex:0];
	return config;
}

+ (void)UpdateConfig:(NSDictionary *)newConfig {
	NSString *configFile = [NSString stringWithFormat:@"/Documents/config.plist"];
	NSString *path = [NSHomeDirectory() stringByAppendingString:configFile];
	NSMutableArray *plistArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
	[plistArray insertObject:newConfig atIndex:0];
	[self write:plistArray toFilePath:path];
}

+ (void)ShowAlert:(NSString *)msg withDelegate:(id)dele {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:msg delegate:dele cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[alert show];
}

+ (NSString *)getTagName:(int)index {
	if (index == 0) {
		return @"A";
	}
	if (index == 1) {
		return @"B";
	}
	if (index == 2) {
		return @"C";
	}
	if (index == 3) {
		return @"D";
	}
	if (index == 4) {
		return @"E";
	}
	if (index == 5) {
		return @"F";
	}
	return @"";
}

+ (UIViewController *)getView:(NSString *)stringIdentifier {
	UIStoryboard *m = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	return [m instantiateViewControllerWithIdentifier:stringIdentifier];
}

+ (NSString *)doUpload:(SPostData *)data withProgressInView:(UIViewController *)view {
	__block NSString *attachid = @"";
	NSString *postURL = [NSString stringWithFormat:@"http://%@/SmurfWeb/View/UploadServlet", [ServerIP getConfigIP]];
	NSDictionary *parameters = @{ @"userid": [[[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USER] objectForKey:@"id"], @"filetype":data.type, @"flag":data.flag, @"filename":data.fileName };
	AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];

	NSMutableURLRequest *request =
	    [serializer multipartFormRequestWithMethod:@"POST" URLString:postURL
	                                    parameters:parameters
	                     constructingBodyWithBlock: ^(id < AFMultipartFormData > formData) {
	    if ([data.type isEqualToString:@"img"]) {
	        [formData appendPartWithFileData:data.data                   // 指定上传的文件
	                                    name:@"file"                   // 指定上传文件对应的请求参数名
	         // 指定上传文件的原始文件名
	                                fileName:data.fileName
	         // 指定上传文件的MIME类型
	         mimeType:@"image/*"];
		}
	    else {
	        NSData *videoData = [NSData dataWithContentsOfURL:data.filePath];
	        [formData appendPartWithFileData:videoData                   // 指定上传的文件
	                                    name:@"file"                   // 指定上传文件对应的请求参数名
	         // 指定上传文件的原始文件名
	                                fileName:data.fileName
	         // 指定上传文件的MIME类型
	         mimeType:@"video/*"];
		}
	} error:nil];

	MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view.view];
	[view.view addSubview:HUD];
	HUD.mode = MBProgressHUDModeDeterminate;
	HUD.labelText = @"正在上传...";
	HUD.square = YES;
	[HUD show:YES];

	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
	AFHTTPRequestOperation *operation =
	    [manager HTTPRequestOperationWithRequest:request
	                                     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    attachid = [[NSString alloc] initWithData:responseObject encoding:
	                NSUTF8StringEncoding];
	    NSLog(@"Success %@", attachid);
	    [HUD removeFromSuperview];
	    //[view performSelectorOnMainThread:funsuccess withObject:nil waitUntilDone:YES];
	    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:attachid forKey:@"attachid"];
	    [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadcomplete" object:nil userInfo:userInfo];
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    NSLog(@"Failure %@", error.description);
	    [HUD removeFromSuperview];
	    [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadfail" object:nil];
	}];

	[operation setUploadProgressBlock: ^(NSUInteger __unused bytesWritten,
	                                     long long totalBytesWritten,
	                                     long long totalBytesExpectedToWrite) {
	    NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
	    long long p = totalBytesWritten / totalBytesExpectedToWrite;
	    HUD.progress = p;
	}];

	[operation start];
	return attachid;
}

+ (NSDate *)dateFromMillis:(long long)millis {
	return [NSDate dateWithTimeIntervalSince1970:(millis / 1000)];
}

@end
