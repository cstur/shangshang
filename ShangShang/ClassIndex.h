//
//  TeacherClassMainViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

//#import "FPPopoverController.h"
#import "ARCMacros.h"
//#import "FPPopoverKeyboardResponsiveController.h"
#import "CommonUtil.h"
#import "SmurfTableView.h"
#import "RESideMenu.h"
@interface ClassIndex : SmurfTableView
{
	//FPPopoverController *popover;
    NSString *result_;
	//CGFloat _keyboardHeight;
}
@property (nonatomic, retain) NSString *result;
@property (retain, nonatomic) IBOutlet UIImageView *qrCode;
@property (retain, nonatomic) IBOutlet UILabel *labelClassName;
@property (retain, nonatomic) IBOutlet UILabel *labelCapacity;
@property (retain, nonatomic) IBOutlet UITextView *textViewDescription;
@property (retain, nonatomic) IBOutlet UILabel *labelTeacherName;
@property (retain, nonatomic) IBOutlet UILabel *labelNeedVerify;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;

//@property(nonatomic)int hideMenu;

//- (void)menuClicked:(UIButton *)menuButton;
//- (void)popover:(id)sender;
//- (void)selectedTableRow:(NSUInteger)rowNum;
- (IBAction)btnJoinClass:(id)sender;
- (IBAction)backClick:(id)sender;

@end
