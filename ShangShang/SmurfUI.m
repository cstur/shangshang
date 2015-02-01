//
//  SmurfUI.m
//  ShangShang
//
//  Created by 史东杰 on 14/12/11.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "SmurfUI.h"

@implementation SmurfUI
+(UIView*)SmurfIndicator{
    UIView *indicatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [aiView setFrame:CGRectMake(0, 0, 40, 40)];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 80, 40)];
    label.text=@"加载中...";
    label.font = [UIFont fontWithName:@"System" size:6.0];
    [indicatorView addSubview:aiView];
    [indicatorView addSubview:label];
    [aiView startAnimating];
    return indicatorView;
}
@end
