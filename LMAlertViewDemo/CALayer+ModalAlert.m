//
//  CALayer+ModalAlert.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 18/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "CALayer+ModalAlert.h"
#import <objc/runtime.h>

@implementation CALayer (ModalAlert)

+ (void)load
{
	SEL originalSelector = @selector(addAnimation:forKey:);
    SEL overrideSelector = @selector(_addAnimation:forKey:);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method overrideMethod = class_getInstanceMethod(self, overrideSelector);
	
	// Hit me with your swizzle stick!
	method_exchangeImplementations(originalMethod, overrideMethod);
}

- (void)_addAnimation:(CAAnimation *)anim forKey:(NSString *)key {
	UIView *view = [self delegate];
	CABasicAnimation *basicAnim = (CABasicAnimation *)anim;
	
	// todo - add test here to see if we're in a LMAlertView
	if (YES) {
		// Get rid of _UIParallaxDimmingView. It's making the transparent nav controller go dark when animating
		if ([[[view class] description] hasSuffix:@"DimmingView"]){
			view.hidden = YES;
		}
		
		// When pushing a view controller, make the one underneath slide out all the way
		if ([key isEqualToString:@"position"]) {
			if ([basicAnim.fromValue CGPointValue].x == 58) {
				basicAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(-(290/2), [basicAnim.fromValue CGPointValue].y)];
			}
		}
		
		if (view.frame.origin.x == -87.0) {
			CGRect frame = view.frame;
			frame.origin.x = -290;
			
			view.frame = frame;
		}
	}
	
	[self _addAnimation:anim forKey:key];
}

@end
