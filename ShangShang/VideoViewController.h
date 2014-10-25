//
//  VideoViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-30.
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

@interface VideoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *listVideo;
@property (strong, nonatomic) AFHTTPRequestOperationManager* manager;

- (IBAction)uploadClick:(id)sender;
- (void)doUpload:(NSURL*)filePath withImg:(NSData*)tempData withType:(NSString*) type;
- (void)loadTable;
- (void) ShowAlert:(NSString*)Msg;

@end
