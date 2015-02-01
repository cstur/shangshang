//
//  ClassMenuViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ClassMenuViewController.h"

@interface ClassMenuViewController ()

@end

@implementation ClassMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=TITLE_SHANGSHANG;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //KEYBOARD OBSERVERS
    /************************/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    /************************/
    
    UIImage *faceImage = [UIImage imageNamed:@"icon_menu.png"];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake( 0, 0, 20 , 20 );
    [face addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
    [face setImage:faceImage forState:UIControlStateNormal];
    UIBarButtonItem *menuImageButon = [[UIBarButtonItem alloc] initWithCustomView:face];
    self.navigationItem.rightBarButtonItem = menuImageButon;
    [menuImageButon release];
}


-(void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = notification.userInfo;
    CGRect keyboardRect = [[info valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    
    //if the popover is present will be refreshed
    popover.keyboardHeight = _keyboardHeight;
    [popover setupView];
}

-(void)keyboardWillHide:(NSNotification*)notification {
    _keyboardHeight = 0.0;
    
    //if the popover is present will be refreshed
    popover.keyboardHeight = _keyboardHeight;
    [popover setupView];
}

-(void)menuClicked:(UIButton*)menuButton{
    [self popover:menuButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
//iOS6 implementation of the rotation
- (NSUInteger)supportedInterfaceOrientations
{
    //All orientations
    return UIInterfaceOrientationMaskAll;
}
- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    [visiblePopoverController dismissPopoverAnimated:YES];
}

-(IBAction)popover:(id)sender
{
    //NSLog(@"popover retain count: %d",[popover retainCount]);
    
    //SAFE_ARC_RELEASE(popover); popover=nil;
    
    //the controller we want to present as a popover
    //StudentMenuTableTableViewController *controller = [[StudentMenuTableTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StudentMenuTableTableViewController *controller = [m instantiateViewControllerWithIdentifier:@"menutable1"];
    controller.delegate = self;
    popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:controller];
    
    //popover.tint = FPPopoverDefaultTint;
    popover.tint = FPPopoverLightGrayTint;
    popover.keyboardHeight = _keyboardHeight;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(130, 150);
    }
    else {
        popover.contentSize = CGSizeMake(130, 150);
    }
    //if(sender == transparentPopover)
    //{
    // popover.alpha = 0.5;
    // }
    
    //  if(sender == _noArrow) {
    //no arrow
    // popover.arrowDirection = FPPopoverNoArrow;
    // [popover presentPopoverFromPoint: CGPointMake(self.view.center.x, self.view.center.y - popover.contentSize.height/2)];
    // }
    // else {
    //sender is the UIButton view
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    [popover presentPopoverFromView:sender];
    // }
    
}

-(IBAction)goToTableView:(id)sender
{
    //  FPDemoTableViewController *controller = [[FPDemoTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:nil animated:YES];
}

-(void)selectedTableRow:(NSUInteger)rowNum
{
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //self.navigationItem.title = @"返回";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if (rowNum==0) {
       StudentVoteViewController *stuVote=(StudentVoteViewController*)[m instantiateViewControllerWithIdentifier:@"stuvote"];
        stuVote.sClass=self.sClass;
        [self.navigationController pushViewController:stuVote animated:YES];
    }
    
    if (rowNum==1) {
        StudentTopicTableViewController *stuTopic=(StudentTopicTableViewController*)[m instantiateViewControllerWithIdentifier:@"stutopic"];
        stuTopic.sClass=self.sClass;
        [self.navigationController pushViewController:stuTopic animated:YES];
    }

    [popover dismissPopoverAnimated:YES];
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

@end
