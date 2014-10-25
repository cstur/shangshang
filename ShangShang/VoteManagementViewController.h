//
//  VoteManagementViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-11.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
@interface VoteManagementViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)btnCreateVote:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *listVote;
@property (nonatomic,assign)SmurfClass *sClass;
@end
