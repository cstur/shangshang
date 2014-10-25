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

@interface HttpUtil : NSObject{
    NSString* server;
}
-(NSData*) SendGetRequest:(NSString*)str;
-(NSString*)SendPostRequest:(NSString *)str withBody:(id) obj;
-(NSString*)SendPostRequestWithParam:(NSDictionary *)param withURL:(NSString*) urlShort;
- (NSData *)toJSONData:(id)theData;

+(NSString*)toJSONString:(id)theData;

- (void)simpleJsonParsingPostMetod:(NSData*)imgData;
@end
