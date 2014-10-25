//
//  StudentVoteViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-9-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "StudentViewVoteTableViewController.h"
@interface StudentVoteViewController : UITableViewController
@property (nonatomic,assign)SmurfClass *sClass;
@property (nonatomic, strong) NSArray *listVote;
@end
