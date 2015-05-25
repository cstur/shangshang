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
@synthesize user = _user;
- (void)viewDidLoad {
	[super viewDidLoad];
    self.user=[[NSMutableDictionary alloc] init];

	[self associateTextFiedDelegate:self.textUserName];
	[self associateTextFiedDelegate:self.textPassword];
	[self associateTextFiedDelegate:self.textConfirmPassword];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	if (self.textUserName.text.length == 0 || self.textPassword.text.length == 0 || self.textConfirmPassword.text.length == 0) {
		[self showAlert:@"用户名和密码不能为空"];
		return NO;
	}

	NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/user/verifyusername?username=%@", self.textUserName.text];
	NSData *response = [[HttpUtil getInstance] SendGetRequest:url];
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

	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ShowSetQuestion"]) {
		QuestionViewController *setQuestion = segue.destinationViewController;
        [self.user setObject:self.textUserName.text forKey:@"username"];
        [self.user setObject:self.textPassword.text forKey:@"password"];
        
        NSString *role = [self.segRole titleForSegmentAtIndex:self.segRole.selectedSegmentIndex];
        if ([role isEqualToString:@"学生"]) {
            [self.user setObject:@"2" forKey:@"role"];
        }
        else {
            [self.user setObject:@"1" forKey:@"role"];
        }
        [self.user setObject:@"true" forKey:@"sex"];
        [self.user setObject:@"false" forKey:@"vip"];
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
