//
//  ApplyClassViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-5.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ApplyClassViewController.h"
#import "ClassManagementView.h"
#import "PendingClassViewController.h"

@interface ApplyClassViewController ()

@end

@implementation ApplyClassViewController
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
    // Do any additional setup after loading the view.
    self.labelClassName.text=[NSString stringWithFormat:@"课程名：%@",self.sClass.className];
    self.labelTeacherName.text=[NSString stringWithFormat:@"教师名：%@",self.sClass.teacherName];
    self.textDescription.text=[NSString stringWithFormat:@"%@",self.sClass.classDescription];
    self.labelNeedVerify.text=self.sClass.needVerify?@"需要验证":@"不需要验证";
    UIImage* qrimage = [QREncoder encode:[NSString stringWithFormat:@"{\"classid\":\"%@\",\"content\":\"\"}",self.sClass.classId]];
    self.imageQRCode.image = qrimage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnJoinClass:(id)sender {
    [CommonUtil showWaiting:self.navigationController whileExecutingBlock:^{
        NSString *classid=self.sClass.classId;
        NSString *userid=[SSUser getInstance].userid;
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        
        NSString* url = @"SmurfWeb/rest/student/applyclass";
        NSDictionary* dic= [NSDictionary dictionaryWithObjectsAndKeys:
                            classid,@"classid",
                            userid,@"userid",
                            nil];
        self.result= [httpUtil SendPostRequest:url withBody:dic];
	} completionBlock:^{
        if ([self.result isEqualToString:@"-1"]) {
            //apply failed
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"已经在该课程中" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if ([self.result isEqualToString:@"-2"]||[self.result isEqualToString:@"-3"]) {
            //apply failed
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"申请失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            //apply success
            if (self.sClass.needVerify) {
                UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                PendingClassViewController *newV=(PendingClassViewController*)[m instantiateViewControllerWithIdentifier:@"navPending"];
                
                [self presentViewController:newV animated:YES completion:^{}];
            }else{
                for (UIViewController* viewController in self.navigationController.viewControllers) {
                    if ([viewController isKindOfClass:[ClassManagementView class]] ) {
                        ClassManagementView *pendingClassViewController = (ClassManagementView*)viewController;
                        [self.navigationController popToViewController:pendingClassViewController animated:YES];
                    }
                }
            }
        }
	}];
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
    [_imageQRCode release];
    [_labelClassName release];
    [_labelTeacherName release];
    [_textDescription release];
    [_labelNeedVerify release];
    [super dealloc];
}
@end
