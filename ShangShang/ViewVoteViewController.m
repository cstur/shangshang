//
//  ViewVoteViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-17.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ViewVoteViewController.h"
@interface ViewVoteViewController ()

@end

@implementation ViewVoteViewController

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
    // Do any additional setup after loading the view.
    
    self.listOption= [CommonUtil restapi_GetVoteOptions:self.sVote.voteid];
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    NSArray* toolbarItems = [NSArray arrayWithObjects:
                             [[UIBarButtonItem alloc] initWithTitle:@"投票详情" style:UIBarButtonItemStyleBordered target:self action:@selector(voteDetails)] ,
                             [[UIBarButtonItem alloc] initWithTitle:@"投票汇总" style:UIBarButtonItemStyleBordered target:self action:@selector(voteSum)],
                             [[UIBarButtonItem alloc] initWithTitle:@"推送投票" style:UIBarButtonItemStyleBordered target:self action:@selector(pushVote)],
                             nil];
    [toolbarItems makeObjectsPerformSelector:@selector(release)];
    self.toolbarItems = toolbarItems;
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)voteDetails{
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    VoteDetailTableViewController *voteDetails=(VoteDetailTableViewController*)[m instantiateViewControllerWithIdentifier:@"votedetail"];
    [self.navigationController pushViewController:voteDetails animated:YES];
}
-(void)voteSum{

}
-(void)pushVote{
    [CommonUtil restapi_PushVote:self.sClass.classId];
    /*
    [[[UIAlertView alloc] initWithTitle:@"Message" message:
      [[NSString alloc] initWithData:@"推送成功" encoding:
       NSUTF8StringEncoding] delegate:self
                      cancelButtonTitle:@"确定" otherButtonTitles:nil]
     show];*/
}
-(void)release{}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listOption.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"optioncell";
    ViewOptionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger row=[indexPath row];
    NSDictionary *rowDict=[self.listOption objectAtIndex:row];
    cell.labelContent.text=[rowDict objectForKey:@"optionContent"];
    NSString *count=[rowDict objectForKey:@"polledCount"];
    cell.labelCount.text=[NSString stringWithFormat:@"%@ 投票",count];
    NSString* isAnswer=[rowDict objectForKey:@"isAnswer"];
    if ([isAnswer boolValue]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    label.textAlignment=NSTextAlignmentCenter;
    /* Section header is in 0th index... */
    [label setText:self.sVote.title];
    [view addSubview:label];

    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
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

@end
