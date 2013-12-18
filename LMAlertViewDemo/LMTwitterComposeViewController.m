//
//  LMTwitterComposeViewController.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 17/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMTwitterComposeViewController.h"
#import "LMEmbeddedViewController.h"
#import "LMAlertView.h"

@interface LMTwitterComposeViewController ()

@end

@implementation LMTwitterComposeViewController

#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSRange substringRange = [self.tweetTextView.text rangeOfString:@"#lmalertview"];
	NSMutableAttributedString *attributedText = [self.tweetTextView.attributedText mutableCopy];
	[attributedText addAttribute:LMFixedTextAttributeName value:[NSNumber numberWithBool:YES] range:substringRange];
	
	self.tweetTextView.attributedText = attributedText;
	
	UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 137.5, self.view.frame.size.width, 0.5)];
	// This is the default UITableView separator color
	lineView.backgroundColor = [UIColor colorWithHue:360/252 saturation:0.02 brightness:0.80 alpha:1];
	lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[self.headerView addSubview:lineView];
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
	NSInteger remainingCharacters = 140 - textView.text.length;
	BOOL postEnabled = (remainingCharacters >= 0);
	
	self.characterCountLabel.textColor = [UIColor colorWithRed:(postEnabled ? 0.0 : 255.0) green:0.0 blue:0.0 alpha:0.5];
	
	self.characterCountLabel.text = [NSString stringWithFormat:@"%li", (long)remainingCharacters];
	
	self.navigationItem.rightBarButtonItem.enabled = postEnabled;
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
