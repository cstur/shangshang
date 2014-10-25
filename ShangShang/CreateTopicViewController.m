//
//  CreateTopicViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-11.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "CreateTopicViewController.h"

@interface CreateTopicViewController ()

@end

@implementation CreateTopicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textTopicName.delegate=self;
    self.textViewTopicDescription.delegate=self;
    self.textViewTopicDescription.text = @"请输入议题简介";
    self.textViewTopicDescription.textColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=@"创建议题";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_textTopicName release];
    [_textViewTopicDescription release];
    [super dealloc];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入议题简介"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入议题简介";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)btnCreateTopic:(id)sender {
    if (self.textTopicName.text.length==0||self.textViewTopicDescription.text.length==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"议题名和议题描述不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDictionary *body= [NSDictionary dictionaryWithObjectsAndKeys:
                         self.textTopicName.text,@"topic",
                         self.textViewTopicDescription.text,@"description",
                         self.sClass.classId,@"classId",
                         nil,@"startTime",
                         nil,@"endTime",
                         0,@"id",
                         nil];
    BOOL result=[CommonUtil restapi_CreateTopic:body];
    if (result) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"创建失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateTopicCompletion" object:nil];
}
@end
