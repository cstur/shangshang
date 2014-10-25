//
//  ViewVoteViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-17.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "ViewOptionTableViewCell.h"
#import "VoteDetailTableViewController.h"

@interface ViewVoteViewController : UITableViewController
@property (nonatomic,assign)SmurfClass *sClass;
@property (nonatomic,assign)SSVote *sVote;
@property (nonatomic, strong) NSArray *listOption;

-(void)voteDetails;
-(void)voteSum;
-(void)pushVote;
-(void)release;
@end
