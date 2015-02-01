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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = @"个人信息";
    DBManager *dbManager=[DBManager getInstance];
    NSString *userName=[dbManager getUserName];
    NSString *password=[dbManager getPassword];

    self.navigationItem.titleView=[SmurfUI SmurfIndicator];
    
    //[SSUser initWith:userName andPassword:password];
    //[self updateUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.manager = [AFHTTPRequestOperationManager manager];
    //self.manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadSuccess) name:@"uploadcomplete" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFail) name:@"uploadfail" object:nil];
}

-(void)updateUI{
    NSString* noteset=@"未设置";
    SSUser *user=[SSUser getInstance];
    self.lnickName.text=user.nickName;
    self.lAddress.text=[user.address isEqualToString:@""]?noteset:user.address;
    self.lmail.text=[user.email isEqualToString:@""]?noteset:user.email;
    self.lTelephoneNumber.text=[user.tel isEqualToString:@""]?noteset:user.tel;
    self.lSign.text=[user.signature isEqualToString:@""]?noteset:user.signature;
    self.lAccount.text=user.userName;
    self.lgrade.text=[NSString stringWithFormat:@"%@",user.grade];
    self.lIntegral.text=[NSString stringWithFormat:@"%@",user.score];
    self.headphoto.image=[CommonUtil getImage:user.userid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0&&indexPath.section==0) {
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
}


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
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    self.selectedphoto = [info objectForKey:UIImagePickerControllerEditedImage];
    self.headphoto.image=self.selectedphoto;
    
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    NSURL *resourceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    __block NSString *fileName = nil;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        fileName = [representation filename];
        NSLog(@"fileName : %@",fileName);
        dispatch_semaphore_signal(sema);
    };
    
    ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
    
    dispatch_async(queue, ^{
        [assetslibrary assetForURL:resourceURL
                       resultBlock:resultblock
                      failureBlock:^(NSError *error) {
                          dispatch_semaphore_signal(sema);
                      }];
        
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_release(sema);
    
    
    if (fileName==nil) {
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm:ss"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
        fileName=[NSString stringWithFormat:@"%@.JPE",newDateString];
    }
    NSData *imgData=UIImageJPEGRepresentation(self.selectedphoto, 0.1f);
    SPostData *postData=[[SPostData alloc] init];
    postData.filePath=url;
    postData.data=imgData;
    postData.type=@"img";
    postData.fileName=fileName;
    postData.flag=@"headphoto";
    [CommonUtil doUpload:postData withProgressInView:self];
}

-(void) uploadSuccess{
    
    NSString* imgPath=[NSString stringWithFormat:@"/Documents/%@.png",[SSUser getInstance].userid];
    [CommonUtil saveImage:self.selectedphoto withPath:imgPath];
    NSLog(@"上传成功");
}

-(void) uploadFail{
    NSLog(@"上传失败");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UpdateInfo *updateView=segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"updateNickName"]) {
        updateView.attribute=@"nickname";
        updateView.value=[SSUser getInstance].nickName;
    }
    
    if ([segue.identifier isEqualToString:@"updateEmail"]) {
        updateView.attribute=@"email";
        updateView.value=[SSUser getInstance].email;
    }
    
    if ([segue.identifier isEqualToString:@"updateTelephone"]) {
        updateView.attribute=@"telephone";
        updateView.value=[SSUser getInstance].tel;
    }
    
    if ([segue.identifier isEqualToString:@"updateAddress"]) {
        updateView.attribute=@"address";
        updateView.value=[SSUser getInstance].address;
    }
    
    if ([segue.identifier isEqualToString:@"updateSignature"]) {
        updateView.attribute=@"signature";
        updateView.value=[SSUser getInstance].signature;
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
