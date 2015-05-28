//
//  SmurfTableView.h
//  ShangShang
//
//  Created by coco on 15/5/23.
//  Copyright (c) 2015年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmurfTableView : UITableViewController<UITextFieldDelegate>
@property (retain, nonatomic) NSDictionary *loginUser;
@property (retain, nonatomic) NSMutableDictionary *sClass;

- (void)presentViewWithIdentifier:(NSString *)identifier;
- (void)associateTextFiedDelegate:(UITextField *)textField;
@end
