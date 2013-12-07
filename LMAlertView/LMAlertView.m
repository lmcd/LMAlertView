//
//  LMAlertView.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 11/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMAlertView.h"
#import "LMEmbeddedViewController.h"

@interface LMAlertView ()

@property (nonatomic, strong, readonly) UIView *alertContainerView;
@property (nonatomic, strong, readonly) UIView *backgroundView;

@property (nonatomic, strong, readonly) UIView *representationView;
@property (nonatomic, strong, readonly) UIView *alertBackgroundView;

@property (nonatomic, strong, readonly) UIToolbar *toolbar;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIViewController *controller;

@end

@implementation LMAlertView

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return image;
}

- (id)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        [self setupWithSize:size];
    }
    return self;
}

- (id)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
		_controller = viewController;
		
		UIViewController *frontmostViewController;
		
		if ([viewController isKindOfClass:[UINavigationController class]]) {
			UINavigationController *navigationController = (UINavigationController *)viewController;
			frontmostViewController = navigationController.visibleViewController;
			
			[navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
			navigationController.navigationBar.translucent = YES;
			navigationController.navigationBar.barStyle = UIBarStyleDefault;
		}
		else {
			frontmostViewController = viewController;
		}
		
		CGSize frame = frontmostViewController.view.frame.size;
		frame.height += 44.0;
		
		[self setupWithSize:frame];
		
		UIViewController *destinationViewController = viewController;
		destinationViewController.view.frame = self.contentView.frame;
		
		[self.contentView addSubview:destinationViewController.view];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
	CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	self.representationView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2.0, ([[UIScreen mainScreen] bounds].size.height - keyboardSize.height) / 2.0);
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self = [super init];
    if (self) {
		CGFloat sideMargin = 15.0;
		CGFloat topBottomMargin = 19.0;
		CGFloat alertWidth = 270.0;
		CGFloat buttonHeight = 44.0;
		CGFloat labelWidth = alertWidth - (sideMargin * 2.0);
		
		UIFont *titleFont = [UIFont boldSystemFontOfSize:17.0];
		
		CGFloat yOffset = topBottomMargin;
		
		UILabel *titleLabel;
		UIView *lineView;
        // This is the default iOS 7 blue tint colour
        UIColor *titleColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
		UIButton *cancelButton;
        UIButton *otherButton;
		
		if (title != nil) {
			// The UILabels in UIAlertView mysteriously have no paragraph style but STILL have line heights
			// I suspect there's some UILabel private API fuckery afoot
			NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
			//[paragrahStyle setLineSpacing:2];
			
			NSDictionary *attributes = @{
										 NSParagraphStyleAttributeName: paragrahStyle,
										 NSFontAttributeName: titleFont
										 };
			
			titleLabel = [[UILabel alloc] init];
			titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];
			titleLabel.numberOfLines = 0;
			titleLabel.textAlignment = NSTextAlignmentCenter;
			
			CGSize sizeThatFits = [titleLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
			titleLabel.frame = CGRectMake(sideMargin, yOffset, labelWidth, sizeThatFits.height);
			
			yOffset += titleLabel.frame.size.height;
		}
		
		// 4 px gap between title and message
		// Even if a title doesn't exist, the 4px is still present
		yOffset += 4.0;
		
		if (message != nil) {
			self.messageLabel = [[UILabel alloc] init];
			self.messageLabel.numberOfLines = 0;
			self.message = message;
			
			CGSize sizeThatFits = [self.messageLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
			self.messageLabel.frame = CGRectMake(sideMargin, yOffset, labelWidth, sizeThatFits.height);
			
			yOffset += self.messageLabel.frame.size.height;
		}
		
		yOffset += topBottomMargin;
		
        // Lines setup
        if (cancelButtonTitle || otherButtonTitles) {
			lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, yOffset - 1.0, alertWidth, 1.0)];
			lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
			
			// We put our 0.5px high view in to a container that's 1px high
			// This is because autoresizing was rounding up to 1 and messing things up
			// autolayout might fix this
			UIView *lineViewInner = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.5, alertWidth, 0.5)];
			lineViewInner.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
			lineViewInner.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			
			[lineView addSubview:lineViewInner];
            
            if (cancelButtonTitle && otherButtonTitles) {
                UIView *lineVerticalViewInner = [[UIView alloc] initWithFrame:CGRectMake((alertWidth / 2.f), 0.5, 0.5, buttonHeight + 0.5)];
                lineVerticalViewInner.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
                [lineView addSubview:lineVerticalViewInner];
            }
        }
        
        // Buttons setup
        if (otherButtonTitles != nil && cancelButtonTitle == nil) {
            cancelButtonTitle = otherButtonTitles;
            otherButtonTitles = nil;
        }
        
        if (cancelButtonTitle != nil) {
			cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.tag = 0;
			[cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
			cancelButton.titleEdgeInsets = UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0);
			[cancelButton setTitleColor:titleColor forState:UIControlStateNormal];
			[cancelButton setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
			cancelButton.titleLabel.font = (otherButtonTitles) ? [UIFont systemFontOfSize:17.0] : titleFont;
			[cancelButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
			cancelButton.frame = CGRectMake(0.0, yOffset, alertWidth, buttonHeight);
			cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		}
		
        if (otherButtonTitles != nil) {
            otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
            otherButton.tag = 1;
			[otherButton setTitle:otherButtonTitles forState:UIControlStateNormal];
			otherButton.titleEdgeInsets = UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0);
			[otherButton setTitleColor:titleColor forState:UIControlStateNormal];
			[otherButton setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
			otherButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
			[otherButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
			otherButton.frame = CGRectMake((alertWidth / 2.0) + 0.5, yOffset, (alertWidth / 2.0) - 0.5, buttonHeight);
			otherButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            
            cancelButton.frame = CGRectMake(0.0, yOffset, (alertWidth / 2.0), buttonHeight);
        }
		
        yOffset += buttonHeight;

		CGFloat alertHeight = yOffset;
		[self setupWithSize:CGSizeMake(alertWidth, alertHeight)];
		
		// Add everything to the content view
		[self.contentView addSubview:titleLabel];
		[self.contentView addSubview:self.messageLabel];
		[self.contentView addSubview:lineView];
		[self.contentView addSubview:cancelButton];
        [self.contentView addSubview:otherButton];
    }
    return self;
}

- (void)buttonTapped:(UIView *)sender
{
	[self dismiss];
	
	if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
		[self.delegate alertView:(UIAlertView *)self clickedButtonAtIndex:sender.tag];
	}
}

