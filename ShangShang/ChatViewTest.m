//
//  ChatViewTest.m
//  ShangShang
//
//  Created by 史东杰 on 14-10-25.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ChatViewTest.h"

@interface ChatViewTest ()

@end

@implementation ChatViewTest

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)update{
    [self.tView reloadData];
    if (self.messages.count>3) {
        NSIndexPath *lastRow = [NSIndexPath indexPathForRow:([self.messages count] - 1) inSection:0];
        [self.tView scrollToRowAtIndexPath:lastRow
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
    }
}

- (void)run{
    while (TRUE) {
        self.queryMsg=[CommonUtil restapi_ChatMessage:self.groupID];
        NSArray* arr=[self.queryMsg objectForKey:@"chatinfo"];
        self.messages=[[NSMutableArray alloc] initWithArray:arr];
        NSLog(@"%@",self.messages);
        [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:true];
        [NSThread sleepForTimeInterval:8.0];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=@"讨论组";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:animated];
}

-(void) keyboardDidShow: (NSNotification *)notif {
	if (keyboardVisible) {
		return;
	}
    
    [self.scrollView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 260-20, [UIScreen mainScreen].bounds.size.width, 44)];
    //self.scrollView.tintColor=[UIColor grayColor];
	keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif {
    
	if (!keyboardVisible) {
		return;
	}
    [self.scrollView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44, [UIScreen mainScreen].bounds.size.width, 44)];
	keyboardVisible = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tView.delegate=self;
    self.tView.dataSource=self;
    self.tView.separatorStyle=NO;
    self.message.delegate=self;
    self.messages = [[NSMutableArray alloc ] init];

    [self performSelectorInBackground:@selector(run) withObject:nil];
    //NSThread *queryThread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    //[queryThread setName:@"Thread-Query-Message"];
    //[queryThread start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",[self.messages count]);
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Bubble Cell";
    
    STBubbleTableViewCell *cell = (STBubbleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[STBubbleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = self.tView.backgroundColor;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
		cell.dataSource = self;
		cell.delegate = self;
	}
    NSInteger row=[indexPath row];
    NSDictionary *rowDict=[self.messages objectAtIndex:row];
	
	cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
	cell.textLabel.text = [rowDict objectForKey:@"messageContent"];
	cell.imageView.image = [UIImage imageNamed: @"default_phone.jpg"];;
	
    int sendid=[[rowDict objectForKey:@"senderId"] intValue];
    int myid=[[SSUser getInstance].userid intValue];
	if(sendid==myid)
	{
		cell.authorType = STBubbleTableViewCellAuthorTypeSelf;
		cell.bubbleColor = STBubbleTableViewCellBubbleColorGreen;
	}
	else
	{
		cell.authorType = STBubbleTableViewCellAuthorTypeOther;
		cell.bubbleColor = STBubbleTableViewCellBubbleColorGray;
	}
    
    return cell;
}

#pragma mark - STBubbleTableViewCellDataSource methods

- (CGFloat)minInsetForCell:(STBubbleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
		return 100.0f;
    }
    
	return 50.0f;
}

#pragma mark - STBubbleTableViewCellDelegate methods

- (void)tappedImageOfCell:(STBubbleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=[indexPath row];
    NSDictionary *rowDict=[self.messages objectAtIndex:row];
	NSLog(@"%@", [rowDict objectForKey:@"msg"]);
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)sendMessage:(id)sender {
    NSString *messageStr = self.message.text;
    
    if([messageStr length] > 0) {
        
        // send message through XMPP
        
        self.message.text = @"";
        NSString *userid=[SSUser getInstance].userid;
        //NSString *m = [NSString stringWithFormat:@"%@:%@", messageStr, @"you"];
        
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
        [m setObject:messageStr forKey:@"messageContent"];
        [m setObject:userid forKey:@"senderId"];
        
        [self.messages addObject:m];
        
        NSDictionary *body= [NSDictionary dictionaryWithObjectsAndKeys:
                             messageStr,@"messageContent",
                             self.groupID,@"smallGroupId",
                             userid,@"senderId",
                             nil];
        [CommonUtil restapi_SendChat:body];
        
        [self.tView reloadData];
        NSIndexPath *lastRow = [NSIndexPath indexPathForRow:([self.messages count] - 1) inSection:0];
        [self.tView scrollToRowAtIndexPath:lastRow
                                    atScrollPosition:UITableViewScrollPositionBottom
                                            animated:YES];
        [m release];
    }
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
    [_scrollView release];
    [_message release];
    [_tView release];
    [super dealloc];
}
@end
