//
//  QuestionViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "SSUser.h"
static NSString *const cquestion1 = @"你父亲的出生地？";
static NSString *const cquestion2 = @"你最爱的颜色？";
static NSString *const cquestion3 = @"你就读的初中校名？";

@interface QuestionViewController : UIViewController <NIDropDownDelegate,UITextFieldDelegate>{
    NIDropDown *dropDown;
    BOOL keyboardVisible;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UINavigationBar *nav;
- (IBAction)btnQuestion1:(id)sender;
- (IBAction)btnQuestion2:(id)sender;
- (IBAction)btnQuestion3:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *answer1;
@property (retain, nonatomic) IBOutlet UITextField *answer2;
@property (retain, nonatomic) IBOutlet UITextField *answer3;
@property (retain, nonatomic) IBOutlet UIButton *button1;
@property (retain, nonatomic) IBOutlet UIButton *button2;
@property (retain, nonatomic) IBOutlet UIButton *button3;
@property (nonatomic,assign)SSUser *user;
-(void)showDrop:(id)sender;
-(NSString*)mapQuestion:(NSString*)question;
- (IBAction)btnBack:(id)sender;
-(void)rel;
@end
