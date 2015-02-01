//
//  ViewGroupTableViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-9-28.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "ChatView.h"
#import "ChatViewTest.h"
@interface ViewGroupTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *listGroup;
@property (nonatomic, retain) NSString *topicID;
@end
