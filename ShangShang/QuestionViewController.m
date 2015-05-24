//
//  QuestionViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "QuestionViewController.h"
#import "NIDropDown.h"
#import "SSUser.h"
#import "HttpUtil.h"
#import "AddDetailsInfoViewController.h"
#import "CommonUtil.h"
@interface QuestionViewController ()

@end

@implementation QuestionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setButton:self.button1];
    [self setButton:self.button2];
    [self setButton:self.button3];
    
    [self associateTextFiedDelegate:self.answer1];
    [self associateTextFiedDelegate:self.answer2];
    [self associateTextFiedDelegate:self.answer3];
}

-(void)setButton:(UIButton *)button{
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor blackColor] CGColor];
    button.layer.cornerRadius = 5;
}

- (IBAction)btnQuestion1:(id)sender {
    [self showDrop:sender];
}

-(void)viewWillAppear:(BOOL)animated{
    CGRect frame = [self.nav frame];
    frame.size.height = 82.0f;
    [self.nav setFrame:frame];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)showDrop:(id)sender{
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:cquestion1, cquestion2, cquestion3,nil];
    NSArray * arrImage = [[NSArray alloc] init];
    arrImage = [NSArray arrayWithObjects:nil,nil,nil, nil];
    if(dropDown == nil) {
        CGFloat f = 120;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrImage :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (IBAction)btnQuestion2:(id)sender {
    [self showDrop:sender];
}

- (IBAction)btnQuestion3:(id)sender {
    [self showDrop:sender];
}
- (void)dealloc {
    [_answer1 release];
    [_answer2 release];
    [_answer3 release];
    [_nav release];
    [_scrollView release];
    [super dealloc];
}

-(void) keyboardDidShow:(NSNotification*)notif{
    if(keyboardVisible)
        return;
    
    NSDictionary* info =[notif userInfo];
    NSValue* aValue=[info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize=[aValue CGRectValue].size;
    
    CGRect viewFrame=self.scrollView.frame;
    viewFrame.size.height-=(keyboardSize.height);
    self.scrollView.frame=viewFrame;
    
    keyboardVisible=YES;
}

-(void) keyboardDidHide:(NSNotification*)notif{
    NSDictionary* info =[notif userInfo];
    NSValue* aValue=[info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize=[aValue CGRectValue].size;
    
    CGRect viewFrame=self.scrollView.frame;
    viewFrame.size.height+=(keyboardSize.height);
    self.scrollView.frame=viewFrame;    
    
    if(!keyboardVisible)
        return;
    
    keyboardVisible=NO;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    NSString* url = @"SmurfWeb/rest/user/register";
    self.user.questionid1=@"0";
    self.user.questionindex1=[self mapQuestion:self.button1.titleLabel.text];
    self.user.answer1=self.answer1.text;
    
    self.user.questionid2=@"1";
    self.user.questionindex2=[self mapQuestion:self.button2.titleLabel.text];
    self.user.answer2=self.answer2.text;
    
    self.user.questionid3=@"2";
    self.user.questionindex3=[self mapQuestion:self.button3.titleLabel.text];
    self.user.answer3=self.answer3.text;
    
    NSString* result= [self.httpUtil SendPostRequest:url withBody:self.user.dictionary_Register];
    if ([result isEqualToString:@"-1"]) {
        //register failed
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"注册失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //register success
        self.user.userid=result;
        [SSUser initWith:self.user.userName andPassword:self.user.password];
        SSUser *user=[SSUser getInstance];
        user.nickName=@"新用户";
        DBManager *dbManager=[[DBManager alloc] init];
        [dbManager UpdateDictData:@"username" andValue:self.user.userName];
        [dbManager UpdateDictData:@"password" andValue:self.user.password];
        return YES;
    }
    return NO;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(NSString*)mapQuestion:(NSString*)question{
    if ([question isEqualToString:cquestion1]) {
        return @"0";
    }
    if ([question isEqualToString:cquestion2]) {
        return @"1";
    }
    if ([question isEqualToString:cquestion3]) {
        return @"2";
    }
    return @"0";
}

- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"");}];
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}

-(void)rel{
    dropDown = nil;
}
@end
