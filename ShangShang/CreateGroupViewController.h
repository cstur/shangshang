//
//  CreateGroupViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-9-28.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"

@interface CreateGroupViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *textGroupName;
@property (nonatomic, retain) NSString *topicID;
- (IBAction)btnCreateGroup:(id)sender;

@end
