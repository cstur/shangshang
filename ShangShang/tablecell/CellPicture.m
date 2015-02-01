//
//  CellPicture.m
//  ShangShang
//
//  Created by 史东杰 on 14-11-12.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "CellPicture.h"

@implementation CellPicture

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
- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.imageArrow.image = [UIImage imageNamed:@"UpAccessory@2x.png"];
    }else
    {
        self.imageArrow.image = [UIImage imageNamed:@"DownAccessory@2x.png"];
    }
}

- (void)dealloc {
    [_labelName release];
    [_labelDate release];
    [_imageArrow release];
    [_imageSmall release];
    [super dealloc];
}
@end
