//
//  CreateVoteViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-11.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "CreateVoteViewController.h"
#import "ASIFormDataRequest.h"
@interface CreateVoteViewController ()
{
    NSString* attachid;
}
@end

@implementation CreateVoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=@"创建投票";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Enter create vote view.");
    self.navigationItem.rightBarButtonItem =  self.editButtonItem;
    attachid=@"";
    
    //设置单元格文本框
    self.txtField.hidden = YES;
    self.txtField.delegate = self;
    self.textTitle.delegate= self;
    
    //分配当前视图控制器给表视图的委托和数据源
    self.tableOption.delegate = self;
    self.tableOption.dataSource = self;
    
	self.listOption = [[NSMutableArray alloc] initWithObjects:@"签到", nil];
    
    //self.manager = [AFHTTPRequestOperationManager manager];
	//self.manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadCompletion:) name:@"uploadcomplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFail:) name:@"uploadfail" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listOption count] + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (currentCell.accessoryType == UITableViewCellAccessoryNone)
    {
        currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else{
        currentCell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BOOL b_addCell = (indexPath.row == self.listOption.count);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier] ;
    }
    
    if (!b_addCell) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.text = [self.listOption objectAtIndex:indexPath.row];
    } else {
        self.txtField.frame = CGRectMake(10,0,300,44);
        self.txtField.text = @"";
        [cell.contentView addSubview:self.txtField];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.listOption removeObjectAtIndex: indexPath.row];
        [self.tableOption deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                withRowAnimation:UITableViewRowAnimationFade];
        [self.tableOption reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        if (![self.txtField.text isEqualToString:@""]) {
            [self.listOption insertObject:self.txtField.text atIndex:[self.listOption count]];
            [self.tableOption insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                    withRowAnimation:UITableViewRowAnimationFade];
            [self.tableOption reloadData];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"选项内容不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    UIButton *btnCreateVote=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCreateVote setTitle:@"确认" forState:UIControlStateNormal];
    [btnCreateVote addTarget:self action:@selector(createVote) forControlEvents:UIControlEventTouchUpInside];
    btnCreateVote.frame=CGRectMake(0, 0, 280, 30);
    UIColor *currentColor=[UIColor colorWithRed:255/255.f
                                          green:190/255.f
                                           blue:56/255.f
                                          alpha:255/255.f];
    [btnCreateVote setBackgroundColor:currentColor];
    
    [footerView addSubview:btnCreateVote];
    return footerView;
}

-(void)createVoteTask{
    SSVote *vote=[SSVote alloc];
    vote.title=self.textTitle.text;
    vote.classid=[self.sClass objectForKey:@"id"];
    
    NSMutableArray *optionTemp=[[NSMutableArray alloc] init];
    for (int i = 0; i < [self.listOption count]; i++) {
        id myArrayElement = [self.listOption objectAtIndex:i];
        SSVoteOption *op=[SSVoteOption alloc];
        op.optionId=@"0";
        op.optionContent=myArrayElement;
        op.polledCount=@"0";
        op.voteId=@"0";
        NSIndexPath *cellPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *row=[self.tableOption cellForRowAtIndexPath:cellPath];
        if (row.accessoryType==UITableViewCellAccessoryCheckmark) {
            op.isAnswer=@"true";
        }else{
            op.isAnswer=@"false";
        }
        [optionTemp addObject:op.dictionary];
    }
    NSArray *body = [optionTemp copy];
    vote.options=body;
    
    if ([attachid isEqualToString:@""]) {
        [CommonUtil restapi_CreateVote:vote.dictionary];
    }else{
        vote.attachids=attachid;
        [CommonUtil restapi_CreateVote:vote.dictionarywithAttach];
    }
}
-(void)createComplete{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateVoteCompletion" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createVote
{
    //HttpUtil *util= [HttpUtil alloc];
    //[util simpleJsonParsingPostMetod:self.attachPhoto];
    
    if (self.textTitle.text.length==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"主题不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    [CommonUtil showWaiting:self.navigationController whileExecutingBlock:^{
		[self createVoteTask];
	} completionBlock:^{
        [self createComplete];
	}];
    
    
}

#pragma mark --UITableViewDelegate 协议方法

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.listOption count]) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.listOption count]) {
        return NO;
    } else {
        return YES;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark -- UIViewController生命周期方法，用于响应视图编辑状态变化
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    [self.tableOption setEditing:editing animated:YES];
    if (editing) {
        self.txtField.hidden = NO;
    } else {
        self.txtField.hidden = YES;
    }
}

