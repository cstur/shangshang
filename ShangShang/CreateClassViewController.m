//
//  CreateClassViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "CreateClassViewController.h"

@interface CreateClassViewController ()

@end

@implementation CreateClassViewController

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
    self.textClassName.delegate=self;
    self.textViewDescription.delegate=self;
    self.textViewDescription.text = @"请输入课程简介";
    self.textViewDescription.textColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_textClassName release];
    [_segmentVerify release];
    [_textViewDescription release];
    [super dealloc];
}
- (IBAction)btnCreateClass:(id)sender {
    if (self.textClassName.text.length==0||self.textViewDescription.text.length==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"课程名和课程描述不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSString* verify=[self.segmentVerify titleForSegmentAtIndex:self.segmentVerify.selectedSegmentIndex];
    
    if ([verify isEqualToString:@"需要验证"]) {
        verify=@"true";
    }else{
        verify=@"false";
    }
    
    SSUser *u=[SSUser getInstance];
    NSDictionary *body= [NSDictionary dictionaryWithObjectsAndKeys:
            self.textClassName.text,@"name",
            verify,@"verify",
            self.textViewDescription.text,@"description",
            u.userid,@"userid",
            nil];
    BOOL result=[CommonUtil restapi_CreateClass:body];
    if (result) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"创建失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateClassCompletion" object:nil];
}
@end
