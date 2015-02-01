//
//  SubCateViewController.h
//  ExpansionTableViewByZQ
//
//  Created by 郑 琪 on 13-2-27.
//  Copyright (c) 2013年 郑 琪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
@interface SubCateViewController : UIViewController
@property(nonatomic,retain)NSString *mediaID;
- (IBAction)deleteClick:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnDelete;

@end
