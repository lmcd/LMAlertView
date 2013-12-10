//
//  LMNavigationController.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 08/12/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMNavigationController.h"
#import "LMEmbeddedViewController.h"

@interface LMNavigationController ()

@end

@implementation LMNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.viewControllers.count;
	
    if (numberOfViewControllers < 2) {
        return nil;
	}
    else {
        return [self.viewControllers objectAtIndex:numberOfViewControllers - 2];
	}
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
	
	UIViewController *fromVC = [self topViewController];
	
	fromVC.view.autoresizingMask = 0;
	viewController.view.autoresizingMask = 0;
	
	LMEmbeddedViewController *alertViewController = (LMEmbeddedViewController *)keyWindow.rootViewController;
	LMAlertView *alertView = alertViewController.alertView;
	
	[alertView setSize:viewController.view.frame.size animated:YES];
	[super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
	UIViewController *viewController = [self backViewController];
	
	UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
	
	LMEmbeddedViewController *alertViewController = (LMEmbeddedViewController *)keyWindow.rootViewController;
	LMAlertView *alertView = alertViewController.alertView;
	[alertView setSize:viewController.view.frame.size animated:YES];
	
	return [super popViewControllerAnimated:animated];
}

@end
