//
//  ClassViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-3.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ClassViewController.h"

@interface ClassViewController ()

@end

@implementation ClassViewController
@synthesize result = result_;
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
    
    self.labelClassName.text=[NSString stringWithFormat:@"课程名：%@",self.sClass.className];
    self.labelTeacherName.text=[NSString stringWithFormat:@"教师名：%@",self.sClass.teacherName];
    self.textViewDes.text=[NSString stringWithFormat:@"%@",self.sClass.classDescription];
    UIImage* qrimage = [QREncoder encode:[NSString stringWithFormat:@"{\"classid\":\"%@\",\"content\":\"\"}",self.sClass.classId]];
    self.imageQRCode.image = qrimage;
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
    [_labelClassName release];
    [_labelTeacherName release];
    [_imageQRCode release];
    [_textViewDes release];
    [super dealloc];
}
@end
