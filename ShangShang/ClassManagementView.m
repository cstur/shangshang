//
//  TeacherClassManagementViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-4.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ClassManagementView.h"
#import "ClassViewController.h"
#import "ClassIndex.h"
@interface ClassManagementView ()

@end

@implementation ClassManagementView

- (void)viewWillAppear:(BOOL)animated {
	self.navigationItem.title = @"课程管理";
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView setDataSource:self];
	[self.tableView setDelegate:self];
	[self refreshTable];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createClassCompletion:) name:@"CreateClassCompletion" object:nil];
}

- (void)refreshTable {
	@try {
        NSMutableDictionary *user=[[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USER];
		NSString *url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/classes?id=%@", [user objectForKey:@"id"]];
		NSData *response = [[HttpUtil getInstance] SendGetRequest:url];
		NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		self.listClass = [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
	}
	@catch (NSException *exception)
	{
		NSLog(@"%@", exception);
	}
	[self.tableView reloadData];
}

- (void)createClassCompletion:(NSNotification *)notification {
	[self refreshTable];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	if ([identifier isEqualToString:@"seguecreateclass"]) {
		if (self.listClass.count >= limitClass) {
			[CommonUtil ShowAlert:@"课程数量不足，请购买" withDelegate:self];
			return false;
		}
	}
	return true;
}

- (void)dealloc {
	[_tableView release];
	[super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.listClass count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	NSDictionary *dict = [self.listClass objectAtIndex:row];
	UIStoryboard *m = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	ClassIndex *classView = (ClassIndex *)[m instantiateViewControllerWithIdentifier:@"teacherclassview"];
	classView.sClass = [dict mutableCopy];
	self.navigationItem.title = @"返回";
	[self.navigationController pushViewController:classView animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

	NSInteger row = [indexPath row];
	NSDictionary *rowDict = [self.listClass objectAtIndex:row];
	cell.textLabel.text = [rowDict objectForKey:@"name"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

@end
