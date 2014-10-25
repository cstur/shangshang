//
//  ServerIP.m
//  ShangShang
//
//  Created by 史东杰 on 14-10-21.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ServerIP.h"

@implementation ServerIP
+(NSString*)getConfigIP{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ServerConfig" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    //return [dict objectForKey:@"ServerIP"];
    //debug server:
    //return @"172.16.144.123:8082";
    return @"192.168.2.104:8080";
}
@end
