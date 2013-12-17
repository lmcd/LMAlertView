//
//  LMAlertView.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 11/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMAlertView.h"
#import "LMEmbeddedViewController.h"
#import "LMModalItemTableViewCell.h"
#import <CAAnimation+Blocks.h>

@interface LMAlertView ()

@property (nonatomic, strong, readonly) UIView *alertContainerView;
@property (nonatomic, strong, readonly) UIView *backgroundView;

@property (nonatomic, strong, readonly) UIView *representationView;
@property (nonatomic, strong, readonly) UIView *alertBackgroundView;

@property (nonatomic, strong, readonly) UIToolbar *toolbar;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UITableView *buttonTableView;
@property (nonatomic, strong) UITableView *otherTableView;

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSMutableArray *otherButtonsTitles;

@end

@implementation LMAlertView

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
		}
		else {
			frontmostViewController = viewController;
		}
		
		CGSize size = frontmostViewController.view.frame.size;
		size.height += 44.0;
		
		[self setupWithSize:size];
		
		UIViewController *destinationViewController = viewController;
		destinationViewController.view.frame = self.contentView.frame;
		
		[self.contentView addSubview:destinationViewController.view];
		self.contentView.autoresizesSubviews = NO;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
	CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	self.representationView.layer.anchorPoint = CGPointMake(0.5, 0.5);
	self.representationView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2.0, ([[UIScreen mainScreen] bounds].size.height - keyboardSize.height) / 2.0);
}

- (UITableView *)tableViewWithFrame:(CGRect)frame
{
	UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
	tableView.backgroundColor = [UIColor clearColor];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.scrollEnabled = NO;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	
	return tableView;
}

- (void)setButtonsShouldStack:(BOOL)buttonsShouldStack
{
	_buttonsShouldStack = buttonsShouldStack;
	
	if (self.numberOfButtons == 2) {
		[self.buttonTableView reloadData];
		[self.otherTableView reloadData];
	}
}