#pragma mark -- UITextFieldDelegate委托方法,关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

#pragma mark -- UITextFieldDelegate委托方法,避免键盘遮挡文本框
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    [self.tableOption setContentOffset:CGPointMake(0.0, cell.frame.origin.y) animated:YES];
}

- (void)dealloc {
    [_textTitle release];
    [_tableOption release];
    [_txtField release];
    [_buttonConfirm release];
    //[_preViewImg release];
    [_imgButton release];
    [super dealloc];
}

- (IBAction)btnAttach:(id)sender {
    UIActionSheet *choosePhotoActionSheet;
    NSString *selectTitle=NSLocalizedString(@"选择附件", @"");
    NSString *cancel=NSLocalizedString(@"取消", @"");
    NSString *atPhoto=NSLocalizedString(@"拍照", @"");
    NSString *atPhotoLibrary=NSLocalizedString(@"从照片库选择", @"");
    NSString *atExistsPhoto=NSLocalizedString(@"从已上传照片选择", @"");
    NSString *atExistsVideo=NSLocalizedString(@"从已上传视频选择", @"");
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:selectTitle delegate:self cancelButtonTitle:cancel
                                               destructiveButtonTitle:nil
        otherButtonTitles:atPhoto, atPhotoLibrary,atExistsPhoto,atExistsVideo,nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:selectTitle delegate:self cancelButtonTitle:cancel
                                               destructiveButtonTitle:nil
        otherButtonTitles:atPhotoLibrary,atExistsPhoto,atExistsVideo,nil];
    }
    
    [choosePhotoActionSheet showInView:self.view];
    [choosePhotoActionSheet release];
}

- (IBAction)btnConfrim:(id)sender {
    NSLog(@"button confirm invoke");
}

-(void)uploadCompletion:(NSNotification*)notification{
    NSLog(@"upload success");
    attachid = [[notification userInfo] valueForKey:@"attachid"];
    NSLog(@"Success %@", attachid);
}
-(void)uploadFail:(NSNotification*)notification{}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
	NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 3:
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


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	
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
    
    SPostData *postData=[[SPostData alloc] init];
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    postData.filePath=url;

    postData.flag=@"vote";

    
	if([mediaType isEqualToString:@"public.movie"])			//被选中的是视频
	{
        if (fileName==nil) {
            NSDate * now = [NSDate date];
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"HH:mm:ss"];
            NSString *newDateString = [outputFormatter stringFromDate:now];
            fileName=[NSString stringWithFormat:@"%@.mov",newDateString];
        }
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        postData.data=videoData;
        [self getPreViewImg:url];
        postData.type=@"video";
        /*
		targetURL = url;		//视频的储存路径
		
		if (isCamera)
		{
			//保存视频到相册
			ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
			[library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:nil];
			[library release];
		}
		
		//获取视频的某一帧作为预览
        [self getPreViewImg:url];*/
        
	}
	else if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        if (fileName==nil) {
            NSDate * now = [NSDate date];
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"HH:mm:ss"];
            NSString *newDateString = [outputFormatter stringFromDate:now];
            fileName=[NSString stringWithFormat:@"%@.png",newDateString];
        }
        UIImage *tempImg= [info objectForKey:UIImagePickerControllerEditedImage];
        
        [self.imgButton setImage:tempImg forState:UIControlStateNormal];
        NSData *imgData=UIImageJPEGRepresentation(tempImg, 0.1f);
        postData.data=imgData;
        postData.type=@"img";
	}
	else
	{
		NSLog(@"Error media type");
		return;
	}
    postData.fileName=fileName;
    @try {
        [CommonUtil doUpload:postData withProgressInView:self];
    }
    @catch (NSException *exception) {
        NSLog(@"upload fail");
        NSLog(@"%@",exception);
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
    [self.imgButton setImage:img forState:UIControlStateNormal];
    [img release];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
