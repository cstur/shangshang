//
//  ServerIP.m
//  ShangShang
//
//  Created by 史东杰 on 14-10-21.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ServerIP.h"

#define SERVERIP @"ServerIP"

@implementation ServerIP
+(NSString*)getConfigIP{
    NSString *ip=[self getText];
    NSLog(@"server ip:%@",ip);
    return ip;
}

+(NSString*)getText{
    return [[DBManager getInstance] getDictValue:SERVERIP];
}

+(void)updateText:(NSString*)newIP{
    [[DBManager getInstance] UpdateDictData:SERVERIP andValue:newIP];
}
@end
