//
//  VoteSum.m
//  ShangShang
//
//  Created by 史东杰 on 14-10-30.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "VoteSum.h"

@interface VoteSum ()

@end

@implementation VoteSum

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(export)];
    self.navigationItem.rightBarButtonItem = exportButton;
    [exportButton release];
    
    self.slices = [NSMutableArray arrayWithCapacity:10];
    

    for (int i=0; i<self.listOption.count; i++) {
        int temp=0;
        NSDictionary *row=[self.listOption objectAtIndex:i];
        NSString* currentID=[row objectForKey:@"id"];
        for (int j=0; j<self.listDetails.count; j++) {
            NSDictionary *rowDict=[self.listDetails objectAtIndex:j];
            NSArray *selectOption=[rowDict objectForKey:@"selectedOptions"];
            for (int k=0; k<selectOption.count; k++) {
                NSDictionary *rowOption=[self.listOption objectAtIndex:j];
                NSString *optionid=[rowOption objectForKey:@"id"];
                if (currentID==optionid) {
                    temp++;
                }
            }
        }
        NSNumber *one = [NSNumber numberWithInt:temp];
        [_slices addObject:one];
    }
    
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_PI_2];
    [self.pieChart setAnimationSpeed:1.0];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    [self.pieChart setLabelRadius:160];
    [self.pieChart setShowPercentage:YES];
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChart setPieCenter:CGPointMake(160, 260)];
    [self.pieChart setUserInteractionEnabled:NO];
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];
    
    
    [self.percentLabel.layer setCornerRadius:90];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    //rotate up arrow
    //self.downArrow.transform = CGAffineTransformMakeRotation(M_PI);
}

-(void)export{
    @try {
        NSURL * documentsDirectory = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
        NSURL *file = [documentsDirectory URLByAppendingPathComponent:@"export.xls"];
        
        NSMutableString* string =[[NSMutableString alloc] init];
        [string appendString:@"<table><tr><td>姓名</td><td>选择内容</td></tr>"];
        for (int j=0; j<self.listDetails.count; j++) {
            NSDictionary *rowDict=[self.listDetails objectAtIndex:j];
            NSArray *selectOption=[rowDict objectForKey:@"selectedOptions"];
            NSArray *nickName=[rowDict objectForKey:@"userNickName"];
            for (int k=0; k<selectOption.count; k++) {
                NSDictionary *rowOption=[self.listOption objectAtIndex:j];
                NSString *content=[rowOption objectForKey:@"optionContent"];
                [string appendString:[NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td></tr>",nickName,content]];
            }
        }
        [string appendString:@"</table>"];
        NSData *data1=[NSKeyedArchiver archivedDataWithRootObject:string];
        [data1 writeToFile:file.path atomically:YES];
        [CommonUtil ShowAlert:@"文件export.xls导出成功" withDelegate:self];
    }
    @catch (NSException *exception) {
        [CommonUtil ShowAlert:@"导出失败" withDelegate:self];
    }
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

- (void)dealloc {
    [_pieChart release];
    [_percentLabel release];
    [super dealloc];
}


- (void)viewDidUnload
{
    [self setPieChart:nil];
    [self setPercentLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChart reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
    //self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}
@end
