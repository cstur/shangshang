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
    
    self.manager = [AFHTTPRequestOperationManager manager];
	self.manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
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
    vote.classid=self.sClass.classId;
    
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
    HttpUtil *util= [HttpUtil alloc];
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
    [_textTitle release];
    [_tableOption release];
    [_txtField release];
    [_buttonConfirm release];
    [_preViewImg release];
    [super dealloc];
}

- (void)doUpload:(NSURL*)filePath withImg:(NSData*)tempData withType:(NSString*) type{
	// 获取用户选中的行
	//NSInteger selectedRow = [self.picker selectedRowInComponent:0];
	// 获取用户选中的文件名
	//NSString* fileName = [images objectAtIndex:selectedRow];
	// 根据用户选中的文件名确定需要上传的文件
	//NSURL *filePath = [[NSBundle mainBundle] URLForResource:fileName
    //withExtension:@"png"];
    NSString *fileName = [filePath lastPathComponent];
    NSString *postURL=[NSString stringWithFormat:@"http://%@/SmurfWeb/View/UploadServlet",[ServerIP getConfigIP]];
	NSDictionary *parameters = @{@"userid": [SSUser getInstance].userid,@"filetype":type};
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:postURL
                                    parameters:parameters
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         if ([type isEqualToString:@"img"]) {
                             //NSData *imgData=UIImageJPEGRepresentation(tempImg, 0.1f);
                             [formData appendPartWithFileData:tempData  // 指定上传的文件
                                                         name:@"file"  // 指定上传文件对应的请求参数名
                              // 指定上传文件的原始文件名
                                                     fileName:fileName
                              // 指定上传文件的MIME类型
                                                     mimeType:@"image/*"];
                         }else{
                             NSData *videoData = [NSData dataWithContentsOfURL:filePath];
                             [formData appendPartWithFileData:videoData  // 指定上传的文件
                                                         name:@"file"  // 指定上传文件对应的请求参数名
                              // 指定上传文件的原始文件名
                                                     fileName:fileName
                              // 指定上传文件的MIME类型
                                                     mimeType:@"video/*"];
                         }
                     }];
    
    AFHTTPRequestOperation *operation =
    [self.manager HTTPRequestOperationWithRequest:request
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              attachid=[[NSString alloc] initWithData:responseObject encoding:
                                                        NSUTF8StringEncoding];
                                              NSLog(@"Success %@", attachid);
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              NSLog(@"Failure %@", error.description);
                                          }];
    
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation start];
}

- (IBAction)btnAttach:(id)sender {
    
    NSLog(@"Enter attach");
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

- (IBAction)btnConfrim:(id)sender {
    NSLog(@"xx");
}


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

	//[self presentModalViewController:imagePickerController animated:YES];
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	
	if([mediaType isEqualToString:@"public.movie"])			//被选中的是视频
	{
		NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        [self getPreViewImg:url];
        [self doUpload:url withImg:videoData withType:@"video"];
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
        UIImage *tempImg= [info objectForKey:UIImagePickerControllerEditedImage];
        self.preViewImg.image=tempImg;
        NSData *imgData=UIImageJPEGRepresentation(tempImg, 0.1f);
        NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        
        [self doUpload:imagePath withImg:imgData withType:@"img"];
	}
	else
	{
		NSLog(@"Error media type");
		return;
	}
    
	//[picker dismissModalViewControllerAnimated:YES];

    //UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    //self.attachPhoto = UIImagePNGRepresentation(editedImage);
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
    self.preViewImg.image=img;
    [img release];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
