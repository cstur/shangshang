//
//  RegisterViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpUtil.h"
#import "SmurfView.h"
#import "SSUser.h"
@interface RegisterViewController : SmurfView
@property (retain, nonatomic) IBOutlet UITextField *textUserName;
@property (retain, nonatomic) IBOutlet UITextField *textPassword;
@property (retain, nonatomic) IBOutlet UITextField *textConfirmPassword;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segRole;
@property (nonatomic, assign) SSUser *user;

@end
