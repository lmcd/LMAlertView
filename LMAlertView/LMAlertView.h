//
//  LMAlertView.h
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 11/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define USE_PRIVATE_SPRING_ANIMATION_CLASS 1

#ifdef USE_PRIVATE_SPRING_ANIMATION_CLASS
#define kSpringAnimationClassName CASpringAnimation

@interface CASpringAnimation : CABasicAnimation
- (float)damping;
- (double)durationForEpsilon:(double)arg1;
- (float)mass;
- (void)setDamping:(float)arg1;
- (void)setMass:(float)arg1;
- (void)setStiffness:(float)arg1;
- (void)setVelocity:(float)arg1;
- (float)stiffness;
- (float)velocity;
@end
#else
#define kSpringAnimationClassName RBBSpringAnimation
#endif

@interface LMAlertView : UIView

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong) NSString *message;
@property (unsafe_unretained) id<UIAlertViewDelegate> delegate;

- (id)initWithSize:(CGSize)size;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)setSize:(CGSize)size;

- (void)show;
- (void)dismiss;

@end
