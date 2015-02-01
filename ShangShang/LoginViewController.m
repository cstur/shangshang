//
//  LoginViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-14.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "LoginViewController.h"
#import "HttpUtil.h"
#import "SSUser.h"
#import "CommonUtil.h"
#import "StudentMainViewController.h"
#import "TeacherMainViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userName = userName_;
@synthesize password = password_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TITLE_SHANGSHANG=[CommonUtil iosapi_logotext];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)];
    [self.view addGestureRecognizer:gestureRecognizer];
    [self setBackgroundImageView:@"上商APP-bj.png"];
    self.textUserName.delegate=self;
    self.textPassword.delegate=self;
    
    DBManager *dbManager=[[DBManager alloc] init];
    self.userName=[dbManager getDictValue:@"username"];
    self.password=[dbManager getDictValue:@"password"];
    
    if (![self.userName isEqualToString:@""]&&![self.password isEqualToString:@""]) {
        self.textUserName.text=self.userName;
        self.textPassword.text=self.password;
    }else{
        self.textPassword.text=@"";
    }
}

- (void) backgroundTap
{
    [self.textUserName resignFirstResponder];
    [self.textPassword resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.userName=nil;
    self.password=nil;
    [_textUserName release];
    [_textPassword release];
    [_btnLogin release];
    [super dealloc];
}

- (void)setBackgroundImageView:(NSString *)imageName
{
    int kBackgroundViewTag = 1024768;
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView* bgview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgview.tag = kBackgroundViewTag;
    [bgview setImage:[UIImage imageNamed:imageName]];
    UIView* oldView = [self.view viewWithTag:kBackgroundViewTag];
    [oldView removeFromSuperview];
    [self.view addSubview:bgview];
    [self.view sendSubviewToBack:bgview];
    [bgview release];
}

- (void)loginTask{
    @try
    {
        self.flagLogin=[SSUser initWith:self.userName andPassword:self.password];
    }
    @catch(NSException* ex)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"登陆失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)startLogin{
    [CommonUtil showWaiting:self.navigationController whileExecutingBlock:^{
		[self loginTask];
	} completionBlock:^{
        [self loginComplete];
	}];
}

-(void)loginComplete{
    if(self.flagLogin){
        @try
        {
            SSUser *user=[SSUser getInstance];
            int role=[user.role intValue];
            if (role==2) {
                UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *newV=(UINavigationController*)[m instantiateViewControllerWithIdentifier:@"navstudent"];
                
                [self presentViewController:newV animated:YES completion:nil];
            }
            
            if (role==1) {
                UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *newV=(UINavigationController*)[m instantiateViewControllerWithIdentifier:@"navteacher"];
                [self presentViewController:newV animated:YES completion:nil];
            }
        }
        @catch(NSException* ex)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"登陆失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"登陆失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)btnLogin:(id)sender {
    if (self.textUserName.text.length==0||self.textPassword.text.length==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"用户名和密码不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        self.userName=self.textUserName.text;
        self.password=self.textPassword.text;
        [self startLogin];
    }
}
@end
