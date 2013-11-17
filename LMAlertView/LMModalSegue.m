//
//  LMModalSegue.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 17/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMModalSegue.h"
#import "LMAlertView.h"

@implementation LMModalSegue

- (void)perform
{
	UIViewController *frontmostViewController;
	
	if ([[self destinationViewController] isKindOfClass:[UINavigationController class]]) {
		UINavigationController *navigationController = [self destinationViewController];
		frontmostViewController = navigationController.visibleViewController;
		
		[navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
		navigationController.navigationBar.translucent = YES;
		navigationController.navigationBar.barStyle = UIBarStyleDefault;
	}
	else {
		frontmostViewController = [self destinationViewController];
	}
	
	frontmostViewController.view.backgroundColor = [UIColor clearColor];
	
	LMAlertView *alertView = [[LMAlertView alloc] initWithSize:frontmostViewController.view.frame.size];
	
	UIViewController *destinationViewController = [self destinationViewController];
	destinationViewController.view.frame = alertView.contentView.frame;
	
	[alertView.contentView addSubview:destinationViewController.view];
	[alertView show];
}

@end
