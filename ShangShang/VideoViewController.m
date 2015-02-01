//
//  VideoViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-30.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController
@synthesize moviePlayer = _moviePlayer;
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
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    self.manager = [AFHTTPRequestOperationManager manager];
	self.manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    //self.cellItemProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    [self loadTable];
    

}

-(void)loadTable{
    NSArray *arr= [CommonUtil restapi_GetVideoList:[SSUser getInstance].userid];
    
    NSMutableArray* mut=[NSMutableArray arrayWithCapacity:10];
    for(NSDictionary* obj in arr){
        NSString* fileType=[obj objectForKey:@"fileExtension"];

        if ([fileType isEqualToString:@"mp4"]||
            [fileType isEqualToString:@"m4v"]||
            [fileType isEqualToString:@"mov"]||
            [fileType isEqualToString:@"3gp"]) {
            [mut addObject:obj];
        }
    }
    self.listVideo=mut;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listVideo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"cellvideo";
    CellVideo *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger row=[indexPath row];
    NSDictionary *rowDict=[self.listVideo objectAtIndex:row];
    cell.labelVideoName.text=[rowDict objectForKey:@"fileName"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell.progressBar setHidden:YES];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)doUpload:(NSURL*)filePath withImg:(NSData*)tempData withType:(NSString*) type withName:(NSString*)fileName{
    //NSString *fileName = [filePath lastPathComponent];
    if (fileName==nil) {
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm:ss"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
        NSLog(@"newDateString %@", newDateString);
        [outputFormatter release];
        fileName=@"takefromphoto";
    }
    NSString *postURL=[NSString stringWithFormat:@"http://%@/SmurfWeb/View/UploadServlet",[ServerIP getConfigIP]];
	NSDictionary *parameters = @{@"userid": [SSUser getInstance].userid,@"filetype":type,@"flag":@"teacher",@"filename":fileName};
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:postURL
                                    parameters:parameters
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         NSData *videoData = [NSData dataWithContentsOfURL:filePath];
                         [formData appendPartWithFileData:videoData
                                                     name:@"file"
                                                 fileName:fileName
                                                 mimeType:@"video/*"];
                     }];
    
    AFHTTPRequestOperation *operation =
    [self.manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         [self loadTable];
                                         [self ShowAlert:@"上传成功"];
                                         NSLog(@"Success %@", responseObject);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [self ShowAlert:@"上传失败"];
                                         NSLog(@"Failure %@", error.description);
                                     }];
    
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
        //self.cellItemProgress.progress=(double)totalBytesWritten /  (double)totalBytesExpectedToWrite;
    }];
    
    [operation start];
}

-(void) ShowAlert:(NSString*)Msg{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:Msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
	NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            default:
                return;
        }
    } else {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                break;
            default:
                return;
        }
    }
    
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

- (void)dealloc
{
    [_moviePlayer release];
        [_tableView release];
    [super dealloc];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	
	if([mediaType isEqualToString:@"public.movie"])
	{
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
        
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        [self getPreViewImg:url];
        
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
        [m setObject:fileName forKey:@"fileName"];
        
        [self.listVideo addObject:m];
        [self.tableView reloadData];
        [self doUpload:url withImg:videoData withType:@"video" withName:fileName];
	}
	else
	{
        [self ShowAlert:@"选中的不是视频"];
		NSLog(@"Error media type");
		return;
	}
}

-(void)getPreViewImg:(NSURL *)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    //self.preViewImg.image=img;
    [img release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)uploadClick:(id)sender {
    UIActionSheet *choosePhotoActionSheet;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"选择附件", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"拍照", @""), NSLocalizedString(@"从照片库选择", @""),nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"选择附件", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"从照片库选择", @""),nil];
    }
    
    [choosePhotoActionSheet showInView:self.view];
    [choosePhotoActionSheet release];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row=[indexPath row];
    NSDictionary *dict=[self.listVideo objectAtIndex:row];
    NSString *fileName=[dict objectForKey:@"filePath"];
    NSString *urlStr=[NSString stringWithFormat:@"http://%@/SmurfWeb/users/%@/video/%@",[ServerIP getConfigIP],[SSUser getInstance].userid,fileName];
    NSLog(@"%@",urlStr);
    NSString *videoPath= [CommonUtil downloadVideo:urlStr withFileName:fileName];
    if (![videoPath isEqualToString:@""]) {
        self.moviePlayer = [[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPath]] autorelease];
        self.moviePlayer.view.frame = self.view.bounds;
        [self.view addSubview:self.moviePlayer.view];
        self.moviePlayer.fullscreen = YES;
        self.moviePlayer.scalingMode = MPMovieScalingModeFill;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.moviePlayer];
        [self.moviePlayer play];
    }
}

-(void)movieFinishedCallback:(NSNotification*)notify {
    MPMoviePlayerController* theMovie = [notify object];
    
    [[NSNotificationCenter
      defaultCenter] removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:theMovie];
    
    [theMovie.view removeFromSuperview];
    [theMovie release];
}
@end
