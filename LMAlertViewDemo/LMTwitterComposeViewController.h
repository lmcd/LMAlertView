//
//  LMTwitterComposeViewController.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 17/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMFixedTextView.h"

@interface LMTwitterComposeViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *characterCountLabel;
@property (nonatomic, strong) IBOutlet LMFixedTextView *tweetTextView;

- (void)setLocationTitle:(NSString *)locationTitle;

@end
