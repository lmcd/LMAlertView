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

@end
