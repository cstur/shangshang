//
//  AddDetailsInfoViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "AddDetailsView.h"
#import "StudentMainViewController.h"
#import "CommonUtil.h"
@interface AddDetailsView ()

@end

@implementation AddDetailsView

@synthesize selectedphoto = selectedphoto_;
@synthesize result = result_;

- (void)viewWillAppear:(BOOL)animated {
	CGRect frame = [self.nav frame];
	frame.size.height = 82.0f;
	[self.nav setFrame:frame];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.labelNickName.delegate = self;
	self.labelAddress.delegate = self;
	self.labelEmail.delegate = self;
	self.labelTel.delegate = self;

	self.labelNickName.text = @"新用户";
}

- (void)updateTask {
	NSString *url = @"SmurfWeb/rest/user/updateuserinfo";
	NSLog(@"%@", self.labelNickName.text);
	NSMutableDictionary *newUser = [self.loginUser copy];
	[newUser setObject:self.labelNickName.text forKey:@"nickName"];
	[newUser setObject:self.labelAddress.text forKey:@"address"];
	[newUser setObject:self.labelEmail.text forKey:@"email"];
	[newUser setObject:self.labelTel.text forKey:@"telephone"];
	[newUser setObject:[[ImageUtil alloc] encodeToBase64String:self.selectedphoto] forKey:@"picture"];
	self.result = [[HttpUtil getInstance] SendPostRequest:url withBody:[newUser copy]];
	if ([self.result isEqualToString:@"0"]) {
		self.loginUser = [CommonUtil iosapi_userinfo:[[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USERNAME]
		                                    Password:[[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_PASSWORD]];
		if (self.loginUser != nil) {
			[[NSUserDefaults standardUserDefaults] setObject:self.loginUser forKey:@"smurf_user"];
		}
		//user.needUpdateFace=@"1";
	}
}

- (void)updateComplete {
	if ([self.result isEqualToString:@"-1"]) {
		[self showAlert:@"更新失败"];
	}
	else {
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

- (void)ShowRoot {
	@try {
		int role = [[self.loginUser objectForKey:@"role"] intValue];
		if (role == 2) {
			[self presentViewWithIdentifier:@"navstudent"];
		}

		if (role == 1) {
			[self presentViewWithIdentifier:@"navteacher"];
		}
	}
	@catch (NSException *ex)
	{
		[self showAlert:@"程序异常,FailCode:002"];
	}
}

- (IBAction)btnSkip:(id)sender {
	[self ShowRoot];
}

- (void)doUpdate {
	[self updateTask];
	[self updateComplete];
}

- (IBAction)btnUpdate:(id)sender {
	[self doUpdate];
	[self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setPhoto:(id)sender {
	UIActionSheet *choosePhotoActionSheet;

	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"选择头像", @"")
		                                                     delegate:self
		                                            cancelButtonTitle:NSLocalizedString(@"取消", @"")
		                                       destructiveButtonTitle:nil
		                                            otherButtonTitles:NSLocalizedString(@"拍照", @""), NSLocalizedString(@"从照片库选取", @""), nil];
	}
	else {
		choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"选择头像", @"")
		                                                     delegate:self
		                                            cancelButtonTitle:NSLocalizedString(@"取消", @"")
		                                       destructiveButtonTitle:nil
		                                            otherButtonTitles:NSLocalizedString(@"从照片库选取", @""), nil];
	}

	[choosePhotoActionSheet showInView:self.view];
	[choosePhotoActionSheet release];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSUInteger sourceType = 0;
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
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
	}
	else {
		if (buttonIndex == 1) {
			return;
		}
		else {
			sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		}
	}

	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
	imagePickerController.sourceType = sourceType;
	//[self presentModalViewController:imagePickerController animated:YES];
	[self presentViewController:imagePickerController animated:YES completion: ^{}];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	//[picker dismissModalViewControllerAnimated:YES];
	[picker dismissViewControllerAnimated:YES completion: ^{}];
	self.selectedphoto = [info objectForKey:UIImagePickerControllerEditedImage];
	self.headphoto.image = self.selectedphoto;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	//[self dismissModalViewControllerAnimated:YES];
	[self dismissViewControllerAnimated:YES completion: ^{}];
}

@end
