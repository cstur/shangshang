//
//  VoteManagementViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-11.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "CellVote.h"
#import "SmurfView.h"
@interface VoteManagementViewController : SmurfView<UITableViewDelegate,UITableViewDataSource>
- (IBAction)btnCreateVote:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *listVote;

@end
