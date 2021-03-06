//
//  AddDetailsInfoViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "SmurfView.h"

@interface AddDetailsView : SmurfView <UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate> {
	UIImage *photo_;
	NSString *result_;
}
@property (retain, nonatomic) IBOutlet UINavigationBar *nav;
@property (retain, nonatomic) IBOutlet UITextField *labelNickName;
@property (retain, nonatomic) IBOutlet UITextField *labelEmail;
@property (retain, nonatomic) IBOutlet UITextField *labelTel;
@property (retain, nonatomic) IBOutlet UITextField *labelAddress;
@property (nonatomic, retain) NSString *result;
@property (nonatomic, retain) UIImage *selectedphoto;
@property (retain, nonatomic) IBOutlet UIImageView *headphoto;

- (IBAction)btnSkip:(id)sender;
- (IBAction)btnUpdate:(id)sender;
- (void)doUpdate;
- (IBAction)setPhoto:(id)sender;
- (void)ShowRoot;
@end
