//
//  StudentViewVoteTableViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-9-26.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "StudentViewVoteTableViewController.h"

@interface StudentViewVoteTableViewController ()

@end

@implementation StudentViewVoteTableViewController

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
    
    self.listOption= [CommonUtil restapi_Student_GetVoteOptions:self.sVote.voteid];
    int count=0;
    for (int i = 0; i < [self.listOption count]; i++) {
        NSDictionary *rowDict = [self.listOption objectAtIndex:i];
        BOOL isAnswer=[[rowDict objectForKey:@"isAnswer"] boolValue];
        if (isAnswer) {
            count++;
        }
    }
    if (count>1) {
        singleSelect=false;
    }else{singleSelect=true;}
    
    self.listRecords=[CommonUtil restapi_Student_GetVoteRecord:[SSUser getInstance].userid andVoteId:self.sVote.voteid];
    
    if (self.listRecords.count>0) {
        hasSelect=true;
    }else{
        hasSelect=false;
    }
}

-(void)viewWillAppear:(BOOL)animated{
        UIBarButtonItem *attachButton=[self getBarButton:@"查看附件" withImage:[UIImage imageNamed:@"attach"] action:@selector(viewAttach)];

    NSArray* toolbarItems = [NSArray arrayWithObjects:attachButton,nil];
    
    [toolbarItems makeObjectsPerformSelector:@selector(release)];
    self.toolbarItems = toolbarItems;
    
    [self.navigationController setToolbarHidden:NO];
    
    CGFloat customToolbarHeight = 60;
    [self.navigationController.toolbar setFrame:CGRectMake(0, self.view.frame.size.height - customToolbarHeight, self.view.frame.size.width, customToolbarHeight)];
}

-(UIBarButtonItem*)getBarButton:(NSString*)text withImage:(UIImage*)image action:(SEL)ac{
    UIButton *yourButton = [UIButton buttonWithType:UIButtonTypeCustom];
    yourButton.frame = CGRectMake(140, 40, 58, 58);
    [yourButton addTarget:self action:ac forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(17, 9, 24, 24)];
    imageView1.image =image;
    [yourButton addSubview:imageView1];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 43, yourButton.frame.size.width, 14)];
    label.text = text;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[label.font fontWithSize:14];
    [yourButton addSubview:label];
    
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:yourButton];
    
    return customBarButtonItem;
}

-(void)viewAttach{
    if (self.sVote.hasAttach) {
        if ([self.sVote.attachName rangeOfString:@".mov"].location==NSNotFound) {
            UIImage *img=[CommonUtil getAttach:self.sVote.voteid withFileName:self.sVote.attachName];
            [self showImage:img];
        }
        else{
            [CommonUtil ShowAlert:@"暂时无法查看视频" withDelegate:self];
        }
    }else{
        [CommonUtil ShowAlert:@"这个投票没有附件" withDelegate:self];
    }
}

-(void)showImage:(UIImage *)image{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image=image;
    imageView.tag=1;
    
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [imageView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        //backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    //UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        //imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (hasSelect) {
        return;
    }
    
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    if (singleSelect) {
        for (int i = 0; i <= [self.listOption count]; i++) {
            UITableViewCell *temp = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            temp.accessoryType = UITableViewCellAccessoryNone;
            currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }else{
        if (currentCell.accessoryType == UITableViewCellAccessoryNone)
        {
            currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else{
            currentCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

- (void)submitVote{
    
    SPollVote *vote=[SPollVote alloc];
    vote.userid=[SSUser getInstance].userid;
    
    NSMutableArray *optionTemp=[[NSMutableArray alloc] init];
    for (int i = 0; i < [self.listOption count]; i++) {
        id myArrayElement = [self.listOption objectAtIndex:i];
        /*
         SSVoteOption *op=[SSVoteOption alloc];
         op.optionId=@"0";
         op.optionContent=myArrayElement;
         op.polledCount=@"0";
         op.voteId=self.sVote.voteid;  */
        NSIndexPath *cellPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *row=[self.tableView cellForRowAtIndexPath:cellPath];
        
        if (row.accessoryType==UITableViewCellAccessoryCheckmark) {
            [optionTemp addObject:myArrayElement];
        }
        
    }
    NSArray *body = [optionTemp copy];
    vote.options=body;
    
    bool result=[CommonUtil restapi_PollVote:vote.dictionary];
    if (result) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"提交失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    if (!hasSelect) {
    UIButton *btnSubmitVote=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSubmitVote setTitle:@"提交" forState:UIControlStateNormal];
    [btnSubmitVote addTarget:self action:@selector(submitVote) forControlEvents:UIControlEventTouchUpInside];
    btnSubmitVote.frame=CGRectMake(10, 10, 280, 30);
    UIColor *currentColor=[UIColor colorWithRed:255/255.f
                                          green:190/255.f
                                           blue:56/255.f
                                          alpha:255/255.f];
    [btnSubmitVote setBackgroundColor:currentColor];
    [btnSubmitVote setCenter:footerView.center];
    [footerView addSubview:btnSubmitVote];
    

    }
    //[btnSubmitVote setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    //[btnSubmitVote setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"CellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row=[indexPath row];
    NSDictionary *rowDict=[self.listOption objectAtIndex:row];
    cell.textLabel.text=[rowDict objectForKey:@"optionContent"];
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    int optionid=[[rowDict objectForKey:@"id"] intValue];
    if (hasSelect) {
        for (int i=0; i<self.listRecords.count; i++) {
            NSDictionary *rowDictRecord=[self.listRecords objectAtIndex:i];
            int tempid=[[rowDictRecord objectForKey:@"id"] intValue];
            if (tempid==optionid) {
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
                break;
            }
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    label.textAlignment=NSTextAlignmentCenter;
    NSString *title=@"";
    if (hasSelect) {
        title=[NSString stringWithFormat:@"%@(已经投票)",self.sVote.title];
    }else{
    if (singleSelect) {
        title=[NSString stringWithFormat:@"%@(单选)",self.sVote.title];
    }else{
        title=[NSString stringWithFormat:@"%@(多选)",self.sVote.title];
    }}
    
    [label setText:title];
    [view addSubview:label];
    
    return view;
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

@end
