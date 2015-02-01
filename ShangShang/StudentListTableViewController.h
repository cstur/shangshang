//
//  StudentListTableViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-11.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
@interface StudentListTableViewController : UITableViewController
@property (nonatomic,assign)SmurfClass *sClass;
@property (nonatomic, strong) NSArray *listStudent;
@end
