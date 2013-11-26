//
//  LMViewController.h
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 11/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"

@interface LMViewController : UIViewController <EDStarRatingProtocol, UIAlertViewDelegate>

- (IBAction)nativeButtonTapped:(id)sender;
- (IBAction)customButtonTapped:(id)sender;
- (IBAction)cardButtonTapped:(id)sender;
- (IBAction)ratingButtonTapped:(id)sender;

@property (nonatomic, strong) UILabel *ratingDescriptionLabel;

@end
