//
//  LMModalViewController.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 17/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMModalViewController.h"

@interface LMModalViewController ()

@end

@implementation LMModalViewController

- (void)viewWillAppear:(BOOL)animated
{
	if (!animated) {
		[self.tweetTextView becomeFirstResponder];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	if (animated) {
		[self.tweetTextView becomeFirstResponder];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 137.0, self.view.frame.size.width, 1.0)];
	lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	UIView *lineViewInner = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.5, self.view.frame.size.width, 0.5)];
	// This is the default UITableView separator color
	lineViewInner.backgroundColor = [UIColor colorWithHue:360/252 saturation:0.02 brightness:0.80 alpha:1];
	lineViewInner.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[lineView addSubview:lineViewInner];
	
	[self.headerView addSubview:lineView];
	
	NSRange substringRange = [self.tweetTextView.text rangeOfString:@" #lmalertview"];
	self.tweetTextView.selectedRange = NSMakeRange(substringRange.location, 0);
}

- (IBAction)cancelButtonTapped:(id)sender
{
	[self.tweetTextView resignFirstResponder];
	[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
	NSUInteger remainingCharacters = 140 - textView.text.length;
	self.characterCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)remainingCharacters];
	
	self.navigationItem.rightBarButtonItem.enabled = (remainingCharacters >= 0);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	NSRange substringRange = [textView.text rangeOfString:@"#lmalertview"];
	if (range.location >= substringRange.location && range.location <= substringRange.location + substringRange.length) {
		return NO;
	}

    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
	NSRange range = textView.selectedRange;
	NSRange suffixRange = [self.tweetTextView.text rangeOfString:@" #lmalertview"];
	
	// IF the start of the selection is past the hashtag suffix
	if (range.location > suffixRange.location) {
		self.tweetTextView.selectedRange = NSMakeRange(suffixRange.location, 0);
	}
	// If the end of the selection crosses over into the hashtag suffix
	else if (range.location + range.length > suffixRange.location) {
		int length = [textView.text length] - suffixRange.length - range.location;
		self.tweetTextView.selectedRange = NSMakeRange(range.location, length);
	}
}

- (void)showLocationChooser
{
	[self.tweetTextView resignFirstResponder];
	[self performSegueWithIdentifier:@"Location" sender:self];
}

#pragma mark - UITableViewDelegate delegate methods

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	cell.detailTextLabel.text = @"Locating…";
	
	UIActivityIndicatorView *acitivityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(255, 12, 20, 20)];
	[acitivityIndicatorView startAnimating];
	acitivityIndicatorView.color = cell.detailTextLabel.textColor;
	cell.accessoryView = acitivityIndicatorView;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[self performSelector:@selector(showLocationChooser) withObject:self afterDelay:0.5];
}

- (void)setLocationTitle:(NSString *)locationTitle
{
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	cell.detailTextLabel.text = locationTitle;
	cell.accessoryView = nil;
}

@end
