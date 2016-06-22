//
//  LMEmbeddedViewController.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 19/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMEmbeddedViewController.h"

@interface LMEmbeddedViewController ()

@end

@implementation LMEmbeddedViewController

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
	[self.alertView dismissWithClickedButtonIndex:-1 animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.controllerToShow) {
        [self presentViewController:self.controllerToShow animated:NO completion:nil];
        self.controllerToShow = nil;
    }
    
    __weak typeof(self) self_ = self;
    [NSNotificationCenter.defaultCenter addObserverForName:@"DismissAlertView" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self_ dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
