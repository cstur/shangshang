//
//  PendingClassViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-30.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassIndex.h"
#import "SmurfTableView.h"
@interface GeneralTableView : SmurfTableView
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, retain) NSString *smurfTitle;
@property (nonatomic, retain) NSString *smurfURI;

- (IBAction)btnBack:(id)sender;

@end
