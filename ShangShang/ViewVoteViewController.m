//
//  ViewVoteViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-8-17.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ViewVoteViewController.h"


@interface ViewVoteViewController ()

@end

@implementation ViewVoteViewController
@synthesize moviePlayer = _moviePlayer;
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

    self.listOption= [CommonUtil restapi_GetVoteOptions:self.sVote.voteid];
    self.friendlyName=[NSMutableDictionary dictionaryWithCapacity:10];
    int count = self.listOption.count;//减少调用次数
    for( int i=0; i<count; i++){
        NSDictionary *rowDict= [self.listOption objectAtIndex:i];
        [self.friendlyName setObject:[CommonUtil getTagName:i] forKey:[rowDict objectForKey:@"id"]];
    }
    
    self.listDetails=[CommonUtil iosapi_VoteDetails:self.sVote.voteid withClassID:[self.sClass objectForKey:@"id"]];
}

- (void)viewWillAppear:(BOOL)animated
{

    UIBarButtonItem *attachButton=[self getBarButton:@"查看附件" withImage:[UIImage imageNamed:@"attach"] action:@selector(viewAttach)];
    
    UIBarButtonItem *voteButton=[self getBarButton:@"投票汇总" withImage:[UIImage imageNamed:@"pie"] action:@selector(voteSum)];
    
    UIBarButtonItem *pushButton=[self getBarButton:@"推送投票" withImage:[UIImage imageNamed:@"push"] action:@selector(pushVote)];
    
    NSArray* toolbarItems = [NSArray arrayWithObjects:voteButton,pushButton,attachButton,nil];
    
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
- (UIImage *)imageByScalingToSize:(UIImage*)image withSize:(CGSize)targetSize
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}

-(void)voteDetails{
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    VoteDetailTableViewController *voteDetails=(VoteDetailTableViewController*)[m instantiateViewControllerWithIdentifier:@"votedetail"];
    [self.navigationController pushViewController:voteDetails animated:YES];
}
-(void)voteSum{
    UIStoryboard *m=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VoteSum *sumView=(VoteSum*)[m instantiateViewControllerWithIdentifier:@"votesum"];
    sumView.listDetails=self.listDetails;
    sumView.listOption=self.listOption;
    [self.navigationController pushViewController:sumView animated:YES];
}

-(void)viewAttach{
    if (self.sVote.hasAttach) {
        if ([self.sVote.attachName rangeOfString:@".mov"].location==NSNotFound) {
            UIImage *img=[CommonUtil getAttach:self.sVote.voteid withFileName:self.sVote.attachName];
            [self showImage:img];
        }
        else{
            [self viewVideo];
        }
        
        
    }else{
        [CommonUtil ShowAlert:@"这个投票没有附件" withDelegate:self];
    }
}

-(void)viewVideo{

    NSString *urlStr=[NSString stringWithFormat:@"http://%@/SmurfWeb/users/%@/video/%@",[ServerIP getConfigIP],[SSUser getInstance].userid,self.sVote.attachName];
    NSLog(@"%@",urlStr);
    NSString *videoPath= [CommonUtil downloadVideo:urlStr withFileName:self.sVote.attachName];
    if (![videoPath isEqualToString:@""]) {
        self.moviePlayer = [[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPath]] autorelease];
        self.moviePlayer.view.frame = self.view.bounds;
        [self.view addSubview:self.moviePlayer.view];
        self.moviePlayer.fullscreen = YES;
        self.moviePlayer.scalingMode = MPMovieScalingModeFill;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.moviePlayer];
        [self.moviePlayer play];
    }
}

-(void)movieFinishedCallback:(NSNotification*)notify {
    MPMoviePlayerController* theMovie = [notify object];
    
    [[NSNotificationCenter
      defaultCenter] removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:theMovie];
    
    [theMovie.view removeFromSuperview];
    [theMovie release];
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

-(void)pushVote{
    [CommonUtil restapi_PushVote:[self.sClass objectForKey:@"id"]];
    [CommonUtil ShowAlert:@"推送已发出" withDelegate:self];
}
-(void)release{}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.listOption.count;
    }
    else{
        return self.listDetails.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *CellIdentifier=@"optioncell";
        ViewOptionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSInteger row=[indexPath row];
        NSDictionary *rowDict=[self.listOption objectAtIndex:row];
        cell.labelContent.text=[NSString stringWithFormat:@"%@. %@",[CommonUtil getTagName:row], [rowDict objectForKey:@"optionContent"]];
        NSString *count=[rowDict objectForKey:@"polledCount"];
        cell.labelCount.text=[NSString stringWithFormat:@"%@ 投票",count];
        NSString* isAnswer=[rowDict objectForKey:@"isAnswer"];
        if ([isAnswer boolValue]) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        return cell;
    }else{
        static NSString *CellIdentifier=@"CellIdentifier";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSInteger row=[indexPath row];
        NSDictionary *rowDict=[self.listDetails objectAtIndex:row];
        NSArray *selectOption=[rowDict objectForKey:@"selectedOptions"];
        NSMutableString *result=[[NSMutableString alloc] init];
        for( int i=0; i<selectOption.count; i++){
            NSDictionary *rowOption= [selectOption objectAtIndex:i];
            NSString *optionid=[rowOption objectForKey:@"id"];
            NSString *tag= [self.friendlyName objectForKey:optionid];
            [result appendString:tag];
        }
        cell.textLabel.text=[NSString stringWithFormat:@"［%@］选择了［%@］",[rowDict objectForKey:@"userNickName"],result];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return [self getHeaderView:self.sVote.title withTable:tableView];
    }
    else{
        return [self getHeaderView:@"投票详情" withTable:tableView];
    }
}

-(UIView*)getHeaderView:(NSString*)title withTable:(UITableView *)tableView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    label.textAlignment=NSTextAlignmentCenter;
    [label setText:title];
    [view addSubview:label];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (void)setup
{
    self.layer.maxRadius = 100;
    self.layer.minRadius = 20;
    self.layer.animationDuration = 0.6;
    self.layer.showTitles = ShowTitlesIfEnable;
    if ([self.layer.self respondsToSelector:@selector(setContentsScale:)])
    {
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
    }
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer*)tap
{
    if(tap.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint pos = [tap locationInView:tap.view];
    PieElement* tappedElem = [self.layer pieElemInPoint:pos];
    if(!tappedElem)
        return;
    
    if(tappedElem.centrOffset > 0)
        tappedElem = nil;
    [PieElement animateChanges:^{
        for(PieElement* elem in self.layer.values){
            elem.centrOffset = tappedElem==elem? 20 : 0;
        }
    }];
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

@end
