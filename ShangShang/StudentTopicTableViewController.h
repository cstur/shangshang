//
//  StudentTopicTableViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-9-28.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "StudentGroupMainTableViewController.h"

@interface StudentTopicTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *listTopic;
@property (nonatomic,assign)SmurfClass *sClass;
@end
