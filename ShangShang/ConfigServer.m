//
//  ConfigServer.m
//  ShangShang
//
//  Created by 史东杰 on 14/12/4.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ConfigServer.h"

@interface ConfigServer ()


@end

@implementation ConfigServer

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[ServerIP getConfigIP]);
    self.serverText.text=[ServerIP getConfigIP];
    self.serverText.delegate=self;
    [self.serverText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"new value:%@",self.serverText.text);
    [ServerIP updateText:self.serverText.text];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

- (void)dealloc {
    [_serverText release];
    [super dealloc];
}
@end
