//
//  StudentVerifyTableViewCell.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "StudentVerifyTableViewCell.h"

@implementation StudentVerifyTableViewCell
@synthesize classid = classid_;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.labelMsg setHidden:YES];
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
    [_labelNickName release];
    [_buttonReject release];
    [_buttonApprove release];
    [_labelMsg release];
    [super dealloc];
}

-(void)disableButton{
    self.labelMsg.text=@"操作成功";
    [self.labelMsg setHidden:FALSE];
    [self.buttonApprove setHidden:YES];
    [self.buttonReject setHidden:YES];
}
- (IBAction)btnApprove:(id)sender {
    
    NSDictionary *param= [NSDictionary dictionaryWithObjectsAndKeys:
                         self.user.userid,@"userid",
                         self.classid,@"classid",
                         nil];
    NSArray *body = [[NSArray alloc] initWithObjects:param, nil];
    BOOL result=[CommonUtil restapi_AgreeStudent:body];
    if (result) {
        
        [self disableButton];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"出错了" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)btnReject:(id)sender {
    
    NSDictionary *param= [NSDictionary dictionaryWithObjectsAndKeys:
                         self.user.userid,@"userid",
                         self.classid,@"classid",
                         nil];
    NSArray *body = [[NSArray alloc] initWithObjects:param, nil];
    BOOL result=[CommonUtil restapi_DeclineStudent:body];
    if (result) {
        [self disableButton];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"出错了" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
