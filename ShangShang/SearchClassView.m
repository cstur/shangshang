//
//  SearchClassViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-23.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "SearchClassView.h"
#import "CommonUtil.h"
#import "ClassIndex.h"
@interface SearchClassView ()

@end

@implementation SearchClassView

- (void)viewDidLoad {
	[super viewDidLoad];
    NSString *searchFlag = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchFlag"];
	if ([searchFlag isEqualToString:@"class"]) {
		self.navigationItem.title = @"查询课程";
	}
	else if ([searchFlag isEqualToString:@"group"]) {
		self.navigationItem.title = @"查询讨论组";
	}

	[self.tableClass setDataSource:self];
	[self.tableClass setDelegate:self];

	//设定搜索栏ScopeBar隐藏
	[self.searchBar setShowsScopeBar:YES];
	[self.searchBar sizeToFit];
	if ([searchFlag isEqualToString:@"group"]) {
		self.searchBar.placeholder = @"请输入讨论组名称";
	}
}

- (void)loadData:(NSString *)searchText {
	NSString *trimmedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *searchFlag = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchFlag"];
	if (trimmedString.length <= 0) {
		return;
	}
	@try {
		NSString *url = @"";

		if ([searchFlag isEqualToString:@"class"]) {
			url = [NSString stringWithFormat:@"SmurfWeb/rest/student/searchclasses?searchtext=%@", trimmedString];
		}
		else if ([searchFlag isEqualToString:@"group"]) {
			url = [NSString stringWithFormat:@"SmurfWeb/rest/student/searchgroups?topicid=%@", trimmedString];
		}

		url = [url stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
		NSData *response = [[HttpUtil getInstance] SendGetRequest:url];
		if (response == nil) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"网络连接出错" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
		}
		else {
			NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
			self.listClass = [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
			[self.tableClass reloadData];
		}
	}
	@catch (NSException *exception)
	{
		NSLog(@"%@", exception);
	}
}

- (void)viewDidUnload {
	[self setSearchBar:nil];
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString *)searchText;
{
	if ([searchText length] == 0) {
		return;
	}

	[self loadData:searchText];
}

#pragma mark --UITableViewDataSource 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.listClass count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}

	NSUInteger row = [indexPath row];
	NSDictionary *rowDict = [self.listClass objectAtIndex:row];
	cell.textLabel.text =  [rowDict objectForKey:@"name"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *searchFlag = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchFlag"];
	if ([searchFlag isEqualToString:@"class"]) {
		NSInteger row = [indexPath row];
		NSDictionary *dict = [self.listClass objectAtIndex:row];
		UIStoryboard *m = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		ClassIndex *applyclassView = (ClassIndex *)[m instantiateViewControllerWithIdentifier:@"applyclassview"];
        //applyclassView.hideMenu=1;
		applyclassView.sClass = [dict mutableCopy];
		self.navigationItem.title = @"返回";
		[self.navigationController pushViewController:applyclassView animated:YES];
	}
	else if ([searchFlag isEqualToString:@"group"]) {
	}
}

#pragma mark --UISearchBarDelegate 协议方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	NSMutableArray *emptyArray = [NSMutableArray new];
	self.listClass = emptyArray;
	[self.tableClass reloadData];
}

#pragma mark - UISearchDisplayController Delegate Methods
//当文本内容发生改变时候，向表视图数据源发出重新加载消息
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	[self filterContentForSearchText:searchString];
	//YES情况下表视图可以重新加载
	return YES;
}

// 当Scope Bar选择发送变化时候，向表视图数据源发出重新加载消息
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
	[self filterContentForSearchText:self.searchBar.text];
	// YES情况下表视图可以重新加载
	return YES;
}

- (void)dealloc {
	[_searchBar release];
	[_tableClass release];
	[super dealloc];
}

@end
