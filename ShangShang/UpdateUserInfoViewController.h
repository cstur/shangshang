//
//  UpdateUserInfoViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-22.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSUser.h"
@interface UpdateUserInfoViewController : UIViewController<UINavigationControllerDelegate,UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>{
    UIImage *selectedphoto_;
    NSString *result_;
   // NSString *password_;
   // NSString *userName_;
}

@property (retain, nonatomic) IBOutlet UITextField *textName;
@property (retain, nonatomic) IBOutlet UITextField *textMail;
@property (retain, nonatomic) IBOutlet UITextField *textTel;
@property (retain, nonatomic) IBOutlet UITextField *textAddress;
@property (retain, nonatomic) IBOutlet UITextField *textGrade;
@property (retain, nonatomic) IBOutlet UITextField *textScore;

@property (retain, nonatomic) IBOutlet UILabel *labelMessage;
@property (retain, nonatomic) IBOutlet UIImageView *headphoto;
//@property (nonatomic, retain) NSString *password;
//@property (nonatomic, retain) NSString *userName;
- (IBAction)setPhoto:(id)sender;
-(void)updateTask;
-(void)updateComplete;
- (IBAction)btnUpdate:(id)sender;
@property(nonatomic, retain) UIImage *selectedphoto;

@property (nonatomic, retain) NSString *result;
@end
