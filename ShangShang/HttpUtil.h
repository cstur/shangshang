//
//  HttpUtil.h
//  SmurfApp
//
//  Created by 史东杰 on 14-5-23.
//  Copyright (c) 2014年 史东杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ServerIP.h"

typedef void (^FinshLoadBlock) (NSURLResponse *response, NSData *data, NSError *error);

@interface HttpUtil : NSObject {
	NSString *server;
}
+ (HttpUtil *)getInstance;
- (NSData *)SendGetRequest:(NSString *)str;
- (NSArray *)getArrayData:(NSString *)url;
- (NSString *)SendPostRequest:(NSString *)str withBody:(id)obj;
- (NSString *)SendPostRequestWithParam:(NSDictionary *)param withURL:(NSString *)urlShort;
- (NSData *)toJSONData:(id)theData;
- (void)GetAsynchronous:(NSString *)str withDelegate:(id)delegate;
- (void)post:(NSString *)urlString withCompletionBlock:(FinshLoadBlock)block;
- (void)get:(NSString *)urlString withCompletionBlock:(FinshLoadBlock)block withTimeOut:(NSTimeInterval)timeout;
- (void)send:(NSString *)urlString withCompletionBlock:(FinshLoadBlock)block withTimeOut:(NSTimeInterval)timeout withMethod:(NSString *)method;
+ (NSString *)toJSONString:(id)theData;

@end
