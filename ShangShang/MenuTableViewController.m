////
////  MenuTableViewController.m
////  ShangShang
////
////  Created by 史东杰 on 14-8-3.
////  Copyright (c) 2014年 aopai.ios. All rights reserved.
////
//
//#import "MenuTableViewController.h"
//#import "GroupTableViewController.h"
//@interface MenuTableViewController ()
//
//@end
//
//@implementation MenuTableViewController
//@synthesize delegate=_delegate;
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.listMenu = [NSArray arrayWithObjects: @"讨论组", @"微视频", @"课程投票",nil];
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
//    
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//#pragma mark - Table view data source
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.listMenu count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if(cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//    }
//    NSInteger row=[indexPath row];
//    //NSDictionary *rowDict=[self.listMenu objectAtIndex:row];
//    //cell.textLabel.text=[rowDict objectForKey:@"name"];
//    cell.textLabel.text=[self.listMenu objectAtIndex:row];
//    
//    return cell;
//}
//
//
//#pragma mark - Table view delegate
///*
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger row=[indexPath row];
//    NSDictionary *dict=[self.listMenu objectAtIndex:row];
//    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    GroupTableViewController *groupView=(GroupTableViewController*)[m instantiateViewControllerWithIdentifier:@"groupview"];
//    
//    self.navigationItem.title = @"返回";
//    [self.navigationController pushViewController:groupView animated:YES];
//}*/
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if([self.delegate respondsToSelector:@selector(selectedTableRow:)])
//    {
//        [self.delegate selectedTableRow:indexPath.row];
//    }
//}
//
///*
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}
//*/
//
///*
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/
//
///*
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}
//*/
//
///*
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//}
//*/
//
///*
//// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}
//*/
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
