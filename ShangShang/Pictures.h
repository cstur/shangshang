//
//  Pictures.h
//  ShangShang
//
//  Created by 史东杰 on 14-11-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "AFHTTPRequestOperationManager.h"
#import "CellVideo.h"
#import "UIFolderTableView.h"
#import "CellPicture.h"
#import "SubCateViewController.h"

@interface Pictures : UITableViewController<UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>
@property (retain, nonatomic) IBOutlet UIBarButtonItem *upload;
- (IBAction)btnUpload:(id)sender;
@property (strong, nonatomic) NSArray *listImages;
@property(nonatomic, retain) UIImage *selectedphoto;
@property(nonatomic, retain) NSString *selectedMediaID;

@property (strong, nonatomic) SubCateViewController *subVc;
@property (strong, nonatomic) NSDictionary *currentCate;
@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;
@end
