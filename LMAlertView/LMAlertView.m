//
//  LMAlertView.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 11/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMAlertView.h"

@interface LMAlertView ()

@property (nonatomic, strong, readonly) UIView *alertContainerView;
@property (nonatomic, strong, readonly) UIView *backgrView;

@property (nonatomic, strong, readonly) UIView *representationView;
@property (nonatomic, strong, readonly) UIView *alertBackgroundView;

@property (nonatomic, strong, readonly) UIToolbar *toolbar;

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation LMAlertView

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return img;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        [self setupWithSize:size];
    }
    return self;
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
		
		CGFloat yOfs = topBottomMargin;
		
		UILabel *titleLabel;
		UIView *lineView;
		UIButton *button;
		
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
			titleLabel.frame = CGRectMake(sideMargin, yOfs, labelWidth, sizeThatFits.height);
			
			yOfs += titleLabel.frame.size.height;
		}
		
		// 4 px gap between title and message
		// Even if a title doesn't exist, the 4px is still present
		yOfs += 4.0;
		
		if (message != nil) {
			self.messageLabel = [[UILabel alloc] init];
			self.messageLabel.numberOfLines = 0;
			self.message = message;
			
			CGSize sizeThatFits = [self.messageLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
			self.messageLabel.frame = CGRectMake(sideMargin, yOfs, labelWidth, sizeThatFits.height);
			
			yOfs += self.messageLabel.frame.size.height;
		}
		
		yOfs += topBottomMargin;
		
		if (cancelButtonTitle != nil) {
			lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, yOfs - 1.0, alertWidth, 1.0)];
			lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
			
			// We need to do this because autoresizing was round up half-pixels to one
			// autolayout might fix this
			UIView *lineViewInner = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.5, alertWidth, 0.5)];
			lineViewInner.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
			lineViewInner.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			
			[lineView addSubview:lineViewInner];
			
			button = [UIButton buttonWithType:UIButtonTypeCustom];
			[button setTitle:cancelButtonTitle forState:UIControlStateNormal];
			button.titleEdgeInsets = UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0);
			[button setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
			[button setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
			button.titleLabel.font = titleFont;
			[button addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
			button.frame = CGRectMake(0.0, yOfs, alertWidth, buttonHeight);
			button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
			
			yOfs += buttonHeight;
		}
		
		CGFloat alertHeight = yOfs;
		[self setupWithSize:CGSizeMake(alertWidth, alertHeight)];
		
		// Add everything to the content view
		[self.contentView addSubview:titleLabel];
		[self.contentView addSubview:self.messageLabel];
		[self.contentView addSubview:lineView];
		[self.contentView addSubview:button];
    }
    return self;
}

- (void)cancelButtonTapped:(id)sender
{
	[self dismiss];
	
	if ([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
		[self.delegate alertView:self clickedButtonAtIndex:0];
	}
}

- (void)setSize:(CGSize)size
{
	CGRect frame = self.representationView.frame;
	frame.size = size;
	
	self.representationView.frame = frame;
}

- (void)setupWithSize:(CGSize)size
{
	//id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
	//UIView *mainView = [[appDelegate window].subviews firstObject];
	
	// Main container that fits the whole screen
	_alertContainerView = [[UIView alloc] initWithFrame:(CGRect){.size = [[UIScreen mainScreen] bounds].size}];
	
	_backgrView = [[UIView alloc] initWithFrame:_alertContainerView.frame];
	_backgrView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
	[_alertContainerView addSubview:_backgrView];
	
	CGRect maskRect = CGRectZero;
	maskRect.size = size;
	
	CGPoint origin = CGPointMake([_backgrView bounds].size.width/2.0 - maskRect.size.width/2.0, [_backgrView bounds].size.height/2.0 - maskRect.size.height/2.0);
	_representationView = [[UIView alloc] initWithFrame:(CGRect){.origin = origin, .size = maskRect.size}];
	[_representationView.layer setMasksToBounds:YES];
	[_representationView.layer setCornerRadius:7.0];
	
	_contentView = [[UIView alloc] initWithFrame:(CGRect){.size = self.representationView.frame.size}];
	_contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.representationView addSubview:_contentView];
	
	
	_alertBackgroundView = [[UIView alloc] initWithFrame:(CGRect){.size = self.representationView.frame.size}];
	_alertBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	_toolbar = [[UIToolbar alloc] initWithFrame:(CGRect){.size = self.representationView.frame.size}];
	_toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	//[_alertBackgroundView addSubview:_toolbar];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Radial.png"]];
	imageView.frame = _toolbar.frame;
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[_alertBackgroundView addSubview:imageView];
	
	[self.representationView insertSubview:_alertBackgroundView atIndex:0];
	[self.representationView insertSubview:_toolbar atIndex:0];
	
	[self.alertContainerView addSubview:self.representationView];
}

