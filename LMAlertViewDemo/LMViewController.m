//
//  LMViewController.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 11/11/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMViewController.h"
#import "LMAppDelegate.h"
#import "LMAlertView.h"

@interface LMViewController ()

@property (strong, nonatomic) LMAlertView *ratingAlertView;
@property (strong, nonatomic) LMAlertView *cardAlertView;

@end

@implementation LMViewController

- (IBAction)nativeButtonTapped:(id)sender
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Test" message:@"Message here" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	
	alertView.delegate = self;
	
	[alertView show];
}

- (IBAction)customButtonTapped:(id)sender
{
	LMAlertView *alertView = [[LMAlertView alloc] initWithTitle:@"Test" message:@"Message here" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	
	alertView.delegate = self;
	
	[alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"Clicked button at index: %li", (long)buttonIndex);
}

- (IBAction)ratingButtonTapped:(id)sender
{
	if (self.ratingAlertView != nil) {
		[self.ratingAlertView show];
		return;
	}
	
	self.ratingAlertView = [[LMAlertView alloc] initWithTitle:@"Rate this movie" message:@"Average" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
	CGSize size = self.ratingAlertView.size;
	[self.ratingAlertView setSize:CGSizeMake(size.width, 152.0)];
	
	UIView *contentView = self.ratingAlertView.contentView;
	
	EDStarRating *starRating = [[EDStarRating alloc] initWithFrame:CGRectMake((size.width/2.0 - 190.0/2.0), 55.0, 190.0, 50.0)];
	starRating.starImage = [UIImage imageNamed:@"StarEmpty"];
	starRating.starHighlightedImage = [UIImage imageNamed:@"StarFull"];
	starRating.maxRating = 5.0;
	starRating.delegate = self;
	starRating.horizontalMargin = 12.0;
	starRating.editable = YES;
	starRating.displayMode = EDStarRatingDisplayFull;
	starRating.rating = 3;
	starRating.backgroundColor = [UIColor clearColor];
	
	[contentView addSubview:starRating];
	
	[self.ratingAlertView show];
}

- (IBAction)cardButtonTapped:(id)sender
{
	self.cardAlertView = [[LMAlertView alloc] initWithTitle:@"Choose a card" message:nil delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
	[self.cardAlertView setSize:CGSizeMake(270.0, 167.0)];
	
	UIView *contentView = self.cardAlertView.contentView;
	
	CGFloat yOffset = 55.0;
	
	UIImageView *card1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Visa"]];
	card1ImageView.frame = CGRectMake(45.0, yOffset, card1ImageView.frame.size.width, card1ImageView.frame.size.height);
	[contentView addSubview:card1ImageView];
	
	UIImageView *card2ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MasterCard"]];
	card2ImageView.frame = CGRectMake(110.0, yOffset, card1ImageView.frame.size.width, card1ImageView.frame.size.height);
	[contentView addSubview:card2ImageView];
	
	UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
	addButton.frame = CGRectMake(175.0, yOffset, 51.0, 32.0);
	[addButton setImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
	[contentView addSubview:addButton];
	
	yOffset += 32.0;
	
	UILabel *card1Label = [[UILabel alloc] initWithFrame:CGRectMake(45.0, yOffset, card1ImageView.frame.size.width, 21.0)];
	card1Label.text = @"4056";
	card1Label.font = [UIFont systemFontOfSize:13.0];
	card1Label.textAlignment = NSTextAlignmentCenter;
	[contentView addSubview:card1Label];
	
	UILabel *card2Label = [[UILabel alloc] initWithFrame:CGRectMake(110.0, yOffset, card1ImageView.frame.size.width, 21.0)];
	card2Label.text = @"3123";
	card2Label.font = [UIFont systemFontOfSize:13.0];
	card2Label.textAlignment = NSTextAlignmentCenter;
	[contentView addSubview:card2Label];
	
	[self.cardAlertView show];
}

- (IBAction)unwindFromViewController2:(UIStoryboardSegue *)sender {
	NSLog(@"unwind yo");
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    // Instantiate a new CustomUnwindSegue
    //CustomUnwindSegue *segue = [[CustomUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    // Set the target point for the animation to the center of the button in this VC
    //segue.targetPoint = self.segueButton.center;
	
	NSLog(@"toviewcontroller: %@", toViewController);
	
	NSLog(@"from: %@", fromViewController);
	
    return nil;
}

- (void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
	NSString *ratingDescription;
	
	switch ([[NSNumber numberWithFloat:rating] integerValue]) {
		case 0:
			ratingDescription = @"Abysmal";
			break;
		case 1:
			ratingDescription = @"Piss poor";
			break;
		case 2:
			ratingDescription = @"Ok I guess";
			break;
		case 3:
			ratingDescription = @"Average";
			break;
		case 4:
			ratingDescription = @"Pretty good";
			break;
		case 5:
			ratingDescription = @"Freaking amazing";
			break;
		default:
			return;
	}
	
	self.ratingAlertView.message = ratingDescription;
}

@end
