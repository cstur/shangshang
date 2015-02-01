//
//  StudentVerifyTableViewCell.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
@interface StudentVerifyTableViewCell : UITableViewCell{
    NSString *classid_;
}
@property (nonatomic, retain) NSString *classid;
@property (nonatomic,assign)SSUser *user;
@property (retain, nonatomic) IBOutlet UILabel *labelNickName;
- (IBAction)btnApprove:(id)sender;
- (IBAction)btnReject:(id)sender;
-(void)disableButton;
@property (retain, nonatomic) IBOutlet UIButton *buttonReject;
@property (retain, nonatomic) IBOutlet UIButton *buttonApprove;
@property (retain, nonatomic) IBOutlet UILabel *labelMsg;

@end
