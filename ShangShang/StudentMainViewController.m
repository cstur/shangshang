//
//  StudentMainViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-14.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "StudentMainViewController.h"
#import "LoginViewController.h"
#import "UpdateManager.h"
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



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    //CGRect frame = [self.nav frame];
    //frame.size.height = 82.0f;
    //[self.nav setFrame:frame];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCompeletion:) name:@"LoginCompletionNotification" object:nil];
    self.navigationItem.title = TITLE_SHANGSHANG;
    
    if (self.flagJumpPendingClassView) {
        [self jumpToPendClassView];
    }

}

-(void)viewDidAppear:(BOOL)animated{

}

-(void)jumpToPendClassView{
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PendingClassViewController *pendingclassView=(PendingClassViewController*)[m instantiateViewControllerWithIdentifier:@"pendingclassview"];
    self.navigationItem.title = @"返回";
    [self.navigationController pushViewController:pendingclassView animated:YES];
}

-(void)setUserInfo:(SSUser *)userInfo{
    self.labelUserName.text=[NSString stringWithFormat:@"账号：%@",userInfo.userName];
    self.labelNickName.text=userInfo.nickName;
    if ([userInfo.imgData isEqualToString:@""]) {
        UIImage *image = [UIImage imageNamed: @"default_phone.jpg"];
        [self.userPhoto setImage:image];
    }else{
    NSData *imageData = [[ImageUtil alloc] dataFromBase64EncodedString:userInfo.imgData];
    UIImage *myImage = [UIImage imageWithData:imageData];
        self.userPhoto.image=myImage;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = TITLE_SHANGSHANG;
    SSUser *user=[SSUser getInstance];
    if ([user.needUpdateFace isEqualToString:@"1"]) {
        SSUser *user=[SSUser getInstance];
        [self setUserInfo:user];
        user.needUpdateFace=@"0";
    }
    [CommonUtil restapi_RegisterDevice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    self.navigationItem.title = @"返回";
    if ([segue.identifier isEqualToString:@"UpdateUserInfo"]) {
        //UpdateUserInfoViewController *updateUserInfo=segue.destinationViewController;
        //updateUserInfo.user=self.user;
    }
    /*
    if ([segue.identifier isEqualToString:@"ShowLogin"]) {
        //LoginViewController *loginView=segue.destinationViewController;
        [self openLoginDialog];
    }*/
}

#pragma mark - rotate

-(BOOL)shouldAutorotate{
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row=[indexPath row];
    if (row==1) {
        UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PendingClassViewController *newV=(PendingClassViewController*)[m instantiateViewControllerWithIdentifier:@"navPending"];
        
        [self presentViewController:newV animated:YES completion:^{}];
    }
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

-(void)openLoginDialog{
    NSLog(@"Enter login dialog");
    UpdateManager *um=[[UpdateManager alloc] initwithType:0];
    [um updateValuebykey:@"username" value:@""];
    [um updateValuebykey:@"password" value:@""];

    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *newV=(LoginViewController*)[m instantiateViewControllerWithIdentifier:@"navLogin"];

    [self presentViewController:newV animated:YES completion:^{
        NSLog(@"complete login view");
    }];
}

- (IBAction)btnBack:(id)sender {
    [self openLoginDialog];
}
- (void)dealloc {
    //[_nav release];
    [_labelNickName release];
    [_labelUserName release];
    [_userPhoto release];
    [super dealloc];
}

/*
 -(void)loginCompeletion:(NSNotification*) notification{
 NSLog(@"enter loginCompeletion notification");
 //NSDictionary *theData=[notification userInfo];
 //SSUser* user=[SSUser getInstance];
 //self.user=user;
 //[self setUserInfo:user];
 }*/

/*
 - (void)loginTask{
 UpdateManager *um=[[UpdateManager alloc] initwithType:0];
 NSString *username=[um getObjectbykey:@"username"];
 NSString *password=[um getObjectbykey:@"password"];
 self.flagLogin=[SSUser initWith:username andPassword:password];
 }
 
 -(void)loginComplete{
 SSUser *user=[SSUser getInstance];
 UpdateManager *um=[[UpdateManager alloc] initwithType:0];
 if(self.flagLogin){
 [um updateValuebykey:@"username" value:user.userName];
 [um updateValuebykey:@"password" value:user.password];
 [self setUserInfo:user];
 }else{
 [self openLoginDialog];
 [self performSegueWithIdentifier: @"ShowLogin" sender: self];
 }
 }
 
 -(void)reloadData{
 CommonUtil* util=[[CommonUtil alloc] init];
 [util showWaiting:self.navigationController whileExecutingBlock:^{
 [self loginTask];
 } completionBlock:^{
 [self loginComplete];
 }];
 }*/

//- (IBAction)btnScan:(id)sender {
    //[self scan];
    //debug:[self testOutputUser];
//}
/*
-(void)testOutputUser{
    HttpUtil *httpUtil=[[HttpUtil alloc] init];
    NSString* url = [NSString stringWithFormat:@"%@",@"http://115.28.155.74:8080/SmurfWeb/rest/user/login?username=student1&password=student1"];
    NSData *response=[httpUtil SendGetRequest:url];
    
    NSDictionary *obj=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    NSString *nickName=[obj objectForKey:@"nickName"];
    NSString *userName=[obj objectForKey:@"username"];
    
    self.labelNickName.text=nickName;
    self.labelUserName.text=[NSString stringWithFormat:@"账号：%@",userName];
}*/
/*
-(void)scan{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentViewController:reader animated:YES completion:^{}];
    [reader release];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol;
    for(symbol in results)
        break;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:symbol.data delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}*/


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
