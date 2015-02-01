//
//  ServerIP.h
//  ShangShang
//
//  Created by 史东杰 on 14-10-21.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
@interface ServerIP : NSObject
+(NSString*)getConfigIP;
+(NSString*)getText;
+(void)updateText:(NSString*)newIP;
@end
