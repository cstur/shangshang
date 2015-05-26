//
//  StudentMainViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-14.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "SmurfTableView.h"

@interface StudentIndex : SmurfTableView {
}
@property (retain, nonatomic) IBOutlet UILabel *labelNickName;
@property (retain, nonatomic) IBOutlet UILabel *labelUserName;
@property (retain, nonatomic) IBOutlet UIImageView *userPhoto;
@property (nonatomic, assign) BOOL flagJumpPendingClassView;
@property (nonatomic, retain) UIImage *headphoto;

- (void)openLoginDialog;
- (IBAction)btnBack:(id)sender;
- (void)jumpToPendClassView;
@end
