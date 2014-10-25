//
//  SSVoteOption.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-17.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "SSVoteOption.h"

@implementation SSVoteOption

@synthesize optionId = optionId_;
@synthesize polledCount = polledCount_;
@synthesize optionContent = optionContent_;
@synthesize voteId = voteId_;
@synthesize isAnswer = isAnswer_;

-(NSDictionary *)dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.optionId,@"id",
            self.voteId,@"voteId",
            self.polledCount,@"polledCount",
            self.optionContent,@"optionContent",
            self.isAnswer,@"isAnswer",
            nil];
}
@end
