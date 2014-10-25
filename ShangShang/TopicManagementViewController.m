//
//  TopicManagementViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-11.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "TopicManagementViewController.h"

@interface TopicManagementViewController ()

@end

@implementation TopicManagementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=@"议题管理";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = TITLE_SHANGSHANG;
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    self.listTopic=[CommonUtil restapi_GetTopicList:self.sClass.classId];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTopicCompletion:) name:@"CreateTopicCompletion" object:nil];
}

-(void)refreshTable{
    self.listTopic=[CommonUtil restapi_GetTopicList:self.sClass.classId];
    [self.tableView reloadData];
}

-(void)createTopicCompletion:(NSNotification*)notification{
    [self refreshTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listTopic count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row=[indexPath row];
    NSDictionary *dict=[self.listTopic objectAtIndex:row];
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ViewGroupTableViewController *viewGroup=(ViewGroupTableViewController*)[m instantiateViewControllerWithIdentifier:@"viewgroup"];
    viewGroup.topicID=[dict objectForKey:@"id"];
    self.navigationItem.title = @"返回";
    [self.navigationController pushViewController:viewGroup animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"CellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row=[indexPath row];
    NSDictionary *rowDict=[self.listTopic objectAtIndex:row];
    cell.textLabel.text=[rowDict objectForKey:@"topic"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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

- (IBAction)btnCreateTopic:(id)sender {
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    CreateTopicViewController *createTopic=(CreateTopicViewController*)[m instantiateViewControllerWithIdentifier:@"createtopic"];
    createTopic.sClass=self.sClass;
    [self.navigationController pushViewController:createTopic animated:YES];
}
- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
