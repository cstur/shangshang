//
//  userinfo.m
//  ShangShang
//
//  Created by 史东杰 on 14-11-6.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "userinfo.h"

@interface userinfo ()

@end

@implementation userinfo

- (void)viewWillAppear:(BOOL)animated {
	self.navigationItem.title = @"个人信息";

	//self.navigationItem.titleView=[SmurfUI SmurfIndicator];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self updateUI];
	//self.manager = [AFHTTPRequestOperationManager manager];
	//self.manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadSuccess) name:@"uploadcomplete" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFail) name:@"uploadfail" object:nil];
}

- (void)updateUI {
	NSString *noteset = @"未设置";
	self.loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USER];
	self.lnickName.text = [self.loginUser objectForKey:@"nickName"];
	self.lAddress.text = [[self.loginUser objectForKey:@"address"] isEqualToString:@""] ? noteset : [self.loginUser objectForKey:@"address"];
	self.lmail.text = [[self.loginUser objectForKey:@"email"] isEqualToString:@""] ? noteset : [self.loginUser objectForKey:@"email"];
	self.lTelephoneNumber.text = [[self.loginUser objectForKey:@"telephone"] isEqualToString:@""] ? noteset : [self.loginUser objectForKey:@"telephone"];
	self.lSign.text = [[self.loginUser objectForKey:@"signature"] isEqualToString:@""] ? noteset : [self.loginUser objectForKey:@"signature"];
	self.lAccount.text = [self.loginUser objectForKey:@"username"];
	self.lgrade.text = [NSString stringWithFormat:@"%@", [self.loginUser objectForKey:@"grade"]];
	self.lIntegral.text = [NSString stringWithFormat:@"%@", [self.loginUser objectForKey:@"score"]];
	self.headphoto.image = [CommonUtil achiveHeadPhoto:[self.loginUser objectForKey:@"id"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0 && indexPath.section == 0) {
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
}

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
	[self presentViewController:imagePickerController animated:YES completion: ^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion: ^{}];
	self.selectedphoto = [info objectForKey:UIImagePickerControllerEditedImage];
	self.headphoto.image = self.selectedphoto;

	NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
	NSURL *resourceURL = [info objectForKey:UIImagePickerControllerReferenceURL];

	__block NSString *fileName = nil;

	dispatch_semaphore_t sema = dispatch_semaphore_create(0);
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

	ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
	{
		ALAssetRepresentation *representation = [myasset defaultRepresentation];
		fileName = [representation filename];
		NSLog(@"fileName : %@", fileName);
		dispatch_semaphore_signal(sema);
	};

	ALAssetsLibrary *assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];

	dispatch_async(queue, ^{
		[assetslibrary assetForURL:resourceURL
		               resultBlock:resultblock
		              failureBlock: ^(NSError *error) {
		    dispatch_semaphore_signal(sema);
		}];
	});

	dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
	dispatch_release(sema);


	if (fileName == nil) {
		NSDate *now = [NSDate date];
		NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
		[outputFormatter setDateFormat:@"HH:mm:ss"];
		NSString *newDateString = [outputFormatter stringFromDate:now];
		fileName = [NSString stringWithFormat:@"%@.JPE", newDateString];
	}
	NSData *imgData = UIImageJPEGRepresentation(self.selectedphoto, 0.1f);
	SPostData *postData = [[SPostData alloc] init];
	postData.filePath = url;
	postData.data = imgData;
	postData.type = @"img";
	postData.fileName = fileName;
	postData.flag = @"headphoto";
	[CommonUtil doUpload:postData withProgressInView:self];
}

- (void)uploadSuccess {
	NSString *imgPath = [NSString stringWithFormat:@"/Documents/%@.png", [self.loginUser objectForKey:@"id"]];
	[CommonUtil saveImage:self.selectedphoto withPath:imgPath];
	NSLog(@"上传成功");
}

- (void)uploadFail {
	NSLog(@"上传失败");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion: ^{}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	UpdateInfo *updateView = segue.destinationViewController;

	if ([segue.identifier isEqualToString:@"updateNickName"]) {
		updateView.attribute = @"nickname";
		updateView.value = [self.loginUser objectForKey:@"nickName"];
	}

	if ([segue.identifier isEqualToString:@"updateEmail"]) {
		updateView.attribute = @"email";
		updateView.value = [self.loginUser objectForKey:@"email"];
	}

	if ([segue.identifier isEqualToString:@"updateTelephone"]) {
		updateView.attribute = @"telephone";
		updateView.value = [self.loginUser objectForKey:@"telephone"];
	}

	if ([segue.identifier isEqualToString:@"updateAddress"]) {
		updateView.attribute = @"address";
		updateView.value = [self.loginUser objectForKey:@"address"];
	}

	if ([segue.identifier isEqualToString:@"updateSignature"]) {
		updateView.attribute = @"signature";
		updateView.value = [self.loginUser objectForKey:@"signature"];
	}
}

- (void)dealloc {
	[_headphoto release];
	[_lnickName release];
	[_lAccount release];
	[_lgrade release];
	[_lIntegral release];
	[_lmail release];
	[_lTelephoneNumber release];
	[_lAddress release];
	[_lSign release];
	[super dealloc];
}

@end