- (void)setSize:(CGSize)size
{
	CGRect frame = self.representationView.frame;
	frame.size = size;
	
	self.representationView.frame = frame;
    self.representationView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2.0, [[UIScreen mainScreen] bounds].size.height / 2.0);
}

- (CGSize)size
{
	return self.representationView.frame.size;
}

- (void)setupWithSize:(CGSize)size
{
	// Main container that fits the whole screen
	_alertContainerView = [[UIView alloc] initWithFrame:(CGRect){.size = [[UIScreen mainScreen] bounds].size}];
	_alertContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	_backgroundView = [[UIView alloc] initWithFrame:_alertContainerView.frame];
	_backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
	_backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[_alertContainerView addSubview:_backgroundView];
	
	CGRect frame;
	frame.size = size;
	
	_representationView = [[UIView alloc] initWithFrame:frame];
    _representationView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2.0, [[UIScreen mainScreen] bounds].size.height / 2.0);
	
	_representationView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[_representationView.layer setMasksToBounds:YES];
	[_representationView.layer setCornerRadius:7.0];
	
	_toolbar = [[UIToolbar alloc] initWithFrame:(CGRect){.size = self.representationView.frame.size}];
	_toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[self.representationView addSubview:_toolbar];
	
	_alertBackgroundView = [[UIView alloc] initWithFrame:(CGRect){.size = self.representationView.frame.size}];
	_alertBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Radial.png"]];
	imageView.frame = _toolbar.frame;
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[_alertBackgroundView addSubview:imageView];
	
	[self.representationView addSubview:_alertBackgroundView];
	
	_contentView = [[UIView alloc] initWithFrame:(CGRect){.size = self.representationView.frame.size}];
	_contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.representationView addSubview:_contentView];
	
	[self.representationView addSubview:self];
	
	[self.alertContainerView addSubview:self.representationView];
}

- (void)setup
{
	[self setupWithSize:CGSizeMake(270.0, 152.0)];
}	

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	// Temporary bugfix
	[self removeFromSuperview];
	
	// Release window from memory
	self.window.hidden = YES;
	self.window = nil;
}

- (id)springAnimationForKeyPath:(NSString *)keyPath
{
	kSpringAnimationClassName *animation = [[kSpringAnimationClassName alloc] init];
	
	// Values reversed engineered from iOS 7 UIAlertView
	animation.keyPath = keyPath;
	animation.velocity = 0.0;
	animation.mass = 3.0;
	animation.stiffness = 1000.0;
	animation.damping = 500.0;
	// todo - figure out how iOS is deriving this number
	animation.duration = 0.5058237314224243;
	
	return animation;
}

