//
//  StudentMainViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-14.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "StudentMainViewController.h"
#import "LoginViewController.h"
#import "ZBarSDK.h"
#import "HttpUtil.h"
#import "SSUser.h"
#import "UpdateUserInfoViewController.h"
#import "ImageUtil.h"
#import "CommonUtil.h"
#import "PendingClassViewController.h"

@interface StudentMainViewController ()

@end

@implementation StudentMainViewController
@synthesize flagLogin;
@synthesize flagJumpPendingClassView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = TITLE_SHANGSHANG;
    if (flagJumpPendingClassView) {
        [self jumpToPendClassView];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    SSUser *user=[SSUser getInstance];
    [self setUserInfo:user];
}

-(void)jumpToPendClassView{
    PendingClassViewController *pendingclassView=(PendingClassViewController*)[CommonUtil getView:@"pendingclassview"];
    self.navigationItem.title = @"返回";
    [self.navigationController pushViewController:pendingclassView animated:YES];
}

-(void)setUserInfo:(SSUser *)userInfo{
    self.labelUserName.text=[NSString stringWithFormat:@"账号：%@",userInfo.userName];
    self.labelNickName.text=userInfo.nickName;

    [CommonUtil showWaiting:self.navigationController whileExecutingBlock:^{
        [self getPhoto];
    } completionBlock:^{
        [self setPhoto];
    }];
}

-(void)getPhoto{
     self.headphoto=[CommonUtil getImage:[SSUser getInstance].userid];
}

-(void)setPhoto{
    self.userPhoto.image=self.headphoto;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CommonUtil restapi_RegisterDevice:[SSUser getInstance].deviceToken];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    self.navigationItem.title = @"返回";
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row=[indexPath row];
    if (row==1&&indexPath.section==1) {
        [self jumpToPendClassView];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

-(void)openLoginDialog{
    [CommonUtil clearUserNameandPassword];
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *newV=(LoginViewController*)[m instantiateViewControllerWithIdentifier:@"navLogin"];

    [self presentViewController:newV animated:YES completion:^{}];
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
