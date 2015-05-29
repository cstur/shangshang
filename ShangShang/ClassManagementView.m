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
@synthesize result = result_;
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
		NSMutableDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USER];
		NSString *uid = [user objectForKey:@"id"];
		self.role = [[user objectForKey:@"role"] intValue];
		NSString *url = @"";
		if (self.role == ROLE_Teacher) {
			url = [NSString stringWithFormat:@"SmurfWeb/rest/teacher/classes?id=%@", uid];
		}
		else {
			url = [NSString stringWithFormat:@"SmurfWeb/rest/student/classes?id=%@", uid];
		}
		NSData *response = [[HttpUtil getInstance] SendGetRequest:url];

		if (response == nil) {
			[self showAlert:@"网络连接出错"];
		}
		else {
			NSString *newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
			self.listClass = [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
		}
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
		self.loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:SMURF_KEY_USER];
		if ([[self.loginUser objectForKey:@"cclass"] intValue] >= [[self.loginUser objectForKey:@"limitClass"] intValue]) {
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
	ClassIndex *classView = (ClassIndex *)[m instantiateViewControllerWithIdentifier:@"classview"];
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

- (IBAction)btnScan:(id)sender {
	ZBarReaderViewController *reader = [ZBarReaderViewController new];
	reader.readerDelegate = self;
	reader.supportedOrientationsMask = ZBarOrientationMaskAll;

	ZBarImageScanner *scanner = reader.scanner;

	[scanner setSymbology:ZBAR_I25
	               config:ZBAR_CFG_ENABLE
	                   to:0];

	[self presentViewController:reader animated:YES completion: ^{}];
	[reader release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	id <NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
	ZBarSymbol *symbol;
	for (symbol in results)
		break;
	//_imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];

	[picker dismissViewControllerAnimated:YES completion:nil];
	NSString *data = symbol.data;
	NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];

	/*debug
	   UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:data delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	   [alert show];
	 */

	[CommonUtil showWaiting:self.navigationController whileExecutingBlock: ^{
	    NSString *classid = [obj objectForKey:@"classid"];
	    NSString *userid = [SSUser getInstance].userid;
	    HttpUtil *httpUtil = [[HttpUtil alloc] init];

	    NSString *url = @"SmurfWeb/rest/student/applyclass";
	    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
	                         classid, @"classid",
	                         userid, @"userid",
	                         nil];
	    self.result = [httpUtil SendPostRequest:url withBody:dic];
	} completionBlock: ^{
	    if ([self.result isEqualToString:@"-1"]) {
	        //apply failed
	        [self showAlert:@"加入失败"];
		}
	    else {
	        //register success
	        [self showAlert:@"成功加入课程"];
		}
	}];
}

@end
