//
//  SearchClassViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-23.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchClassViewController : UIViewController<UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *listClass;
@property (nonatomic,assign)  NSString* from;
@property (retain, nonatomic) IBOutlet UITableView *tableClass;

- (void)filterContentForSearchText:(NSString*)searchText;
-(void)loadData:(NSString*)searchText;
@end
