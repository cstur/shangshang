//
//  CreateVoteViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-11.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "AFHTTPRequestOperationManager.h"
#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CreateVoteViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (retain, nonatomic) IBOutlet UITextField *textTitle;
@property (retain, nonatomic) IBOutlet UITableView *tableOption;
@property (retain, nonatomic) IBOutlet UIButton *buttonConfirm;
@property (retain, nonatomic) IBOutlet UITextField *txtField;
@property (retain, nonatomic) IBOutlet UIImageView *preViewImg;


@property (nonatomic, retain) NSData *attachPhoto;
@property (strong, nonatomic) AFHTTPRequestOperationManager* manager;
@property (nonatomic, strong) NSMutableArray *listOption;
@property (nonatomic,assign)  SmurfClass *sClass;

- (IBAction)btnAttach:(id)sender;
- (IBAction)btnConfrim:(id)sender;
- (void)createVote;
- (void)createVoteTask;
- (void)createComplete;
- (void)doUpload:(NSURL*)filePath withImg:(UIImage*)tempImg;

@end
