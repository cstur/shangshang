//
//  CreateGroupViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-9-28.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "CreateGroupViewController.h"

@interface CreateGroupViewController ()

@end

@implementation CreateGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=@"创建讨论组";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_textGroupName release];
    [super dealloc];
}
- (IBAction)btnCreateGroup:(id)sender {
    /*
     body sample:
     {"bigGroupId":7,"comments":null,"endTime":null,"id":0,"name":"vvv","ownerId":100247,"startTime":null,"summary":null}
     */
    if (self.textGroupName.text.length==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"名称不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    NSDictionary *body= [NSDictionary dictionaryWithObjectsAndKeys:
                         self.topicID,@"bigGroupId",
                         //nil,@"comments",
                         //nil,@"endTime",
                         @"0",@"id",
                         self.textGroupName.text,@"name",
                         [SSUser getInstance].userid,@"ownerId",
                         //nil,@"startTime",
                         //nil,@"summary",
                         nil];
    [CommonUtil restapi_CreateGroup:body];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateGroupCompletion" object:nil];
}
@end
