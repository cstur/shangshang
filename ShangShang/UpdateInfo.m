//
//  UpdateInfo.m
//  ShangShang
//
//  Created by 史东杰 on 14-11-6.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "UpdateInfo.h"

@interface UpdateInfo ()

@end

@implementation UpdateInfo
@synthesize attribute;
@synthesize value;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self associateTextFiedDelegate:self.tValue];
    self.tValue.text=self.value;
}

-(void)viewWillDisappear:(BOOL)animated{
    if ([self.tValue.text isEqualToString:@""]) {
        return;
    }
    NSString* uid=[[[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USER] objectForKey:@"id"];
    NSDictionary *body= [NSDictionary dictionaryWithObjectsAndKeys:
                         uid,@"userid",
                         self.attribute,@"attribute",
                         self.tValue.text,@"value",
                         nil];
    [CommonUtil iosapi_updateUserInfo:body];
}

- (void)dealloc {
    [_tValue release];
    [super dealloc];
}
@end
