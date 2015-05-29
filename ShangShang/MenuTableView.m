//
//  TeacherMenuTableTableViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "MenuTableView.h"

@interface MenuTableView ()

@end

@implementation MenuTableView


- (void)viewDidLoad {
	[super viewDidLoad];
	//  self.listMenu = [NSArray arrayWithObjects: @"学生验证", @"投票管理", @"议题管理", @"学生列表",nil];
	// Uncomment the following line to preserve selection between presentations.
	// self.clearsSelectionOnViewWillAppear = NO;

	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.listMenu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	}
	NSInteger row = [indexPath row];
	cell.textLabel.text = [self.listMenu objectAtIndex:row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL selector = NSSelectorFromString(@"selectedTableRow:");

	if ([self.delegate respondsToSelector:selector]) {
		[self.delegate selectedTableRow:indexPath.row];
	}
}

@end
