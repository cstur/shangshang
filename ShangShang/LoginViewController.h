//
//  LoginViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-14.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SmurfView.h"

@interface LoginViewController : SmurfView <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}
@property (retain, nonatomic) IBOutlet UITextField *textUserName;
@property (retain, nonatomic) IBOutlet UITextField *textPassword;
@property (retain, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)btnLogin:(id)sender;

- (void)loginTask;
- (void)loginComplete;
- (void)backgroundTap;
@end
