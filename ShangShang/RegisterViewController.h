//
//  RegisterViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSUser.h"
#import "HttpUtil.h"
@interface RegisterViewController : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *textUserName;
@property (retain, nonatomic) IBOutlet UITextField *textPassword;
@property (retain, nonatomic) IBOutlet UITextField *textConfirmPassword;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segRole;
@property (nonatomic,assign)SSUser *user;
- (IBAction)btnRegister:(id)sender;

@end
