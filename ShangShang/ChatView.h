//
//  ChatView.h
//  ShangShang
//
//  Created by 史东杰 on 14-10-25.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STBubbleTableViewCell.h"
@interface ChatView : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,STBubbleTableViewCellDataSource, STBubbleTableViewCellDelegate>
{
    BOOL keyboardVisible;   //键盘出现标识
}
@property (retain, nonatomic) IBOutlet UITableView *tView;
@property (retain, nonatomic) IBOutlet UITextField *messageField;
@property (strong, nonatomic) NSMutableArray *messages;
//@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)sendMessage:(id)sender;
@end
