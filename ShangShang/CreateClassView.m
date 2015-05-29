//
//  CreateClassViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "CreateClassView.h"

@interface CreateClassView ()

@end

@implementation CreateClassView


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self associateTextFiedDelegate:self.textClassName];
    self.textViewDescription.delegate=self;
    self.textViewDescription.text = @"请输入课程简介";
    self.textViewDescription.textColor = [UIColor lightGrayColor];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入课程简介"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入课程简介";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)dealloc {
    [_textClassName release];
    [_segmentVerify release];
    [_textViewDescription release];
    [super dealloc];
}

- (IBAction)btnCreateClass:(id)sender {
    if (self.textClassName.text.length==0||self.textViewDescription.text.length==0) {
        [self showAlert:@"课程名和课程描述不能为空"];
        return;
    }
    
    NSString* verify=[self.segmentVerify titleForSegmentAtIndex:self.segmentVerify.selectedSegmentIndex];
    
    if ([verify isEqualToString:@"需要验证"]) {
        verify=@"true";
    }else{
        verify=@"false";
    }
    
    NSString* uid=[[[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USER] objectForKey:@"id"];
    NSDictionary *body= [NSDictionary dictionaryWithObjectsAndKeys:
            self.textClassName.text,@"name",
            verify,@"verify",
            self.textViewDescription.text,@"description",
            uid,@"userid",
            nil];
    BOOL result=[CommonUtil restapi_CreateClass:body];
    if (result) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self showAlert:@"创建失败"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateClassCompletion" object:nil];
}
@end
