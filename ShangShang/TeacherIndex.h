//
//  TeacherMainViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-29.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "SmurfTableView.h"
@interface TeacherIndex : SmurfTableView

@property (retain, nonatomic) IBOutlet UIImageView *userPhoto;
@property (retain, nonatomic) IBOutlet UILabel *labelUserName;
@property (retain, nonatomic) IBOutlet UILabel *labelNickName;
@property (nonatomic, retain) UIImage *headphoto;

- (IBAction)btnBack:(id)sender;
- (void)openLoginDialog;
@end
