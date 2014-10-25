//
//  CommonUtil.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-27.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "CommonUtil.h"

NSString* TITLE_SHANGSHANG=@"上商微课堂";
NSString* Interface_InitUser=@"SmurfWeb/rest/user/login";
NSString* deviceToken=@"";
@implementation CommonUtil

+ (void)showWaiting:(UINavigationController*)nav whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion{
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:nav.view];
	[nav.view addSubview:hud];
	hud.labelText = @"请稍候...";
	
	[hud showAnimated:YES whileExecutingBlock:block completionBlock:^{
		[hud removeFromSuperview];
		[hud release];
        completion();
	}];
}

+(void)restapi_RegisterDevice{
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
    
    if ([deviceToken isEqualToString:@""]) {
        return;
    }
    
    NSString* userid=[SSUser getInstance].userid;
    NSString *postURL=[NSString stringWithFormat:@"http://%@/SmurfWeb/View/UserServlet",[ServerIP getConfigIP]];
    
    //debug
    //NSString *device=@"90c4ddff1845f51595639db9dc17bb94b7ba5f3deaf6aff6b046cf659ee2b144";
    //NSDictionary *parameters = @{@"action":@"registerdevice", @"userid": userid,@"deviceToken":device};
	NSDictionary *parameters = @{@"action":@"registerdevice", @"userid": userid,@"deviceToken":deviceToken};
	// 使用AFHTTPRequestOperationManager发送POST请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];

	[manager
     POST:postURL
     parameters:parameters
     // 获取服务器响应成功时激发的代码块
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString* result=[[NSString alloc] initWithData:responseObject encoding:
                           NSUTF8StringEncoding];
         NSLog(result);
     }
     // 获取服务器响应失败时激发的代码块
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"获取服务器响应出错！");
     }];
}

+(void)restapi_PushVote:(NSString*)classid{
    
    NSString *postURL=[NSString stringWithFormat:@"http://%@/SmurfWeb/View/UserServlet",[ServerIP getConfigIP]];
    
	NSDictionary *parameters = @{@"action":@"pushvote", @"classid": classid};
	// 使用AFHTTPRequestOperationManager发送POST请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
	[manager
     POST:postURL
     parameters:parameters
     // 获取服务器响应成功时激发的代码块
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString* result=[[NSString alloc] initWithData:responseObject encoding:
                           NSUTF8StringEncoding];
         NSLog(result);
     }
     // 获取服务器响应失败时激发的代码块
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"获取服务器响应出错！");
     }];
}

+(NSArray*)getArrayFromJsonData:(NSData*) jsonData{
    NSString* newStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
}

+(NSDictionary*)getDictionaryFromJsonData:(NSData*) jsonData{
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
}

