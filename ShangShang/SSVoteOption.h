//
//  SSVoteOption.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-17.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSVoteOption : NSObject
{
    NSString *optionId_;
    NSString *polledCount_;
    NSString *optionContent_;
    NSString *voteId_;
    NSString *isAnswer_;
}

@property (nonatomic, retain) NSString *optionId;
@property (nonatomic, retain) NSString *polledCount;
@property (nonatomic, retain) NSString *optionContent;
@property (nonatomic, retain) NSString *voteId;
@property (nonatomic, retain) NSString *isAnswer;
-(NSDictionary *)dictionary;
@end
