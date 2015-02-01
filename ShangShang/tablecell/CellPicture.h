//
//  CellPicture.h
//  ShangShang
//
//  Created by 史东杰 on 14-11-12.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellPicture : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *labelName;
@property (retain, nonatomic) IBOutlet UILabel *labelDate;
@property (retain, nonatomic) IBOutlet UIImageView *imageArrow;
@property (retain, nonatomic) IBOutlet UIImageView *imageSmall;
- (void)changeArrowWithUp:(BOOL)up;
@end
