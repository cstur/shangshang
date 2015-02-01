//
//  ChatViewTest.h
//  ShangShang
//
//  Created by 史东杰 on 14-10-25.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STBubbleTableViewCell.h"
#import "CommonUtil.h"

@interface ChatViewTest : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,STBubbleTableViewCellDataSource, STBubbleTableViewCellDelegate>
{
    BOOL keyboardVisible;   //键盘出现标识
}

@property (retain, nonatomic) IBOutlet UIToolbar *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *message;
@property (retain, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSDictionary *queryMsg;
@property (nonatomic, retain) NSString *groupID;

- (IBAction)sendMessage:(id)sender;
- (void)run;
-(void)update;
@end
