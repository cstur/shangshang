//
//  UpdateInfo.h
//  ShangShang
//
//  Created by 史东杰 on 14-11-6.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"

@interface UpdateInfo : UITableViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *tValue;
@property (nonatomic, retain) NSString *attribute;
@property (nonatomic, retain) NSString *value;
@end
