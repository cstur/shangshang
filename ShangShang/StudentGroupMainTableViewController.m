//
//  StudentGroupMainTableViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-9-28.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "StudentGroupMainTableViewController.h"

@interface StudentGroupMainTableViewController ()

@end

@implementation StudentGroupMainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.labelGroupName.text=[NSString stringWithFormat:@"当前议题：%@",self.topicName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createGroupCompletion:) name:@"CreateGroupCompletion" object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)createGroupCompletion:(NSNotification*)notification{
    [self performSegueWithIdentifier: @"segueViewGroup" sender: self];
   /* UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewGroupTableViewController *newV=(ViewGroupTableViewController*)[m instantiateViewControllerWithIdentifier:@"viewgroup"];
    newV.topicID=self.topicID;
    [self presentViewController:newV animated:YES completion:^{}];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(BOOL)shouldAutorotate{
    return NO;
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row=[indexPath row];
    if (row==0) {
        
        UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CreateGroupViewController *newV=(CreateGroupViewController*)[m instantiateViewControllerWithIdentifier:@"creategroup"];
        
        [self presentViewController:newV animated:YES completion:^{}];
         
    }
    if (row==1) {
        
        UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SerachGroupTableViewController *newV=(SerachGroupTableViewController*)[m instantiateViewControllerWithIdentifier:@"searchgroup"];
        
        [self presentViewController:newV animated:YES completion:^{}];
        
    }
    if (row==2) {
        
        UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewGroupTableViewController *newV=(ViewGroupTableViewController*)[m instantiateViewControllerWithIdentifier:@"viewgroup"];
        
        [self presentViewController:newV animated:YES completion:^{}];
        
    }
}*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    // Use this to allow upside down as well
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    SEARCHFROM=@"group";

    if ([segue.identifier isEqualToString:@"segueCreateGroup"]) {
        CreateGroupViewController *createGroup=segue.destinationViewController;
        createGroup.topicID=self.topicID;
    }
    
    if ([segue.identifier isEqualToString:@"segueViewGroup"]) {
        ViewGroupTableViewController *viewGroup=segue.destinationViewController;
        viewGroup.topicID=self.topicID;
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    [_labelGroupName release];
    [super dealloc];
}
@end