- (void)setTintColor:(UIColor *)tintColor
{
	_tintColor = tintColor;
	self.window.tintColor = tintColor;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self = [super init];
    if (self) {
		_cancelButtonIndex = -1;
		_firstOtherButtonIndex = -1;
		
		_delegate = delegate;
		
		if (otherButtonTitles != nil) {
			va_list args;
			va_start(args, otherButtonTitles);
			_otherButtonsTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
			id obj;
			while ((obj = va_arg(args, id)) != nil) {
				[_otherButtonsTitles addObject:obj];
			}
			va_end(args);
			
			_firstOtherButtonIndex = 1;
		}
		
		_numberOfButtons = [_otherButtonsTitles count];
		
		if (cancelButtonTitle != nil) {
			_numberOfButtons++;
			_cancelButtonIndex = 0;
			_cancelButtonTitle = cancelButtonTitle;
		}
		
		CGFloat sideMargin = 15.0;
		CGFloat topBottomMargin = 19.0;
		CGFloat alertWidth = 270.0;
		CGFloat buttonHeight = 44.0;
		CGFloat labelWidth = alertWidth - (sideMargin * 2.0);
		
		UIFont *titleFont = [UIFont boldSystemFontOfSize:17.0];
		
		CGFloat yOffset = topBottomMargin;
		
		UILabel *titleLabel;
		UIView *lineView;
		
		if (title != nil) {
			self.title = title;
			
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
		
		// 4px gap between title and message
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
        if (self.numberOfButtons > 0) {
			lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, yOffset - 1.0, alertWidth, 1.0)];
			lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
			
			// We put our 0.5px high view in to a container that's 1px high
			// This is because autoresizing was rounding up to 1 and messing things up
			// autolayout might fix this
			UIView *lineViewInner = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.5, alertWidth, 0.5)];
			lineViewInner.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
			lineViewInner.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			
			[lineView addSubview:lineViewInner];
        }
		
		BOOL sideBySideButtons = (self.numberOfButtons == 2);
		BOOL buttonsShouldStack = !sideBySideButtons;
		
		if (sideBySideButtons) {
			CGFloat halfWidth = (alertWidth / 2.0);
			
			UIView *lineVerticalViewInner = [[UIView alloc] initWithFrame:CGRectMake(halfWidth, 0.5, 0.5, buttonHeight + 0.5)];
			lineVerticalViewInner.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
			[lineView addSubview:lineVerticalViewInner];
			
			_buttonTableView = [self tableViewWithFrame:CGRectMake(0.0, yOffset, halfWidth, buttonHeight)];
			_otherTableView = [self tableViewWithFrame:CGRectMake(halfWidth, yOffset, halfWidth, buttonHeight)];
			
			yOffset += buttonHeight;
		}
		else {
			NSInteger numberOfOtherButtons = [self.otherButtonsTitles count];
			
			if (numberOfOtherButtons > 0) {
				CGFloat tableHeight = buttonsShouldStack ? numberOfOtherButtons * buttonHeight : buttonHeight;
				
				_buttonTableView = [self tableViewWithFrame:CGRectMake(0.0, yOffset, alertWidth, tableHeight)];
				
				yOffset += tableHeight;
			}
			
			if (cancelButtonTitle != nil) {
				_otherTableView = [self tableViewWithFrame:CGRectMake(0.0, yOffset, alertWidth, buttonHeight)];
				
				yOffset += buttonHeight;
			}
		}
		
		_buttonTableView.tag = 0;
		_otherTableView.tag = 1;
		
		[_buttonTableView reloadData];
		[_otherTableView reloadData];

		CGFloat alertHeight = yOffset;
		[self setupWithSize:CGSizeMake(alertWidth, alertHeight)];
		
		// Add everything to the content view
		[self.contentView addSubview:titleLabel];
		[self.contentView addSubview:self.messageLabel];
		[self.contentView addSubview:self.buttonTableView];
        [self.contentView addSubview:self.otherTableView];
		[self.contentView addSubview:lineView];
    }
    return self;
}

- (void)setSize:(CGSize)size animated:(BOOL)animated
{
	if (!animated) {
		[self setSize:size];
		return;
	}
	
	// This all seems to me like an overly-complicated way of animating the size of representationView
	// todo - find a cleaner way of doing all of this
	
	// todo - move this to LMNavigationController
	size = CGSizeMake(size.width, size.height + 44);
	
	CGRect frame = self.representationView.frame;
	frame.size = size;
	
	CGRect bounds = self.representationView.layer.bounds;
	bounds.size = size;
	
	// Only checking height for now
	BOOL isBigger = bounds.size.height > self.representationView.layer.bounds.size.height;
	
	// Completion block
	void (^completion)(BOOL finished) = ^(BOOL finished){
		self.representationView.frame = frame;
		
		UIView *controllerView = [self.contentView.subviews firstObject];
		CGRect contentFrame = controllerView.bounds;
		contentFrame.size = size;
		
		controllerView.center = CGPointMake(size.width / 2.0, contentFrame.size.height / 2.0);
		controllerView.bounds = contentFrame;
		controllerView.clipsToBounds = NO;
	};
	
	// I think a spring animation is being used here, but not sure the params are the same
	kSpringAnimationClassName *animation = [self springAnimationForKeyPath:@"bounds"];
	
	animation.fromValue = [NSValue valueWithCGRect:self.representationView.layer.bounds];
	animation.toValue = [NSValue valueWithCGRect:bounds];
	
	if (!isBigger) {
		animation.completion = completion;
	}
	
	if (self.keepTopAlignment) {
		self.representationView.layer.anchorPoint = CGPointMake(0.5, 0.0);
		
		if (isBigger) {
			completion(YES);
		}
	}
	else {
		self.representationView.layer.anchorPoint = CGPointMake(0.5, 0.5);
		self.representationView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2.0, [[UIScreen mainScreen] bounds].size.height / 2.0);
	}
	
	[self.representationView.layer addAnimation:animation forKey:@"bounds"];
	self.representationView.layer.bounds = bounds;
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
	CGSize screenSize = [[UIScreen mainScreen] bounds].size;
	
	// Main container that fits the whole screen
	_alertContainerView = [[UIView alloc] initWithFrame:(CGRect){.size = screenSize}];
	_alertContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	_backgroundView = [[UIView alloc] initWithFrame:_alertContainerView.frame];
	_backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
	_backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[_alertContainerView addSubview:_backgroundView];
	
	_representationView = [[UIView alloc] initWithFrame:(CGRect){.size = size}];
    _representationView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
	
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

