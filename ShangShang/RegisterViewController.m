//
//  RegisterViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "RegisterViewController.h"
#import "QuestionViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self associateTextFiedDelegate:self.textUserName];
	[self associateTextFiedDelegate:self.textPassword];
	[self associateTextFiedDelegate:self.textConfirmPassword];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	self.user = [[SSUser alloc] init];
	if (self.textUserName.text.length == 0 || self.textPassword.text.length == 0 || self.textConfirmPassword.text.length == 0) {
		[self showAlert:@"用户名和密码不能为空"];
		return NO;
	}

	HttpUtil *httpUtil = [[HttpUtil alloc] init];

	NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/user/verifyusername?username=%@", self.textUserName.text];
	NSData *response = [httpUtil SendGetRequest:url];
	NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	int usercount = [newStr intValue];
	if (usercount > 0) {
		[self showAlert:@"用户名已存在"];
		return NO;
	}

	if (![self.textPassword.text isEqualToString:self.textConfirmPassword.text]) {
		[self showAlert:@"两次输入密码不一致"];
		return NO;
	}

	self.user.userName = self.textUserName.text;
	self.user.password = self.textPassword.text;

	NSString *role = [self.segRole titleForSegmentAtIndex:self.segRole.selectedSegmentIndex];
	if ([role isEqualToString:@"学生"]) {
		self.user.role = @"2";
	}
	else {
		self.user.role = @"1";
	}
	self.user.sex = @"true";
	self.user.vip = @"false";
	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ShowSetQuestion"]) {
		QuestionViewController *setQuestion = segue.destinationViewController;
		setQuestion.user = self.user;
	}
}

- (void)dealloc {
	[_textUserName release];
	[_textPassword release];
	[_textConfirmPassword release];
	[_segRole release];
	[super dealloc];
}

@end
