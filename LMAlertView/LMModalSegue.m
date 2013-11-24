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
	LMAlertView *alertView = [[LMAlertView alloc] initWithViewController:[self destinationViewController]];
	
	[alertView show];
}

@end
