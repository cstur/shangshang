//
//  PendingClassViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-30.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "GeneralTableView.h"
#import "CommonUtil.h"
@interface GeneralTableView ()

@end

@implementation GeneralTableView

- (void)viewWillAppear:(BOOL)animated {
	if (self.smurfTitle == nil) {
		self.smurfTitle = [[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_TITLE];
	}
	self.navigationItem.title = self.smurfTitle;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	//NSString* uid=[[[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USER] objectForKey:@"id"];
	//NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/student/unreadyclasses?id=%@",uid];
	self.dataList = [[HttpUtil getInstance] getArrayData:self.smurfURI];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

	NSInteger row = [indexPath row];
	NSDictionary *rowDict = [self.dataList objectAtIndex:row];
	cell.textLabel.text = [rowDict objectForKey:@"name"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	NSDictionary *dict = [self.dataList objectAtIndex:row];
	UIStoryboard *m = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	ClassIndex *classView = (ClassIndex *)[m instantiateViewControllerWithIdentifier:@"classview"];
	classView.sClass = [dict mutableCopy];
    //classView.hideMenu=1;
	self.navigationItem.title = @"返回";
	[self.navigationController pushViewController:classView animated:YES];
}

- (IBAction)btnBack:(id)sender {
	UIStoryboard *m = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	UINavigationController *newV = (UINavigationController *)[m instantiateViewControllerWithIdentifier:@"navstudent"];

	[self presentViewController:newV
	                   animated:YES
	                 completion:nil];
}

@end
