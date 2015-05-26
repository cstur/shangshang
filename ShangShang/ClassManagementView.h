//
//  TeacherClassManagementViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-4.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassManagementView.h"
#import "SmurfView.h"

@interface ClassManagementView : SmurfView<UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *listClass;
-(void)createClassCompletion:(NSNotification*)notification;
@end
