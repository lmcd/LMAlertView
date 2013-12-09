//
//  LMNavigationBar.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 18/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMNavigationBar.h"

@implementation LMNavigationBar

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
    if (self) {
		[self setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]}];
		[self setTitleVerticalPositionAdjustment:-0.5 forBarMetrics:UIBarMetricsDefault];
		
		[self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
		self.translucent = YES;
		self.barStyle = UIBarStyleDefault;
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGFloat marginWidth = 6.0;
	
	CGRect superviewFrame = self.superview.frame;
	
	// Adjust width and position of nav bar to add 6px margin on each side
	self.frame = CGRectMake(marginWidth, self.frame.origin.y, superviewFrame.size.width - (marginWidth * 2.0), self.frame.size.height);
	
	UIView *backgroundView = [self.subviews firstObject];

	CGRect frame;
	frame.size = CGSizeMake(superviewFrame.size.width, backgroundView.frame.size.height);
	frame.origin = CGPointMake(-marginWidth, backgroundView.frame.origin.y);
	
	backgroundView.frame = frame;
	
	for (UIView *subview in [self subviews]) {
		NSString *className = [[subview class] description];
		
		if ([className hasSuffix:@"BackIndicatorView"]) {
			CGRect frame = subview.frame;
			frame.origin.x = 2;
			
			subview.frame = frame;
		}
		else if ([className hasSuffix:@"ItemButtonView"]) {
			CGRect frame = subview.frame;
			frame.origin.x = 2;
			
			subview.frame = frame;
		}
	}
}

@end
