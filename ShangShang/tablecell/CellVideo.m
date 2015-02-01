//
//  CellVideo.m
//  ShangShang
//
//  Created by 史东杰 on 14-10-31.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "CellVideo.h"

@implementation CellVideo

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
    [_labelVideoName release];
    [_imgPreView release];
    [_progressBar release];
    [super dealloc];
}
@end
