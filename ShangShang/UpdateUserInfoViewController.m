//
//  UpdateUserInfoViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-22.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "UpdateUserInfoViewController.h"
#import "SSUser.h"
#import "HttpUtil.h"
#import "ImageUtil.h"
#import "CommonUtil.h"
@interface UpdateUserInfoViewController ()

@end

@implementation UpdateUserInfoViewController
//@synthesize userName = userName_;
//@synthesize password = password_;
@synthesize result = result_;

@synthesize selectedphoto = selectedphoto_;

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
    self.navigationItem.title = @"用户信息";
    
    self.textName.delegate=self;
    self.textAddress.delegate=self;
    self.textMail.delegate=self;
    self.textTel.delegate=self;
    
    SSUser *user=[SSUser getInstance];
    self.textName.text=user.nickName;
    self.textAddress.text=user.address;
    self.textMail.text=user.email;
    self.textTel.text=user.tel;
    
    self.textGrade.text=[NSString stringWithFormat:@"%@",user.grade];
    self.textScore.text=[NSString stringWithFormat:@"%@",user.score];
    self.headphoto.image=[CommonUtil achiveHeadPhoto:user.userid];

    self.labelMessage.text=@"";
}

-(void) viewWillDisappear:(BOOL)animated{
    /*
    if (flagBack) {
        int currentVCIndex = [self.navigationController.viewControllers indexOfObject:self.navigationController.topViewController];
        
        StudentMainViewController *parent = (StudentMainViewController *)[self.navigationController.viewControllers objectAtIndex:currentVCIndex];
        
        [parent reloadData];
    }else{
        flagBack=true;
    }*/
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

- (void)dealloc {
    [_textName release];
    [_textMail release];
    [_textTel release];
    [_textAddress release];
    [_labelMessage release];
    [_headphoto release];
   // self.userName=nil;
   //self.password=nil;
    [_textGrade release];
    [_textScore release];
    [super dealloc];
}
- (IBAction)setPhoto:(id)sender {
    //flagBack=false;
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

-(void)updateTask{
    self.labelMessage.text=@"";
    HttpUtil *httpUtil=[[HttpUtil alloc] init];
    
    NSString* url = @"SmurfWeb/rest/user/updateuserinfo";
    SSUser *old=[SSUser getInstance];

    SSUser *newUser=[SSUser new];
    newUser.userid=old.userid;
    newUser.nickName=self.textName.text;
    newUser.address=self.textAddress.text;
    newUser.email=self.textMail.text;
    newUser.tel=self.textTel.text;
    newUser.imgData=[[ImageUtil alloc] encodeToBase64String:self.selectedphoto];
    self.result= [httpUtil SendPostRequest:url withBody:newUser.dictionary];
    if ([self.result isEqualToString:@"0"]) {
        SSUser *user=[SSUser getInstance];
        [SSUser initWith:user.userName andPassword:user.password];
        user.needUpdateFace=@"1";
    }
}

-(void)updateComplete{
    if ([self.result isEqualToString:@"0"]) {
        self.labelMessage.text=@"更新成功";
    }else{
        self.labelMessage.text=@"更新失败";
    }
}

- (IBAction)btnUpdate:(id)sender {
    self.labelMessage.text=@"";
    [CommonUtil showWaiting:self.navigationController whileExecutingBlock:^{
		[self updateTask];
	} completionBlock:^{
        [self updateComplete];
	}];
    
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
