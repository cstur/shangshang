//
//  VoteManagementViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-11.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "VoteManagementViewController.h"
#import "CreateVoteViewController.h"
#import "ViewVoteViewController.h"
@interface VoteManagementViewController ()

@end

@implementation VoteManagementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = TITLE_SHANGSHANG;
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self refreshTable];
    // Do any additional setup after loading the view.
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createVoteCompletion:) name:@"CreateVoteCompletion" object:nil];
}

-(void)createVoteCompletion:(NSNotification*)notification{
    [self refreshTable];
}

-(void)refreshTable{
    @try {
        self.listVote=[CommonUtil iosapi_VoteList:[self.sClass objectForKey:@"id"]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listVote count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row=[indexPath row];
    NSDictionary *dict=[self.listVote objectAtIndex:row];
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ViewVoteViewController *voteView=(ViewVoteViewController*)[m instantiateViewControllerWithIdentifier:@"viewvote"];
    SSVote *voteTemp=[[SSVote alloc] init];
    voteTemp.title=[dict objectForKey:@"title"];
    voteTemp.voteid=[dict objectForKey:@"id"];
    voteTemp.attachName=[dict objectForKey:@"attachName"];
    voteTemp.hasAttach=[[dict objectForKey:@"hasAttach"] boolValue];
    voteView.sVote=voteTemp;
    //self.navigationItem.title = @"返回";
    voteView.sClass=self.sClass;
    [self.navigationController pushViewController:voteView animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"cellvote";
    CellVote *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger row=[indexPath row];
    NSDictionary *rowDict=[self.listVote objectAtIndex:row];
    bool hasAttach=[[rowDict objectForKey:@"hasAttach"] boolValue];
    if (hasAttach) {
        cell.imgAttachFlag.image=[UIImage imageNamed: @"icon_attach.jpg"];
    }
    //NSDictionary *timeDict=[rowDict objectForKey:@"startTime"];
    cell.voteTitle.text=[rowDict objectForKey:@"title"];
    //cell.voteTime.text=[timeDict objectForKey:@"time"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (IBAction)btnCreateVote:(id)sender {

        if (self.listVote.count>=limitVote) {
            [CommonUtil ShowAlert:@"投票数量不足，请购买" withDelegate:self];
            return;
        }

    
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    CreateVoteViewController *createVote=(CreateVoteViewController*)[m instantiateViewControllerWithIdentifier:@"createvote"];
    createVote.sClass=self.sClass;
    [self.navigationController pushViewController:createVote animated:YES];
}
- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
