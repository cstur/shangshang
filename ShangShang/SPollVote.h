//
//  SPollVote.h
//  ShangShang
//
//  Created by 史东杰 on 14-9-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPollVote : NSObject
{
    NSString *userid_;
    NSArray *options_;
}

@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSArray *options;
-(NSDictionary *)dictionary;
@end
