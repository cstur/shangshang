//
//  PendingClassViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-30.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "PendingClassViewController.h"
#import "CommonUtil.h"
@interface PendingClassViewController ()

@end

@implementation PendingClassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=@"待审批课程";
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        SSUser *user = [SSUser getInstance];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/student/unreadyclasses?id=%@",user.userid];
        NSData *response=[httpUtil SendGetRequest:url];
        NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        self.listPendingClass= [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listPendingClass count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"CellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row=[indexPath row];
    NSDictionary *rowDict=[self.listPendingClass objectAtIndex:row];
    cell.textLabel.text=[rowDict objectForKey:@"name"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row=[indexPath row];
    NSDictionary *dict=[self.listPendingClass objectAtIndex:row];
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassViewController *classView=(ClassViewController*)[m instantiateViewControllerWithIdentifier:@"classview1"];
    SmurfClass *classTemp=[[SmurfClass alloc] init];
    classTemp.classId=[dict objectForKey:@"id"];
    classTemp.className=[dict objectForKey:@"name"];
    classTemp.teacherName=[dict objectForKey:@"userName"];
    classTemp.classDescription=[dict objectForKey:@"description"];
    
    classView.sClass=classTemp;
    self.navigationItem.title = @"返回";
    [self.navigationController pushViewController:classView animated:YES];
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

- (IBAction)btnBack:(id)sender {
    SSUser *user=[SSUser getInstance];
    user.needUpdateFace=@"1";
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *newV=(UINavigationController*)[m instantiateViewControllerWithIdentifier:@"navstudent"];
    
    [self presentViewController:newV
                       animated:YES
                     completion:nil];

}
@end
