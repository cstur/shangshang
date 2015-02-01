//
//  ConfigServer.h
//  ShangShang
//
//  Created by 史东杰 on 14/12/4.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIP.h"

@interface ConfigServer : UITableViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *serverText;
@end
