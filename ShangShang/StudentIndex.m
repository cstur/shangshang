//
//  StudentMainViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-14.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "StudentIndex.h"
#import "LoginViewController.h"
#import "ZBarSDK.h"
#import "HttpUtil.h"
#import "UpdateUserInfoViewController.h"
#import "ImageUtil.h"
#import "CommonUtil.h"
#import "PendingClassViewController.h"

@interface StudentIndex ()

@end

@implementation StudentIndex
@synthesize flagJumpPendingClassView;


- (void)viewWillAppear:(BOOL)animated {
	self.navigationItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_TITLE];
	if (flagJumpPendingClassView) {
		[self jumpToPendClassView];
	}

	self.loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USER];

	self.labelUserName.text = [NSString stringWithFormat:@"账号：%@", [self.loginUser objectForKey:@"username"]];
	self.labelNickName.text = [self.loginUser objectForKey:@"nickName"];

	[CommonUtil showWaiting:self.navigationController whileExecutingBlock: ^{
	    self.headphoto = [CommonUtil getImage:[self.loginUser objectForKey:@"id"]];
	} completionBlock: ^{
	    self.userPhoto.image = self.headphoto;
	}];
}

- (void)jumpToPendClassView {
	PendingClassViewController *pendingclassView = (PendingClassViewController *)[CommonUtil getView:@"pendingclassview"];
	self.navigationItem.title = @"返回";
	[self.navigationController pushViewController:pendingclassView animated:YES];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	//[CommonUtil restapi_RegisterDevice:[SSUser getInstance].deviceToken];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	self.navigationItem.title = @"返回";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	if (row == 1 && indexPath.section == 1) {
		[self jumpToPendClassView];
	}
}

- (void)openLoginDialog {
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:SMURF_KEY_PASSWORD];
	[self presentViewWithIdentifier:@"navLogin"];
}

- (IBAction)btnBack:(id)sender {
	[self openLoginDialog];
}

- (void)dealloc {
	[_labelNickName release];
	[_labelUserName release];
	[_userPhoto release];
	[super dealloc];
}

@end
