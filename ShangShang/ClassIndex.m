//
//  TeacherClassMainViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ClassIndex.h"
#import "StudentVerifyTableViewController.h"
#import "VoteManagementViewController.h"
#import "TopicManagementViewController.h"
#import "StudentListTableViewController.h"
#import "MenuTableView.h"

@interface ClassIndex ()

@end

@implementation ClassIndex


- (void)viewWillAppear:(BOOL)animated {
	self.navigationItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_TITLE];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.labelClassName.text = [NSString stringWithFormat:@"课程名：%@", [self.sClass objectForKey:@"name"]];
	self.labelCapacity.text = [NSString stringWithFormat:@"课程容量：%@", [self.sClass objectForKey:@"capacity"]];
	self.textViewDescription.text = [NSString stringWithFormat:@"%@", [self.sClass objectForKey:@"description"]];
	UIImage *qrimage = [QREncoder encode:[NSString stringWithFormat:@"{\"classid\":\"%@\",\"content\":\"\"}", [self.sClass objectForKey:@"id"]]];
	self.qrCode.image = qrimage;
/*
	//KEYBOARD OBSERVERS
	[[NSNotificationCenter defaultCenter] addObserver:self
	                                         selector:@selector(keyboardWillShow:)
	                                             name:UIKeyboardWillShowNotification
	                                           object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
	                                         selector:@selector(keyboardWillHide:)
	                                             name:UIKeyboardWillHideNotification
	                                           object:nil];
*/
	UIImage *faceImage = [UIImage imageNamed:@"icon_menu.png"];
	UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
	face.bounds = CGRectMake(0, 0, 20, 20);
	[face addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
	[face setImage:faceImage forState:UIControlStateNormal];
	UIBarButtonItem *menuImageButon = [[UIBarButtonItem alloc] initWithCustomView:face];
	self.navigationItem.rightBarButtonItem = menuImageButon;
	[menuImageButon release];
}
/*
- (void)keyboardWillShow:(NSNotification *)notification {
	NSDictionary *info = notification.userInfo;
	CGRect keyboardRect = [[info valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	_keyboardHeight = keyboardRect.size.height;

	//if the popover is present will be refreshed
	popover.keyboardHeight = _keyboardHeight;
	[popover setupView];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	_keyboardHeight = 0.0;

	//if the popover is present will be refreshed
	popover.keyboardHeight = _keyboardHeight;
	[popover setupView];
}
*/
- (void)menuClicked:(UIButton *)menuButton {
	[self popover:menuButton];
}

/*
   - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
   {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
   }
   //iOS6 implementation of the rotation
   - (NSUInteger)supportedInterfaceOrientations
   {
    //All orientations
    return UIInterfaceOrientationMaskAll;
   }
 */
- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController *)visiblePopoverController {
    NSLog(@"new popo");
	[visiblePopoverController dismissPopoverAnimated:YES];
    [visiblePopoverController autorelease];
}

- (void)popover:(id)sender {
	UIStoryboard *m = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	MenuTableView *controller = [m instantiateViewControllerWithIdentifier:@"menutable"];
	controller.delegate = self;

	int role = [[[[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USER] objectForKey:@"role"] intValue];
	if (role == ROLE_Teacher) {
		controller.listMenu = [NSArray arrayWithObjects:@"学生验证", @"投票管理", @"议题管理", @"学生列表", nil];
	}
	else {
		controller.listMenu = [NSArray arrayWithObjects:@"课程投票", @"讨论组", nil];
	}

	//popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:controller];
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    //popover.delegate=self;
	popover.tint = FPPopoverLightGrayTint;
	//popover.keyboardHeight = _keyboardHeight;

	int lineHeight = 48;
	popover.contentSize = CGSizeMake(130, lineHeight * (controller.listMenu.count + 1));
	popover.arrowDirection = FPPopoverArrowDirectionAny;
	[popover presentPopoverFromView:sender];
}

/*
   -(IBAction)goToTableView:(id)sender
   {
    //  FPDemoTableViewController *controller = [[FPDemoTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:nil animated:YES];
   }
 */
- (void)selectedTableRow:(NSUInteger)rowNum {
	UIStoryboard *m = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	//self.navigationItem.title = @"返回";
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];

	if (rowNum == 0) {
		StudentVerifyTableViewController *stuVerify = (StudentVerifyTableViewController *)[m instantiateViewControllerWithIdentifier:@"stuverify"];
		stuVerify.sClass = self.sClass;
		[self.navigationController pushViewController:stuVerify animated:YES];
	}
	if (rowNum == 1) {
		VoteManagementViewController *voteManagement = (VoteManagementViewController *)[m instantiateViewControllerWithIdentifier:@"votemanage"];
		voteManagement.sClass = self.sClass;
		[self.navigationController pushViewController:voteManagement animated:YES];
	}
	if (rowNum == 2) {
		TopicManagementViewController *topicManagement = (TopicManagementViewController *)[m instantiateViewControllerWithIdentifier:@"topicmanage"];
		topicManagement.sClass = self.sClass;
		[self.navigationController pushViewController:topicManagement animated:YES];
	}
	if (rowNum == 3) {
		StudentListTableViewController *stuList = (StudentListTableViewController *)[m instantiateViewControllerWithIdentifier:@"studentlist"];
		stuList.sClass = self.sClass;
		[self.navigationController pushViewController:stuList animated:YES];
	}
	[popover dismissPopoverAnimated:YES];
}

- (void)dealloc {
	[_qrCode release];
	[_labelClassName release];
	[_labelCapacity release];
	[_textViewDescription release];
    [popover release];
	[super dealloc];
}

@end
