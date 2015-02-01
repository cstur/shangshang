//
//  TeacherClassManagementViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-4.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "TeacherClassManagementViewController.h"
#import "ClassViewController.h"
@interface TeacherClassManagementViewController ()

@end

@implementation TeacherClassManagementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = TITLE_SHANGSHANG;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self refreshTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createClassCompletion:) name:@"CreateClassCompletion" object:nil];
}

-(void)refreshTable{
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        SSUser *user = [SSUser getInstance];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/classes?id=%@",user.userid];
        NSData *response=[httpUtil SendGetRequest:url];
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        self.listClass= [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    [self.tableView reloadData];
}

-(void)createClassCompletion:(NSNotification*)notification{
    [self refreshTable];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"seguecreateclass"]) {
        if (self.listClass.count>=limitClass) {
            [CommonUtil ShowAlert:@"课程数量不足，请购买" withDelegate:self];
            return false;
        }
    }
    return true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listClass count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row=[indexPath row];
    NSDictionary *dict=[self.listClass objectAtIndex:row];
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TeacherClassMainViewController *classView=(TeacherClassMainViewController*)[m instantiateViewControllerWithIdentifier:@"teacherclassview"];
    SmurfClass *classTemp=[[SmurfClass alloc] init];
    classTemp.classId=[dict objectForKey:@"id"];
    classTemp.className=[dict objectForKey:@"name"];
    classTemp.classDescription=[dict objectForKey:@"description"];
    classTemp.capacity=[dict objectForKey:@"capacity"];
    classView.sClass=classTemp;
    self.navigationItem.title = @"返回";
    [self.navigationController pushViewController:classView animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"CellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row=[indexPath row];
    NSDictionary *rowDict=[self.listClass objectAtIndex:row];
    cell.textLabel.text=[rowDict objectForKey:@"name"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
@end
