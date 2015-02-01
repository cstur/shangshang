//
//  TeacherMainViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-29.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "TeacherMainViewController.h"
#import "CommonUtil.h"
#import "LoginViewController.h"

@interface TeacherMainViewController ()

@end

@implementation TeacherMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)openLoginDialog{
    [CommonUtil clearUserNameandPassword];
    
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *newV=(LoginViewController*)[m instantiateViewControllerWithIdentifier:@"navLogin"];
    [self presentViewController:newV animated:YES completion:^{}];
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

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = TITLE_SHANGSHANG;
    SSUser *user=[SSUser getInstance];
    [self setUserInfo:user];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = TITLE_SHANGSHANG;
    [self updateConfig];
    // Do any additional setup after loading the view.
}

-(void)updateConfig{
    HttpUtil *httpUtil=[[HttpUtil alloc] init];
    NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/ios/resource?userid=%@",[SSUser getInstance].userid];
    [httpUtil GetAsynchronous:url withDelegate:self];
}


-(void)requestFinished:(ASIHTTPRequest*)request
{
    NSLog(@"get config data complete");
    NSData *response = [request responseData];
    NSDictionary *obj=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];

    limitClass=[[obj objectForKey:@"classNumber"] intValue];
    limitTopic=[[obj objectForKey:@"topicNumber"] intValue];
    limitVote=[[obj objectForKey:@"voteNumber"] intValue];
    NSLog(@"limit data:[class:%d],[topic:%d],[vote:%d]",limitClass,limitTopic,limitVote);
}

-(void)requestFailed:(ASIHTTPRequest*)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)btnBack:(id)sender {
        [self openLoginDialog];
}
- (void)dealloc {
    [_userPhoto release];
    [_labelUserName release];
    [_labelNickName release];
    [super dealloc];
}

#pragma mark - rotate

-(BOOL)shouldAutorotate{
    return NO;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    // Use this to allow upside down as well
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}
@end
