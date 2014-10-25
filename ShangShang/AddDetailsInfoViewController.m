//
//  AddDetailsInfoViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "AddDetailsInfoViewController.h"
#import "SSUser.h"
#import "StudentMainViewController.h"
#import "CommonUtil.h"
@interface AddDetailsInfoViewController ()

@end

@implementation AddDetailsInfoViewController

@synthesize selectedphoto = selectedphoto_;
@synthesize result = result_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    CGRect frame = [self.nav frame];
    frame.size.height = 82.0f;
    [self.nav setFrame:frame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.labelNickName.delegate=self;
    self.labelAddress.delegate=self;
    self.labelEmail.delegate=self;
    self.labelTel.delegate=self;
    
    SSUser *user=[SSUser getInstance];
    self.labelNickName.text=user.nickName;
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

-(void)updateTask{
    HttpUtil *httpUtil=[[HttpUtil alloc] init];
    
    NSString* url = @"SmurfWeb/rest/user/updateuserinfo";
    NSLog(@"%@",self.labelNickName.text);
    SSUser *old=[SSUser getInstance];
    SSUser *newUser=[SSUser new];
    newUser.userid=old.userid;
    newUser.nickName=self.labelNickName.text;
    newUser.address=self.labelAddress.text;
    newUser.email=self.labelEmail.text;
    newUser.tel=self.labelTel.text;
    newUser.imgData=[[ImageUtil alloc] encodeToBase64String:self.selectedphoto];
    self.result= [httpUtil SendPostRequest:url withBody:newUser.dictionary];
    if ([self.result isEqualToString:@"0"]) {
        SSUser *user=[SSUser getInstance];
        [SSUser initWith:user.userName andPassword:user.password];
        user.needUpdateFace=@"1";
    }
}

-(void)updateComplete{
    if ([self.result isEqualToString:@"-1"]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"更新失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self ShowRoot];
    }
}

- (void)dealloc {
    [_nav release];
    [_labelNickName release];
    [_labelEmail release];
    [_labelTel release];
    [_labelAddress release];
    [_headphoto release];
    [super dealloc];
}

-(void)ShowRoot{
    @try
    {
        SSUser *user=[SSUser getInstance];
        int role=[user.role intValue];
        if (role==2) {
            UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *newV=(UINavigationController*)[m instantiateViewControllerWithIdentifier:@"navstudent"];
            [self presentViewController:newV
                               animated:YES
                             completion:nil];
        }
        
        if (role==1) {
            UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *newV=(UINavigationController*)[m instantiateViewControllerWithIdentifier:@"navteacher"];
            [self presentViewController:newV
                               animated:YES
                             completion:nil];
        }
    }
    @catch(NSException* ex)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"出错了" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)btnSkip:(id)sender {
    SSUser *user=[SSUser getInstance];
     user.needUpdateFace=@"1";
    [self ShowRoot];
}

-(void)doUpdate{
    [self updateTask];
    [self updateComplete];
}
- (IBAction)btnUpdate:(id)sender {
    [self doUpdate];
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)setPhoto:(id)sender {
    UIActionSheet *choosePhotoActionSheet;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"选择头像", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"拍照", @""), NSLocalizedString(@"从照片库选取", @""), nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"选择头像", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"从照片库选取", @""), nil];
    }
    
    [choosePhotoActionSheet showInView:self.view];
    [choosePhotoActionSheet release];
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
	//[self presentModalViewController:imagePickerController animated:YES];
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:^{}];
	self.selectedphoto = [info objectForKey:UIImagePickerControllerEditedImage];
	self.headphoto.image=self.selectedphoto;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
