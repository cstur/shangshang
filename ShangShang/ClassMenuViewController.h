//
//  ClassMenuViewController.h
//  ShangShang
//
//  Created by 史东杰 on 14-8-10.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "ClassViewController.h"
#import "FPPopoverController.h"
#import "ARCMacros.h"
#import "FPPopoverKeyboardResponsiveController.h"
#import "MenuTableViewController.h"
#import "StudentVoteViewController.h"
#import "StudentTopicTableViewController.h"

@interface ClassMenuViewController : ClassViewController<FPPopoverControllerDelegate>
{
    FPPopoverKeyboardResponsiveController *popover;
    CGFloat _keyboardHeight;
}
-(void)menuClicked:(UIButton*)menuButton;
-(void)popover:(id)sender;
-(void)selectedTableRow:(NSUInteger)rowNum;
@end