- (kSpringAnimationClassName *)springAnimationForKeyPath:(NSString *)keyPath
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

- (void)transformAlertContainerViewForOrientation{
#define DegreesToRadians(degrees) (degrees * M_PI / 180)
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGAffineTransform transform;
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(-DegreesToRadians(90));
            break;
        case UIInterfaceOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
            break;
        case UIInterfaceOrientationPortrait:
        default:
            transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
            break;
    }
    
    [self.alertContainerView setTransform:transform];
}

- (void)show
{
	if ([self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
		[self.delegate willPresentAlertView:self];
	}
	
	id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
	
	// You can have more than one UIWindow in the view hierachy, which is how UIAlertView works
	self.window = [[UIWindow alloc] initWithFrame:[appDelegate window].frame];
	self.window.tintColor = self.tintColor;
	
	LMEmbeddedViewController *viewController = [[LMEmbeddedViewController alloc] init];
	viewController.alertView = self;
	
	self.window.rootViewController = viewController;
	
	// Without this, the alert background will appear black on rotation
	self.window.backgroundColor = [UIColor clearColor];
	// Same window level as regular alert views (above main window and status bar)
	self.window.windowLevel = UIWindowLevelAlert;
	self.window.hidden = NO;
	
    [self transformAlertContainerViewForOrientation];
    
	[self.window makeKeyAndVisible];
	
	if (self.controller == nil) {
		viewController.view = self.alertContainerView;
	}
	else {
		UIViewController *viewController2 = [[UIViewController alloc] init];
		viewController2.view = self.alertContainerView;
		
		// We fake "present" this view controller so it can be dismissed elswhere
		[viewController presentViewController:viewController2 animated:NO completion:nil];
		
		[viewController2 addChildViewController:self.controller];
	}
	
	_visible = YES;
	
	[CATransaction begin]; {
		CATransform3D transformFrom = CATransform3DMakeScale(1.26, 1.26, 1.0);
		CATransform3D transformTo = CATransform3DMakeScale(1.0, 1.0, 1.0);
		
		kSpringAnimationClassName *modalTransformAnimation = [self springAnimationForKeyPath:@"transform"];
		modalTransformAnimation.fromValue = [NSValue valueWithCATransform3D:transformFrom];
		// CASpringAnimation has all toValues as nil, but RBBSpringAnimation doesn't support it
		modalTransformAnimation.toValue = [NSValue valueWithCATransform3D:transformTo];
		modalTransformAnimation.completion = ^(BOOL finished){
			if ([self.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
				[self.delegate didPresentAlertView:self];
			}
		};
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

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
	if ([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
		[self.delegate alertView:(UIAlertView *)self willDismissWithButtonIndex:buttonIndex];
	}

	// Completion block
	void (^completion)(BOOL finished) = ^(BOOL finished){
		// Temporary bugfix
		[self removeFromSuperview];
		
		// Release window from memory
		self.window.hidden = YES;
		self.window = nil;
		
		_visible = NO;
		
		[self.buttonTableView deselectRowAtIndexPath:self.buttonTableView.indexPathForSelectedRow animated:NO];
		[self.otherTableView deselectRowAtIndexPath:self.otherTableView.indexPathForSelectedRow animated:NO];
		
		if ([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
			[self.delegate alertView:(UIAlertView *)self didDismissWithButtonIndex:buttonIndex];
		}
	};
	
	if (!animated) {
		completion(YES);
	}
	
	[CATransaction begin]; {
		CATransform3D transformFrom = CATransform3DMakeScale(1.0, 1.0, 1.0);
		CATransform3D transformTo = CATransform3DMakeScale(0.840, 0.840, 1.0);
		
		kSpringAnimationClassName *modalTransformAnimation = [self springAnimationForKeyPath:@"transform"];
		modalTransformAnimation.fromValue = [NSValue valueWithCATransform3D:transformFrom];
		modalTransformAnimation.toValue = [NSValue valueWithCATransform3D:transformTo];
		modalTransformAnimation.completion = completion;
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

- (bool)hasCancelButton
{
	return (self.cancelButtonIndex != -1);
}

#pragma mark UITableViewDataSource delegate methods

- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *labelText;
	
	LMModalItemTableViewCell *cell = [[LMModalItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
	
	NSInteger buttonIndex;
	BOOL boldButton = NO;
	BOOL lastRow = NO;
	
	if (self.numberOfButtons == 1) {
		buttonIndex = 0;
		
		if ([self hasCancelButton]) {
			labelText = self.cancelButtonTitle;
		}
		else {
			labelText = self.otherButtonsTitles[0];
		}

		boldButton = YES;
		lastRow = YES;
	}
	// Side by side buttons
	else if (self.numberOfButtons == 2) {
		buttonIndex = tableView.tag;
		
		if ([self hasCancelButton]) {
			if (buttonIndex == 0) {
				labelText = self.cancelButtonTitle;
			}
			else {
				labelText = self.otherButtonsTitles[0];
			}
		}
		else {
			labelText = self.otherButtonsTitles[buttonIndex];
		}
		
		boldButton = buttonIndex == 1;
		lastRow = YES;
	}
	// More than 2 stacked buttons
	else {
		buttonIndex = indexPath.row;
		
		if (tableView.tag == 1) {
			labelText = self.cancelButtonTitle;
			
			boldButton = YES;
			lastRow = YES;
		}
		else {
			labelText = self.otherButtonsTitles[buttonIndex];
			
			if (![self hasCancelButton] && buttonIndex == ([self.otherButtonsTitles count] - 1)) {
				boldButton = YES;
			}
			
			buttonIndex++;
		}
	}
	
	cell.tag = buttonIndex;
	cell.lineView.hidden = lastRow;
	cell.textLabel.font = boldButton ? [UIFont boldSystemFontOfSize:17.0] : [UIFont systemFontOfSize:17.0];
	cell.textLabel.text = labelText;
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.numberOfButtons <= 2) {
		return 1;
	}
	else {
		if (tableView.tag == 0) {
			return [self.otherButtonsTitles count];
		}
		else {
			return 1;
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

#pragma mark UITableViewDelegateSource delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	NSInteger buttonIndex = cell.tag;
	
	if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
		[self.delegate alertView:(UIAlertView *)self clickedButtonAtIndex:buttonIndex];
	}
	
	[self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (UITableViewCell *)buttonCellForIndex:(NSInteger)buttonIndex
{
	UITableView *theTableView;
	NSInteger rowIndex = 0;
	
	if (self.numberOfButtons == 1) {
		theTableView = self.buttonTableView;
		rowIndex = 0;
	}
	// Side by side buttons
	else if (self.numberOfButtons == 2) {
		if (buttonIndex == self.cancelButtonIndex) {
			theTableView = self.buttonTableView;
		}
		else {
			theTableView = self.otherTableView;
		}
	}
	// More than 2 stacked buttons
	else {
		if (buttonIndex == self.cancelButtonIndex) {
			theTableView = self.otherTableView;
		}
		else {
			theTableView = self.buttonTableView;
			rowIndex = 1;
		}
	}
	
	return [theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
}

@end
