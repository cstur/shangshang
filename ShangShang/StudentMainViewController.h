//
//  StudentMainViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-14.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "SSUser.h"
@interface StudentMainViewController : UITableViewController{
}


- (void)openLoginDialog;
- (IBAction)btnBack:(id)sender;

-(void)setUserInfo:(SSUser*)userInfo;
@property (retain, nonatomic) IBOutlet UILabel *labelNickName;
@property (retain, nonatomic) IBOutlet UILabel *labelUserName;

@property (retain, nonatomic) IBOutlet UIImageView *userPhoto;
@property (nonatomic, assign) BOOL flagLogin;
@property (nonatomic, assign) BOOL flagJumpPendingClassView;
-(void)jumpToPendClassView;
@end
