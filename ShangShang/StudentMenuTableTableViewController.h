//
//  StudentMenuTableTableViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-9-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassViewController;
@interface StudentMenuTableTableViewController : UITableViewController
@property(nonatomic,assign) ClassViewController *delegate;
@property (nonatomic, strong) NSArray *listMenu;
@end
