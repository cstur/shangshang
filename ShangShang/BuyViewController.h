//
//  BuyViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-30.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "HttpUtil.h"
#import "AlixLibService.h"

@interface BuyViewController : UITableViewController
{
    SEL _result;
    UIView *_loadingView;
}
@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
-(void)paymentResult:(NSString *)result;

@property (retain, nonatomic) IBOutlet UILabel *labelSpace;
@property (retain, nonatomic) IBOutlet UIProgressView *progressSapce;
@property (retain, nonatomic) IBOutlet UILabel *labelClass;
@property (retain, nonatomic) IBOutlet UILabel *labelVote;
@property (retain, nonatomic) IBOutlet UILabel *labelTopic;
@property (retain, nonatomic) IBOutlet UIProgressView *progressClass;
@property (retain, nonatomic) IBOutlet UIProgressView *progressTopic;
@property (retain, nonatomic) IBOutlet UIProgressView *progressVote;
@property (strong, nonatomic) UIView *loadingView;

@end