+(NSDictionary*)restapi_InitUser:(NSString*)userName Password:(NSString*)password{
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/user/login?username=%@&password=%@",userName,password];
        url = [url stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
        NSData *response=[httpUtil SendGetRequest:url];
        if (response==nil) {
            NSException *e;
            [e raise];
        }
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        if ([newStr isEqualToString:@"-1"]) {
            return nil;
        }
        NSDictionary *obj=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        return obj;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

+(BOOL)restapi_CreateClass:(NSDictionary*)body{
    HttpUtil *httpUtil=[[HttpUtil alloc] init];
    NSString* url = @"SmurfWeb/rest/teacher/createclass";
    NSString* result= [httpUtil SendPostRequest:url withBody:body];
    if ([result isEqualToString:@"-1"])
        return FALSE;
    
    return YES;
}

+(BOOL)restapi_CreateTopic:(NSDictionary*)body{
    HttpUtil *httpUtil=[[HttpUtil alloc] init];
    NSString* url = @"SmurfWeb/rest/teacher/createtopic";
    NSString* result= [httpUtil SendPostRequest:url withBody:body];
    if ([result isEqualToString:@"-1"])
        return FALSE;
    
    return YES;
}

/*
 body sample:
 {"bigGroupId":7,"comments":null,"endTime":null,"id":0,"name":"vvv","ownerId":100247,"startTime":null,"summary":null}
 */
+(BOOL)restapi_CreateGroup:(NSDictionary*)body{
    HttpUtil *httpUtil=[[HttpUtil alloc] init];
    NSString* url = @"SmurfWeb/rest/student/creategroup";
    NSString* result= [httpUtil SendPostRequest:url withBody:body];
    if ([result isEqualToString:@"-1"])
        return FALSE;
    
    return YES;
}

+(BOOL)restapi_PollVote:(NSDictionary*)body{
    HttpUtil *httpUtil=[[HttpUtil alloc] init];
    NSString* url = @"SmurfWeb/rest/student/pollvote";
    NSString* result= [httpUtil SendPostRequest:url withBody:body];
    if ([result isEqualToString:@"-1"])
        return FALSE;
    
    return YES;
}

+(BOOL)restapi_CreateVote:(NSDictionary*)body{
    HttpUtil *httpUtil=[[HttpUtil alloc] init];
    NSString* url = @"SmurfWeb/rest/teacher/createvote";
    NSString* result= [httpUtil SendPostRequest:url withBody:body];
    if ([result isEqualToString:@"-1"])
        return FALSE;
    
    return YES;
}

+(BOOL)restapi_AgreeStudent:(NSDictionary*)body{
    HttpUtil *httpUtil=[[HttpUtil alloc] init];
    NSString* url = @"SmurfWeb/rest/teacher/agree";
    NSString* result= [httpUtil SendPostRequest:url withBody:body];
    if ([result isEqualToString:@"-1"])
        return FALSE;
    return YES;
}

+(BOOL)restapi_DeclineStudent:(NSDictionary*)body{
    HttpUtil *httpUtil=[[HttpUtil alloc] init];
    NSString* url = @"SmurfWeb/rest/teacher/decline";
    NSString* result= [httpUtil SendPostRequest:url withBody:body];
    if ([result isEqualToString:@"-1"])
        return FALSE;
    return YES;
}

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


+(NSArray*)restapi_GetVoteList:(NSString*)classid{
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/getvotes?classid=%@",classid];
        NSData *response=[httpUtil SendGetRequest:url];
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    }
    @catch (NSException *exception) {
        return nil;
    }
}

+(NSArray*)restapi_StudentList:(NSString*)classid{
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/students?classid=%@",classid];
        NSData *response=[httpUtil SendGetRequest:url];
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    }
    @catch (NSException *exception) {
        return nil;
    }
}

+(NSArray*)restapi_Student_GetVoteList:(NSString*)classid{
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/student/getclassvotes?classid=%@",classid];
        NSData *response=[httpUtil SendGetRequest:url];
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    }
    @catch (NSException *exception) {
        return nil;
    }
}

+(NSArray*)restapi_GetClassList:(NSString*)classid{
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        SSUser *user = [SSUser getInstance];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/classes?id=%@",user.userid];
        NSData *response=[httpUtil SendGetRequest:url];
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

+(NSArray*)restapi_GetTopicList:(NSString*)classid{
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/gettopics?classid=%@",classid];
        NSData *response=[httpUtil SendGetRequest:url];
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

+(NSArray*)restapi_Student_GetTopicList:(NSString*)classid{
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/student/gettopics?classid=%@",classid];
        NSData *response=[httpUtil SendGetRequest:url];
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

+(NSArray*)restapi_Student_GetGroupList:(NSString*)userid andTopicId:(NSString*)topicid{
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/student/getgroups?userid=%@&topicid=%@",userid,topicid];
        NSData *response=[httpUtil SendGetRequest:url];
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

+(NSArray*)restapi_GetGroupList:(NSString*)topicid{
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/getgroups?topicid=%@",topicid];
        NSData *response=[httpUtil SendGetRequest:url];
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}


+(NSArray*)restapi_GetVoteOptions:(NSString*)voteid{
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/getvoteoptions?voteid=%@",voteid];
        NSData *response=[httpUtil SendGetRequest:url];
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    }
    @catch (NSException *exception) {
        return nil;
    }
}

+(NSArray*)restapi_GetVideoList:(NSString*)userid{
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/getvideos?userid=%@",userid];
        NSData *response=[httpUtil SendGetRequest:url];
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    }
    @catch (NSException *exception) {
        return nil;
    }}

+(NSArray*)restapi_Student_GetVoteOptions:(NSString*)voteid{
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/student/getvoteoptions?voteid=%@",voteid];
        NSData *response=[httpUtil SendGetRequest:url];
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    }
    @catch (NSException *exception) {
        return nil;
    }
}

+(BOOL)parseString:(NSString*)boolStr{
    if ([boolStr isEqualToString:@"true"])
        return YES;
    else if ([boolStr isEqualToString:@"false"])
        return NO;
    return NO;
}
@end
