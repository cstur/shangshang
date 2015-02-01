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
#import <MediaPlayer/MediaPlayer.h>
#import "CellVideo.h"

@interface VideoViewController : UIViewController<UINavigationControllerDelegate, UITableViewDelegate,UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listVideo;
@property (strong, nonatomic) AFHTTPRequestOperationManager* manager;
@property (nonatomic, retain) MPMoviePlayerController* moviePlayer;
@property (nonatomic, retain) UIProgressView *cellItemProgress;

- (IBAction)uploadClick:(id)sender;
- (void)doUpload:(NSURL*)filePath withImg:(NSData*)tempData withType:(NSString*) type withName:(NSString*)fileName;
- (void)loadTable;
- (void) ShowAlert:(NSString*)Msg;

@end