- (void)setup
{
	[self setupWithSize:CGSizeMake(270.0, 152.0)];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	[self.alertContainerView removeFromSuperview];
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
	animation.duration = 0.5058237314224243;
	
	return animation;
}

- (void)show
{
	[CATransaction begin]; {
		// todo - use a separate window
		id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
		[[appDelegate window] addSubview:self.alertContainerView];
		
		CATransform3D transformFrom = CATransform3DMakeScale(1.26, 1.26, 1.0);
		CATransform3D transformTo = CATransform3DMakeScale(1.0, 1.0, 1.0);
		
		kSpringAnimationClassName *modalTransformAnimation = [self springAnimationForKeyPath:@"transform"];
		modalTransformAnimation.fromValue = [NSValue valueWithCATransform3D:transformFrom];
		modalTransformAnimation.toValue = [NSValue valueWithCATransform3D:transformTo];
		self.representationView.layer.transform = transformTo;
		
		// Zoom in the modal
		[self.representationView.layer addAnimation:modalTransformAnimation forKey:@"transform"];
		
		kSpringAnimationClassName *opacityAnimation = [self springAnimationForKeyPath:@"opacity"];
		opacityAnimation.fromValue = @0.0f;
		opacityAnimation.toValue = @1.0f;
		self.backgrView.layer.opacity = 1.0;
		self.toolbar.layer.opacity = 1.0;
		self.alertBackgroundView.layer.opacity = 1.0;
		self.contentView.layer.opacity = 1.0;
		
		// Fade in the gray background
		[self.backgrView.layer addAnimation:opacityAnimation forKey:@"opacity"];

		// Fade in the modal
		// Would love to fade out all these things at once, but UIToolbar doesn't like it
		[self.toolbar.layer addAnimation:opacityAnimation forKey:@"opacity"];
		[self.alertBackgroundView.layer addAnimation:opacityAnimation forKey:@"opacity"];
		[self.contentView.layer addAnimation:opacityAnimation forKey:@"opacity"];
	} [CATransaction commit];
}

- (void)dismiss
{
	[CATransaction begin]; {
		CATransform3D transformFrom = CATransform3DMakeScale(1.0, 1.0, 1.0);
		CATransform3D transformTo = CATransform3DMakeScale(0.840, 0.840, 1.0);
		
		kSpringAnimationClassName *modalTransformAnimation = [self springAnimationForKeyPath:@"transform"];
		modalTransformAnimation.fromValue = [NSValue valueWithCATransform3D:transformFrom];
		modalTransformAnimation.toValue = [NSValue valueWithCATransform3D:transformTo];
		self.representationView.layer.transform = transformTo;
		
		// Zoom out the modal
		[self.representationView.layer addAnimation:modalTransformAnimation forKey:@"transform"];
		
		kSpringAnimationClassName *opacityAnimation = [self springAnimationForKeyPath:@"opacity"];
		opacityAnimation.delegate = self;
		opacityAnimation.fromValue = @1.0f;
		opacityAnimation.toValue = @0.0f;
		self.backgrView.layer.opacity = 0.0;
		self.toolbar.layer.opacity = 0.0;
		self.alertBackgroundView.layer.opacity = 0.0;
		self.contentView.layer.opacity = 0.0;
		
		// Fade out the gray background
		[self.backgrView.layer addAnimation:opacityAnimation forKey:@"opacity"];
		
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
