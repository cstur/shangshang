//
//  CreateTopicViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-11.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
@interface CreateTopicViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *textTopicName;
@property (retain, nonatomic) IBOutlet UITextView *textViewTopicDescription;
- (IBAction)btnCreateTopic:(id)sender;
@property (nonatomic,assign)SmurfClass *sClass;
@end
