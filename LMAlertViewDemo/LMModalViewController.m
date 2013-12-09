//
//  LMModalViewController.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 17/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMModalViewController.h"
#import "LMEmbeddedViewController.h"
#import "LMAlertView.h"

@interface LMModalViewController ()

@end

@implementation LMModalViewController

#pragma mark - UIViewController methods

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

- (void)viewWillAppear:(BOOL)animated
{
	// When the modal is launched
	// Focus text view/show keyboard immediately
	if (!animated) {
		[self.tweetTextView becomeFirstResponder];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	// When coming back from the location chooser
	// Focus text view/show keyboard after animation has finished
	if (animated) {
		[self.tweetTextView becomeFirstResponder];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
	
	LMEmbeddedViewController *alertViewController = (LMEmbeddedViewController *)keyWindow.rootViewController;
	LMAlertView *alertView = alertViewController.alertView;
	
	alertView.keepTopAlignment = YES;
}

#pragma mark - UITableViewDelegate delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	cell.detailTextLabel.text = @"Locating…";
	
	UIActivityIndicatorView *acitivityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(255, 12, 20, 20)];
	[acitivityIndicatorView startAnimating];
	// todo - find accurate colour for this
	acitivityIndicatorView.color = cell.detailTextLabel.textColor;
	cell.accessoryView = acitivityIndicatorView;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Fake the loading of location by waiting 0.5 seconds
	[self performSelector:@selector(showLocationChooser) withObject:self afterDelay:0.5];
}

#pragma mark - UITextViewDelegate delegate methods

- (void)textViewDidChange:(UITextView *)textView
{
	NSUInteger remainingCharacters = 140 - textView.text.length;
	self.characterCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)remainingCharacters];
	
	self.navigationItem.rightBarButtonItem.enabled = (remainingCharacters >= 0);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	NSRange suffixRange = [textView.text rangeOfString:@"#lmalertview"];
	if (range.location >= suffixRange.location && range.location <= suffixRange.location + suffixRange.length) {
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

#pragma mark - IBActions

- (IBAction)cancelButtonTapped:(id)sesnder
{
	[self.tweetTextView resignFirstResponder];
	[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Other methods

- (void)showLocationChooser
{
	[self.tweetTextView resignFirstResponder];
	[self performSegueWithIdentifier:@"Location" sender:self];
}

- (void)setLocationTitle:(NSString *)locationTitle
{
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	cell.detailTextLabel.text = locationTitle;
	cell.accessoryView = nil;
}

@end
