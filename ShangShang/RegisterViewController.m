//
//  RegisterViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "RegisterViewController.h"
#import "SSUser.h"
#import "QuestionViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textUserName.delegate=self;
    self.textPassword.delegate=self;
    self.textConfirmPassword.delegate=self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    self.user=[[SSUser alloc] init];
    if (self.textUserName.text.length==0||self.textPassword.text.length==0||self.textConfirmPassword.text.length==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"用户名和密码不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    HttpUtil *httpUtil=[[HttpUtil alloc] init];
    
    NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/user/verifyusername?username=%@",self.textUserName.text];
    NSData *response=[httpUtil SendGetRequest:url];
    NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    int usercount = [newStr intValue];
    if (usercount>0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"用户名已存在" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if (![self.textPassword.text isEqualToString:self.textConfirmPassword.text]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"两次输入密码不一致" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    self.user.userName=self.textUserName.text;
    self.user.password=self.textPassword.text;

    NSString* role=[self.segRole titleForSegmentAtIndex:self.segRole.selectedSegmentIndex];
    if ([role isEqualToString:@"学生"]) {
        self.user.role=@"2";
    }else{
        self.user.role=@"1";
    }
    self.user.sex=@"true";
    self.user.vip=@"false";
    return  YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowSetQuestion"]) {
        QuestionViewController *setQuestion=segue.destinationViewController;
        setQuestion.user=self.user;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_textUserName release];
    [_textPassword release];
    [_textConfirmPassword release];
    [_segRole release];
    [super dealloc];
}
- (IBAction)btnRegister:(id)sender {
}
@end
