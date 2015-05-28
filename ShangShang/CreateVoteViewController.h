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
#import "SmurfTableView.h"

@interface CreateVoteViewController : SmurfTableView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (retain, nonatomic) IBOutlet UITextField *textTitle;
@property (retain, nonatomic) IBOutlet UITableView *tableOption;
@property (retain, nonatomic) IBOutlet UIButton *buttonConfirm;
@property (retain, nonatomic) IBOutlet UITextField *txtField;
@property (retain, nonatomic) IBOutlet UIButton *imgButton;


@property (nonatomic, retain) NSData *attachPhoto;
@property (nonatomic, strong) NSMutableArray *listOption;

- (IBAction)btnAttach:(id)sender;
- (IBAction)btnConfrim:(id)sender;

- (void)createVote;
- (void)createVoteTask;
- (void)createComplete;

-(void)uploadCompletion:(NSNotification*)notification;
-(void)uploadFail:(NSNotification*)notification;
@end
