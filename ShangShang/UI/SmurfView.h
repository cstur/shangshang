//
//  SmurfView.h
//  ShangShang
//
//  Created by coco on 15/5/21.
//  Copyright (c) 2015年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpUtil.h"

@interface SmurfView : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) UITextField *currentTextField;
@property (retain, nonatomic) NSDictionary *loginUser;

- (void)associateTextFiedDelegate:(UITextField *)textField;
- (NSString *)stringForKey:(NSString *)key;
- (void)showAlert:(NSString *)msg;
- (void)presentViewWithIdentifier:(NSString *)identifier;
@end
