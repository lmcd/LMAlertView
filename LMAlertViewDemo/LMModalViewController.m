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
}

- (IBAction)cancelButtonTapped:(id)sender
{
	[self.tweetTextView resignFirstResponder];
	[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
	int remainingCharacters = 140 - textView.text.length;
	self.characterCountLabel.text = [NSString stringWithFormat:@"%i", remainingCharacters];
	
	self.navigationItem.rightBarButtonItem.enabled = (remainingCharacters >= 0);
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

@end
