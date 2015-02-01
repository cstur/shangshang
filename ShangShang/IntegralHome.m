//
//  IntegralHome.m
//  ShangShang
//
//  Created by 史东杰 on 14/11/22.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "IntegralHome.h"
#import "ServerIP.h"
@interface IntegralHome ()

@end

@implementation IntegralHome

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str=[NSString stringWithFormat:@"http://%@/SmurfWeb/View/mobile/integral.html",[ServerIP getConfigIP]];
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"web load finish");
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
@end
