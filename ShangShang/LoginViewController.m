//
//  LoginViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-14.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "LoginViewController.h"
#import "HttpUtil.h"
#import "CommonUtil.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
	[[NSUserDefaults standardUserDefaults] setObject:[CommonUtil iosapi_logotext] forKey:SMURF_KEY_TITLE];
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)];
	[self.view addGestureRecognizer:gestureRecognizer];
	[self setBackgroundImageView:@"上商APP-bj.png"];
	[self associateTextFiedDelegate:self.textUserName];
	[self associateTextFiedDelegate:self.textPassword];
	self.textUserName.text = [self stringForKey:SMURF_KEY_USERNAME];
	self.textPassword.text = [self stringForKey:SMURF_KEY_PASSWORD];
	[super viewDidLoad];
}

- (void)backgroundTap {
	[self.currentTextField resignFirstResponder];
}

- (void)dealloc {
	[_textUserName release];
	[_textPassword release];
	[_btnLogin release];
	[super dealloc];
}

- (void)setBackgroundImageView:(NSString *)imageName {
	int kBackgroundViewTag = 1024768;
	self.view.backgroundColor = [UIColor clearColor];
	UIImageView *bgview = [[UIImageView alloc] initWithFrame:self.view.bounds];
	bgview.tag = kBackgroundViewTag;
	[bgview setImage:[UIImage imageNamed:imageName]];
	UIView *oldView = [self.view viewWithTag:kBackgroundViewTag];
	[oldView removeFromSuperview];
	[self.view addSubview:bgview];
	[self.view sendSubviewToBack:bgview];
	[bgview release];
}

- (void)loginTask {
	@try {
		self.loginUser = [CommonUtil iosapi_userinfo:self.textUserName.text Password:self.textPassword.text];
		if (self.loginUser != nil) {
			[[NSUserDefaults standardUserDefaults] setObject:self.loginUser forKey:@"smurf_user"];
		}
	}
	@catch (NSException *ex)
	{
		[self showAlert:@"登陆失败"];
	}
}

- (void)loginComplete {
	if (self.loginUser != nil) {
		@try {
			int role = [[self.loginUser objectForKey:@"role"] intValue];
			if (role == 2) {
				[self presentViewWithIdentifier:@"navstudent"];
			}

			if (role == 1) {
				[self presentViewWithIdentifier:@"navteacher"];
			}

			[[NSUserDefaults standardUserDefaults] setObject:self.textUserName.text forKey:SMURF_KEY_USERNAME];
			[[NSUserDefaults standardUserDefaults] setObject:self.textPassword.text forKey:SMURF_KEY_PASSWORD];
		}
		@catch (NSException *ex)
		{
			[self showAlert:@"程序异常,FailCode:001"];
		}
	}
	else {
		[self showAlert:@"登陆失败"];
	}
}

- (IBAction)btnLogin:(id)sender {
	if (self.textUserName.text.length == 0 || self.textPassword.text.length == 0) {
		[self showAlert:@"用户名或密码不能为空"];
	}
	else {
		[CommonUtil showWaiting:self.navigationController whileExecutingBlock: ^{
		    [self loginTask];
		} completionBlock: ^{
		    [self loginComplete];
		}];
	}
}

@end
