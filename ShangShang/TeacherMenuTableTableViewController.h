//
//  TeacherMenuTableTableViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassIndex;
@interface TeacherMenuTableTableViewController : UITableViewController
@property(nonatomic,assign) ClassIndex *delegate;
@property (nonatomic, strong) NSArray *listMenu;
@end
