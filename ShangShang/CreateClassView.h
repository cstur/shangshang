//
//  CreateClassViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "SmurfView.h"
@interface CreateClassView : SmurfView<UITextViewDelegate>
@property (retain, nonatomic) IBOutlet UITextField *textClassName;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentVerify;
@property (retain, nonatomic) IBOutlet UITextView *textViewDescription;
- (IBAction)btnCreateClass:(id)sender;

@end
