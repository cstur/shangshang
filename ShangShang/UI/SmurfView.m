//
//  SmurfView.m
//  ShangShang
//
//  Created by coco on 15/5/21.
//  Copyright (c) 2015年 aopai.ios. All rights reserved.
//

#import "SmurfView.h"


@interface SmurfView ()

@end

@implementation SmurfView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    self.httpUtil=[[HttpUtil alloc] init];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)associateTextFiedDelegate:(UITextField *)textField {
	textField.delegate = self;
}

- (NSString *)stringForKey:(NSString *)key {
	NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	if (temp == nil) {
		return @"";
	}
	return temp;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	self.currentTextField = textField;
}

- (void)showAlert:(NSString *)msg {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[alert show];
}

- (void)presentViewWithIdentifier:(NSString *)identifier {
	UIStoryboard *m = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	UINavigationController *newV = (UINavigationController *)[m instantiateViewControllerWithIdentifier:identifier];
	[self presentViewController:newV animated:YES completion:nil];
}

@end
