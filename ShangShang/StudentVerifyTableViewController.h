//
//  StudentVerifyTableViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "StudentVerifyTableViewCell.h"
#import "SmurfTableView.h"

@interface StudentVerifyTableViewController : SmurfTableView
@property (nonatomic, strong) NSArray *listPendingStudent;

@end
