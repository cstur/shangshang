//
//  userinfo.h
//  ShangShang
//
//  Created by 史东杰 on 14-11-6.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "UpdateInfo.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface userinfo : UITableViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *headphoto;
@property (retain, nonatomic) IBOutlet UILabel *lnickName;
@property (retain, nonatomic) IBOutlet UILabel *lAccount;
@property (retain, nonatomic) IBOutlet UILabel *lgrade;
@property (retain, nonatomic) IBOutlet UILabel *lIntegral;
@property (retain, nonatomic) IBOutlet UILabel *lmail;
@property (retain, nonatomic) IBOutlet UILabel *lTelephoneNumber;
@property (retain, nonatomic) IBOutlet UILabel *lAddress;
@property (retain, nonatomic) IBOutlet UILabel *lSign;
@property (strong, nonatomic) AFHTTPRequestOperationManager* manager;
@property(nonatomic, retain) UIImage *selectedphoto;

-(void) uploadSuccess;
-(void) uploadFail;
@end
