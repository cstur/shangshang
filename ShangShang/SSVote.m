//
//  SSVote.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-17.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "SSVote.h"

@implementation SSVote
@synthesize title = title_;
@synthesize attachids = attachids_;
@synthesize classid = classid_;
@synthesize options = options_;
@synthesize voteid = voteid_;

-(NSDictionary *)dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.title,@"title",
            self.classid,@"classid",
            self.options,@"options",
            nil];
}

-(NSDictionary *)dictionarywithAttach{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.title,@"title",
            self.attachids,@"attachids",
            self.classid,@"classid",
            self.options,@"options",
            nil];
}
@end
