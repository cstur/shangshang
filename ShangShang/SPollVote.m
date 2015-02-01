//
//  SPollVote.m
//  ShangShang
//
//  Created by 史东杰 on 14-9-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "SPollVote.h"

@implementation SPollVote
@synthesize userid= userid_;
@synthesize options = options_;

-(NSDictionary *)dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.userid,@"userid",
            self.options,@"option",
            nil];
}
@end
