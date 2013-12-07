//
//  LMModalViewController.h
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 17/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMModalViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *characterCountLabel;
@property (nonatomic, strong) IBOutlet UITextView *tweetTextView;

@end
