//
//  ViewOptionTableViewCell.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-18.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ViewOptionTableViewCell.h"

@implementation ViewOptionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_labelContent release];
    [_labelCount release];
    [super dealloc];
}
@end
