//
//  Pictures.m
//  ShangShang
//
//  Created by 史东杰 on 14-11-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "Pictures.h"


@interface Pictures ()

@end

@implementation Pictures
@synthesize selectedMediaID;
@synthesize isOpen,selectIndex;
@synthesize subVc=_subVc;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isOpen = NO;
    self.listImages= [CommonUtil restapi_GetMediaList:[SSUser getInstance].userid];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImageCompletion:) name:@"deletecomplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadCompletion:) name:@"uploadcomplete" object:nil];
}

-(void)deleteImageCompletion:(NSNotification*)notification{
    NSLog(@"delete success");
    //[self refreshTable];
}

-(void)uploadCompletion:(NSNotification*)notification{
    NSLog(@"upload success");
    int attachid = [[[notification userInfo] valueForKey:@"attachid"] intValue];
    if (attachid>0) {
         [self uploadSuccess:attachid];
    }else{NSLog(@"attah id not correct");}

}

-(void)refreshTable{
    self.listImages= [CommonUtil restapi_GetMediaList:[SSUser getInstance].userid];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UIFolderTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellPicture *cell = (CellPicture *)[tableView cellForRowAtIndexPath:indexPath];
    [cell changeArrowWithUp:YES];
    SubCateViewController *subVc = [[SubCateViewController alloc]
                                    initWithNibName:NSStringFromClass([SubCateViewController class])
                                    bundle:nil];
    NSInteger row=[indexPath row];
    NSDictionary *rowDict=[self.listImages objectAtIndex:row];
    NSString *mediaID=[rowDict objectForKey:@"id"];
    subVc.mediaID=mediaID;

    tableView.scrollEnabled = NO;
    [tableView openFolderAtIndexPath:indexPath WithContentView:subVc.view
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
  
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                }
                           completionBlock:^{
                               self.tableView.scrollEnabled = YES;
                               [cell changeArrowWithUp:NO];
                           }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listImages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"cellpicture";
    CellPicture *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger row=[indexPath row];
    NSDictionary *rowDict=[self.listImages objectAtIndex:row];
    cell.labelName.text=[rowDict objectForKey:@"fileName"];
    NSDictionary *timeObj=[rowDict objectForKey:@"startTime"];
    long long lTime= [[timeObj objectForKey:@"time"] longLongValue];
    NSDate *datefield=[CommonUtil dateFromMillis:lTime];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/mm/dd hh:mm:ss"];
    
    NSString *time = [dateFormatter stringFromDate:datefield];
    cell.labelDate.text=time;
    
    cell.imageSmall.image=[CommonUtil getMedia:[rowDict objectForKey:@"id"]];
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
    return cell;
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
    postData.flag=@"teacher";
    @try {
        self.selectedMediaID=[CommonUtil doUpload:postData withProgressInView:self];
    }
    @catch (NSException *exception) {
        NSLog(@"upload fail");
        NSLog(@"%@",exception);
    }
}

-(void) uploadSuccess:(int)attachid{
    @try {
        NSString* imgPath=[NSString stringWithFormat:@"/Documents/%d.png",attachid];
        [CommonUtil saveImage:self.selectedphoto withPath:imgPath];
        /*
        self.listImages= [CommonUtil restapi_GetMediaList:[SSUser getInstance].userid];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        */
        [CommonUtil ShowAlert:@"上传成功" withDelegate:self];
        NSLog(@"上传成功");
    }
    @catch (NSException *exception) {
       [CommonUtil ShowAlert:@"上传失败" withDelegate:self];
    }
}

-(void) uploadFail{
    NSLog(@"上传失败");
}

- (void)dealloc {
    [_upload release];
    [super dealloc];
}
- (IBAction)btnUpload:(id)sender {
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
@end
