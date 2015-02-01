//
//  LoginViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-14.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SSUser.h"
@interface LoginViewController : UIViewController<MBProgressHUDDelegate,UITextFieldDelegate>{
    MBProgressHUD *HUD;
    NSString *password_;
    NSString *userName_;
}
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *userName;
@property (retain, nonatomic) IBOutlet UITextField *textUserName;
@property (retain, nonatomic) IBOutlet UITextField *textPassword;
@property (retain, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)btnLogin:(id)sender;
- (void)setBackgroundImageView:(NSString *)imageName;
- (void)loginTask;
-(void)loginComplete;
-(void)startLogin;
- (void) backgroundTap;
@property (nonatomic, assign) BOOL flagLogin;
@end
