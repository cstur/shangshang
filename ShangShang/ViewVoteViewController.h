//
//  ViewVoteViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-17.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "ViewOptionTableViewCell.h"
#import "VoteDetailTableViewController.h"
#import "MagicPieLayer.h"
#import "VoteSum.h"
#import "SmurfTableView.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

@class PieLayer;

@interface ViewVoteViewController : SmurfTableView

@property (nonatomic,assign)SSVote *sVote;
@property (nonatomic, strong) NSArray *listOption;
@property (nonatomic, strong) NSArray *listDetails;
@property (nonatomic, strong) NSMutableDictionary *friendlyName;

-(void)voteDetails;
-(void)voteSum;
-(void)pushVote;
-(void)release;
-(UIView*)getHeaderView:(NSString*)title withTable:(UITableView *)tableView;
@property (nonatomic, retain) MPMoviePlayerController* moviePlayer;
@end

@interface ViewVoteViewController (ex)
@property(nonatomic,readonly,retain) PieLayer *layer;
@end
