//
//  TeacherMainViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-29.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "TeacherIndex.h"
#import "CommonUtil.h"
#import "LoginViewController.h"

@interface TeacherIndex ()

@end

@implementation TeacherIndex

- (void)openLoginDialog {
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:SMURF_KEY_PASSWORD];
	[self presentViewWithIdentifier:@"navLogin"];
}

- (void)viewWillAppear:(BOOL)animated {
	self.navigationItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_TITLE];
	self.loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USER];

	self.labelUserName.text = [NSString stringWithFormat:@"账号：%@", [self.loginUser objectForKey:@"username"]];
	self.labelNickName.text = [self.loginUser objectForKey:@"nickName"];

	[CommonUtil showWaiting:self.navigationController whileExecutingBlock: ^{
	    self.headphoto = [CommonUtil getImage:[self.loginUser objectForKey:@"id"]];
	} completionBlock: ^{
	    self.userPhoto.image = self.headphoto;
	}];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)updateConfig {
	NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/ios/resource?userid=%@", [self.loginUser objectForKey:@"id"]];
	[[HttpUtil getInstance] GetAsynchronous:url withDelegate:self];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	//NSLog(@"get config data complete");
	//NSData *response = [request responseData];
	//NSDictionary *obj=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];

	//limitClass=[[obj objectForKey:@"classNumber"] intValue];
	//limitTopic=[[obj objectForKey:@"topicNumber"] intValue];
	//limitVote=[[obj objectForKey:@"voteNumber"] intValue];
	//NSLog(@"limit data:[class:%d],[topic:%d],[vote:%d]",limitClass,limitTopic,limitVote);
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	NSLog(@"%@", error);
}

- (IBAction)btnBack:(id)sender {
	[self openLoginDialog];
}

- (void)dealloc {
	[_userPhoto release];
	[_labelUserName release];
	[_labelNickName release];
	[super dealloc];
}

@end
