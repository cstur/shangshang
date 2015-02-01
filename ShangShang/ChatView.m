//
//  ChatView.m
//  ShangShang
//
//  Created by 史东杰 on 14-10-25.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ChatView.h"

@interface ChatView ()

@end

@implementation ChatView


-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=@"讨论组";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidShowNotification object:nil];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.scrollView.contentSize = CGSizeMake(320, 600);
    //self.scrollView.contentSize =[UIScreen mainScreen].bounds.size;
    self.tView.delegate=self;
    self.tView.dataSource=self;
    self.tView.separatorStyle=NO;
    self.messageField.delegate=self;
    self.messages = [[NSMutableArray alloc ] init];
    //[self.messageField becomeFirstResponder];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: UIKeyboardDidHideNotification object:nil];
    
    [super viewWillDisappear:animated];
}

-(void) keyboardDidShow: (NSNotification *)notif {
	if (keyboardVisible) {
		return;
	}

	NSDictionary* info = [notif userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
    
    
	//CGRect viewFrame = self.scrollView.frame;
    CGRect viewFrame=self.view.frame;
	viewFrame.size.height -= (keyboardSize.height);
	//self.scrollView.frame = viewFrame;
	
    //CGRect textFieldRect = [self.messageField frame];
    //[self.scrollView scrollRectToVisible:textFieldRect animated:YES];
    
	keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif {
    
    NSDictionary* info = [notif userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
    //CGRect viewFrame = self.scrollView.frame;
    CGRect viewFrame=self.view.frame;
	viewFrame.size.height += keyboardSize.height;
	//self.scrollView.frame = viewFrame;
    CGRect textFieldRect = [self.tView frame];
	//[self.scrollView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
	if (!keyboardVisible) {
		return;
	}
    
	keyboardVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
	cell.textLabel.text = [rowDict objectForKey:@"msg"];
	cell.imageView.image = [UIImage imageNamed: @"default_phone.jpg"];;
	
    // Put your own logic here to determine the author
	if(indexPath.row % 2 != 0 || indexPath.row == 4)
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
    /*
    static NSString *CellIdentifier=@"CellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row=[indexPath row];
    NSDictionary *rowDict=[self.messages objectAtIndex:row];
    cell.textLabel.text=[rowDict objectForKey:@"msg"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;*/
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

- (void)dealloc {
    [_tView release];
    [_messageField release];
    //[_scrollView release];
    [super dealloc];
}

- (IBAction)sendMessage:(id)sender {
    NSString *messageStr = self.messageField.text;
    
    if([messageStr length] > 0) {
        
        // send message through XMPP
        
        self.messageField.text = @"";
        
        //NSString *m = [NSString stringWithFormat:@"%@:%@", messageStr, @"you"];
        
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
        [m setObject:messageStr forKey:@"msg"];
        [m setObject:@"you" forKey:@"sender"];
        
        [self.messages addObject:m];
        [self.tView reloadData];
        [m release];
    }
}
@end
