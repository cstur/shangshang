//
//  HttpUtil.m
//  SmurfApp
//
//  Created by 史东杰 on 14-5-23.
//  Copyright (c) 2014年 史东杰. All rights reserved.
//

#import "HttpUtil.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@implementation HttpUtil

static HttpUtil *instance = nil;

+ (HttpUtil *)getInstance {
	@synchronized(self)
	{
		if (instance == nil) {
			instance = [HttpUtil new];
		}
	}
	return instance;
}

- (id)init {
	if (self = [super init]) {
		server =  [ServerIP getConfigIP];
	}
	return self;
}

- (NSData *)SendGetRequest:(NSString *)str {
	NSString *urlStr = [NSString stringWithFormat:@"http://%@/%@", server, str];
	NSURL *url = [NSURL URLWithString:urlStr];
	NSLog(@"request url:%@", url);
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request startSynchronous];
	NSError *error = [request error];
	if (!error) {
		NSData *response = [request responseData];
		return response;
	}
	return nil;
}

- (void)post:(NSString *)urlString withCompletionBlock:(FinshLoadBlock)block {
	[self send:urlString withCompletionBlock:block withTimeOut:60.0 withMethod:@"POST"];
}

- (void)get:(NSString *)urlString withCompletionBlock:(FinshLoadBlock)block withTimeOut:(NSTimeInterval)timeout {
	[self send:urlString withCompletionBlock:block withTimeOut:timeout withMethod:@"GET"];
}

- (void)send:(NSString *)urlString withCompletionBlock:(FinshLoadBlock)block withTimeOut:(NSTimeInterval)timeout withMethod:(NSString *)method {
	NSURL *URL = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
	[request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	[request setTimeoutInterval:timeout];
	[request setHTTPMethod:method];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:block];
}

- (void)GetAsynchronous:(NSString *)str withDelegate:(id)delegate {
	NSString *urlStr = [NSString stringWithFormat:@"http://%@/%@", server, str];
	NSURL *url = [NSURL URLWithString:urlStr];
	NSLog(@"request url:%@", url);
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:delegate];
	[request startAsynchronous];
}

+ (NSString *)toJSONString:(id)theData {
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
	                                                   options:NSJSONWritingPrettyPrinted
	                                                     error:&error];
	if ([jsonData length] > 0 && error == nil) {
		NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
		return jsonString;
	}
	else {
		return nil;
	}
}

- (NSData *)toJSONData:(id)theData {
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
	                                                   options:NSJSONWritingPrettyPrinted
	                                                     error:&error];
	if ([jsonData length] > 0 && error == nil) {
		return jsonData;
	}
	else {
		return nil;
	}
}

- (NSString *)SendPostRequest:(NSString *)str withBody:(id)obj {
	NSData *jsonData = [self toJSONData:obj];

	NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	NSLog(@"JSON Output: %@", jsonString);

	NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];

	NSString *urlStr = [NSString stringWithFormat:@"http://%@/%@", server, str];
	NSURL *url = [NSURL URLWithString:urlStr];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
	[request setRequestMethod:@"POST"];
	[request setPostBody:tempJsonData];
	[request startSynchronous];
	NSError *error1 = [request error];
	if (!error1) {
		NSString *response = [request responseString];
		NSLog(@"Response：%@", response);
		return response;
	}

	return @"-1";
}

- (NSString *)SendPostRequestWithParam:(NSDictionary *)param withURL:(NSString *)urlShort {
	NSString *urlStr = [NSString stringWithFormat:@"http://%@/%@", server, urlShort];
	NSURL *url = [NSURL URLWithString:urlStr];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

	NSArray *keys = [param allKeys];

	// values in foreach loop
	for (NSString *key in keys) {
		//NSLog(@"%@ is %@",key, [dict objectForKey:key]);
		[request addRequestHeader:key value:[param objectForKey:key]];
	}
	[request setRequestMethod:@"POST"];
	[request startSynchronous];
	NSError *error1 = [request error];
	if (!error1) {
		NSString *response = [request responseString];
		NSLog(@"Test：%@", response);
		return response;
	}

	return @"-1";
}

@end
