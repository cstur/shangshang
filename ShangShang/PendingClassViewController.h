//
//  PendingClassViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-30.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassViewController.h"
@interface PendingClassViewController : UITableViewController
@property (nonatomic, strong) NSArray *listPendingClass;
- (IBAction)btnBack:(id)sender;

@end
