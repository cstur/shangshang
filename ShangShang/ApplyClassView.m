////
////  ApplyClassViewController.m
////  ShangShang
////
////  Created by 史东杰 on 14-8-5.
////  Copyright (c) 2014年 aopai.ios. All rights reserved.
////
//
//#import "ApplyClassView.h"
//#import "ClassManagementView.h"
//#import "GeneralTableView.h"
//@interface ApplyClassView ()
//
//@end
//
//@implementation ApplyClassView
//@synthesize result = result_;
//- (void)viewDidLoad {
//	[super viewDidLoad];
//	// Do any additional setup after loading the view.
//	self.labelClassName.text = [NSString stringWithFormat:@"课程名：%@",  [self.sClass objectForKey:@"name"]];
//	self.labelTeacherName.text = [NSString stringWithFormat:@"教师名：%@", [self.sClass objectForKey:@"userName"]];
//	self.textDescription.text = [NSString stringWithFormat:@"%@", [self.sClass objectForKey:@"description"]];
//	self.labelNeedVerify.text = [[self.sClass objectForKey:@"needVerify"] boolValue] ? @"需要验证" : @"不需要验证";
//	UIImage *qrimage = [QREncoder encode:[NSString stringWithFormat:@"{\"classid\":\"%@\",\"content\":\"\"}", [self.sClass objectForKey:@"id"]]];
//	self.imageQRCode.image = qrimage;
//}
//
//- (IBAction)btnJoinClass:(id)sender {
//	[CommonUtil showWaiting:self.navigationController whileExecutingBlock: ^{
//	    NSString *classid = [self.sClass objectForKey:@"id"];
//	    NSString *userid = [[[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USER] objectForKey:@"id"];
//	    HttpUtil *httpUtil = [[HttpUtil alloc] init];
//
//	    NSString *url = @"SmurfWeb/rest/student/applyclass";
//	    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//	                         classid, @"classid",
//	                         userid, @"userid",
//	                         nil];
//	    self.result = [httpUtil SendPostRequest:url withBody:dic];
//	} completionBlock: ^{
//	    if ([self.result isEqualToString:@"-1"]) {
//	        //apply failed
//	        [self showAlert:@"已经在该课程中"];
//		}
//	    else if ([self.result isEqualToString:@"-2"] || [self.result isEqualToString:@"-3"]) {
//	        //apply failed
//	        [self showAlert:@"申请失败"];
//		}
//	    else {
//	        //apply success
//	        if ([[self.sClass objectForKey:@"needVerify"] boolValue]) {
//	            UIStoryboard *m = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//	            GeneralTableView *newV = (GeneralTableView *)[m instantiateViewControllerWithIdentifier:@"generalTableView"];
//                
//                NSString* uid=[[[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USER] objectForKey:@"id"];
//                NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/student/unreadyclasses?id=%@",uid];
//                newV.smurfURI=url;
//                newV.smurfTitle=@"待审批课程";
//	            [self presentViewController:newV animated:YES completion: ^{}];
//			}
//	        else {
//	            for (UIViewController *viewController in self.navigationController.viewControllers) {
//	                if ([viewController isKindOfClass:[ClassManagementView class]]) {
//	                    ClassManagementView *pendingClassViewController = (ClassManagementView *)viewController;
//	                    [self.navigationController popToViewController:pendingClassViewController animated:YES];
//					}
//				}
//			}
//		}
//	}];
//}
//
//- (void)dealloc {
//	[_imageQRCode release];
//	[_labelClassName release];
//	[_labelTeacherName release];
//	[_textDescription release];
//	[_labelNeedVerify release];
//	[super dealloc];
//}
//
//@end