- (void)show
{
	id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
	
	self.window = [[UIWindow alloc] initWithFrame:[appDelegate window].frame];
	
	LMEmbeddedViewController *viewController = [[LMEmbeddedViewController alloc] init];
	viewController.alertView = self;
	
	self.window.rootViewController = viewController;
	
	// Without this, the alert background will appear black on rotation
	self.window.backgroundColor = [UIColor clearColor];
	// Same window level as regular alert views (above main window and status bar)
	self.window.windowLevel = UIWindowLevelAlert;
	self.window.hidden = NO;
	
	[self.window makeKeyAndVisible];
	
	if (self.controller == nil) {
		viewController.view = self.alertContainerView;
	}
	else {
		UIViewController *viewController2 = [[UIViewController alloc] init];
		viewController2.view = self.alertContainerView;
		
		[viewController presentViewController:viewController2 animated:NO completion:nil];
		
		[viewController2 addChildViewController:self.controller];
	}
	
	[CATransaction begin]; {
		CATransform3D transformFrom = CATransform3DMakeScale(1.26, 1.26, 1.0);
		CATransform3D transformTo = CATransform3DMakeScale(1.0, 1.0, 1.0);
		
		kSpringAnimationClassName *modalTransformAnimation = [self springAnimationForKeyPath:@"transform"];
		modalTransformAnimation.fromValue = [NSValue valueWithCATransform3D:transformFrom];
		// CASpringAnimation has all toValues as nil, but RBBSpringAnimation doesn't support it
		modalTransformAnimation.toValue = [NSValue valueWithCATransform3D:transformTo];
		self.representationView.layer.transform = transformTo;
		
		// Zoom in the modal
		[self.representationView.layer addAnimation:modalTransformAnimation forKey:@"transform"];
		
		kSpringAnimationClassName *opacityAnimation = [self springAnimationForKeyPath:@"opacity"];
		opacityAnimation.fromValue = @0.0f;
		opacityAnimation.toValue = @1.0f;
		self.backgroundView.layer.opacity = 1.0;
		self.toolbar.layer.opacity = 1.0;
		self.alertBackgroundView.layer.opacity = 1.0;
		self.contentView.layer.opacity = 1.0;
		
		// Fade in the gray background
		[self.backgroundView.layer addAnimation:opacityAnimation forKey:@"opacity"];

		// Fade in the modal
		// Would love to fade in all these things at once, but UIToolbar doesn't like it
		[self.toolbar.layer addAnimation:opacityAnimation forKey:@"opacity"];
		[self.alertBackgroundView.layer addAnimation:opacityAnimation forKey:@"opacity"];
		[self.contentView.layer addAnimation:opacityAnimation forKey:@"opacity"];
	} [CATransaction commit];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)dismiss
{
	[CATransaction begin]; {
		CATransform3D transformFrom = CATransform3DMakeScale(1.0, 1.0, 1.0);
		CATransform3D transformTo = CATransform3DMakeScale(0.840, 0.840, 1.0);
		
		kSpringAnimationClassName *modalTransformAnimation = [self springAnimationForKeyPath:@"transform"];
		modalTransformAnimation.fromValue = [NSValue valueWithCATransform3D:transformFrom];
		modalTransformAnimation.toValue = [NSValue valueWithCATransform3D:transformTo];
		modalTransformAnimation.delegate = self;
		self.representationView.layer.transform = transformTo;
		
		// Zoom out the modal
		[self.representationView.layer addAnimation:modalTransformAnimation forKey:@"transform"];
		
		kSpringAnimationClassName *opacityAnimation = [self springAnimationForKeyPath:@"opacity"];
		opacityAnimation.fromValue = @1.0f;
		opacityAnimation.toValue = @0.0f;
		self.backgroundView.layer.opacity = 0.0;
		self.toolbar.layer.opacity = 0.0;
		self.alertBackgroundView.layer.opacity = 0.0;
		self.contentView.layer.opacity = 0.0;
		
		// Fade out the gray background
		[self.backgroundView.layer addAnimation:opacityAnimation forKey:@"opacity"];
		
		// Fade out the modal
		// Would love to fade out all these things at once, but UIToolbar doesn't like it
		[self.toolbar.layer addAnimation:opacityAnimation forKey:@"opacity"];
		[self.alertBackgroundView.layer addAnimation:opacityAnimation forKey:@"opacity"];
		[self.contentView.layer addAnimation:opacityAnimation forKey:@"opacity"];
	} [CATransaction commit];
}

- (void)setMessage:(NSString *)message
{
	_message = message;
	
	UIFont *messageFont = [UIFont systemFontOfSize:14.0];
	
	NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
	//[paragrahStyle setLineSpacing:2];
	
	NSDictionary *attributes = @{
								 NSParagraphStyleAttributeName: paragrahStyle,
								 NSFontAttributeName: messageFont
								 };
	
	self.messageLabel.attributedText = [[NSAttributedString alloc] initWithString:message attributes:attributes];
	self.messageLabel.textAlignment = NSTextAlignmentCenter;
}

@end
