//
//  LMNavigationBar.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 18/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMNavigationBar.h"

@implementation LMNavigationBar

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGFloat marginWidth = 6.0;
	
	CGRect superviewFrame = self.superview.frame;
	
	self.frame = CGRectMake(marginWidth, self.frame.origin.y, superviewFrame.size.width - (marginWidth * 2.0), self.frame.size.height);
	
	UIView *backgroundView = [self.subviews firstObject];

	CGRect frame;
	frame.size = CGSizeMake(superviewFrame.size.width, backgroundView.frame.size.height);
	frame.origin = CGPointMake(-marginWidth, backgroundView.frame.origin.y);
	
	backgroundView.frame = frame;
}

@end
