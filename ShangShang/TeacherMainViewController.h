//
//  TeacherMainViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-29.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
@interface TeacherMainViewController : UITableViewController
- (IBAction)btnBack:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *userPhoto;
@property (retain, nonatomic) IBOutlet UILabel *labelUserName;
@property (retain, nonatomic) IBOutlet UILabel *labelNickName;
- (void)openLoginDialog;
-(void)setUserInfo:(SSUser *)userInfo;
@end
