//
//  StudentGroupMainTableViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-9-28.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateGroupViewController.h"
#import "ViewGroupTableViewController.h"
#import "SerachGroupTableViewController.h"

@interface StudentGroupMainTableViewController : UITableViewController
@property (nonatomic, retain) NSString *topicName;
@property (nonatomic, retain) NSString *topicID;
@property (retain, nonatomic) IBOutlet UILabel *labelGroupName;

@end
