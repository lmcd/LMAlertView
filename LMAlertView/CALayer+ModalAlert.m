//
//  CALayer+ModalAlert.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 18/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "CALayer+ModalAlert.h"
#import "LMEmbeddedViewController.h"
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
	UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
	
	if ([keyWindow.rootViewController isKindOfClass:[LMEmbeddedViewController class]]) {
		UIView *view = [self delegate];
		CABasicAnimation *basicAnim = (CABasicAnimation *)anim;
		CGFloat modalWidth = 290.0;
		
		// Hide _UIParallaxDimmingView. It's making the transparent nav controller go dark when animating
		if ([[[view class] description] hasSuffix:@"DimmingView"]) {
			view.hidden = YES;
		}
		
		// When pushing a view controller, make the one underneath slide out all the way
		if ([key isEqualToString:@"position"] && basicAnim.fromValue != nil) {
			if ([basicAnim.fromValue CGPointValue].x == (modalWidth / 5.0)) {
				basicAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(-(modalWidth / 2.0), [basicAnim.fromValue CGPointValue].y)];
			}
		}
		
		if (view.frame.origin.x == (-0.3 * modalWidth)) {
			CGRect frame = view.frame;
			frame.origin.x = -modalWidth;
			
			view.frame = frame;
		}
	}
	
	// Note: this calls original Apple implementation of addAnimation:forKey:
	[self _addAnimation:anim forKey:key];
}

@end
