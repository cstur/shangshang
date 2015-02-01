//
//  VoteSum.h
//  ShangShang
//
//  Created by 史东杰 on 14-10-30.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "CommonUtil.h"

@interface VoteSum : UIViewController<XYPieChartDelegate, XYPieChartDataSource>
@property (retain, nonatomic) IBOutlet XYPieChart *pieChart;
@property (retain, nonatomic) IBOutlet UILabel *percentLabel;

@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

@property (nonatomic, strong) NSArray *listOption;
@property (nonatomic, strong) NSArray *listDetails;
@end

