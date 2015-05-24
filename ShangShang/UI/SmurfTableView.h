//
//  SmurfTableView.h
//  ShangShang
//
//  Created by coco on 15/5/23.
//  Copyright (c) 2015年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmurfTableView : UITableViewController
@property (retain, nonatomic) NSDictionary *loginUser;

- (void)presentViewWithIdentifier:(NSString *)identifier;

@end
