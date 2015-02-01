//
//  ClassManagementViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-23.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ClassManagementViewController.h"
#import "ZBarSDK.h"
#import "CommonUtil.h"
#import "ClassMenuViewController.h"
@interface ClassManagementViewController ()

@end

@implementation ClassManagementViewController
@synthesize result = result_;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = TITLE_SHANGSHANG;
}

-(void)viewDidAppear:(BOOL)animated{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableClass setDataSource:self];
    [self.tableClass setDelegate:self];
    @try {
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        SSUser *user = [SSUser getInstance];
        
        NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/student/classes?id=%@",user.userid];
        NSData *response=[httpUtil SendGetRequest:url];
        if (response==nil) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"网络连接出错" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            self.listClass= [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            [self.tableClass reloadData];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SEARCHFROM=@"class";
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

- (IBAction)btnScan:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentViewController:reader animated:YES completion:^{}];
    [reader release];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol;
    for(symbol in results)
        break;
    //_imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *data=symbol.data;
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *obj=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    /*debug
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:data delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
     */

    [CommonUtil showWaiting:self.navigationController whileExecutingBlock:^{
        NSString *classid=[obj objectForKey:@"classid"];
        NSString *userid=[SSUser getInstance].userid;
        HttpUtil *httpUtil=[[HttpUtil alloc] init];
        
        NSString* url = @"SmurfWeb/rest/student/applyclass";
        NSDictionary* dic= [NSDictionary dictionaryWithObjectsAndKeys:
                            classid,@"classid",
                            userid,@"userid",
                            nil];
        self.result= [httpUtil SendPostRequest:url withBody:dic];
	} completionBlock:^{
        if ([self.result isEqualToString:@"-1"]) {
            //apply failed
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"加入失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            //register success
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"成功加入课程" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
	}];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listClass count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row=[indexPath row];
    NSDictionary *dict=[self.listClass objectAtIndex:row];
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassMenuViewController *classView=(ClassMenuViewController*)[m instantiateViewControllerWithIdentifier:@"classview"];
    SmurfClass *classTemp=[[SmurfClass alloc] init];
    classTemp.classId=[dict objectForKey:@"id"];
    classTemp.className=[dict objectForKey:@"name"];
    classTemp.teacherName=[dict objectForKey:@"userName"];
    classTemp.classDescription=[dict objectForKey:@"description"];
    
    classView.sClass=classTemp;
    self.navigationItem.title = @"返回";
    [self.navigationController pushViewController:classView animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"CellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row=[indexPath row];
    NSDictionary *rowDict=[self.listClass objectAtIndex:row];
    cell.textLabel.text=[rowDict objectForKey:@"name"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)dealloc {
    [_tableClass release];
    [super dealloc];
}
@end
