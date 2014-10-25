//
//  StudentViewVoteTableViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-9-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
@interface StudentViewVoteTableViewController : UITableViewController
@property (nonatomic,assign)SmurfClass *sClass;
@property (nonatomic,assign)SSVote *sVote;
@property (nonatomic, strong) NSArray *listOption;
- (void)submitVote;
@end
