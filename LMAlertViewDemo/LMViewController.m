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
#import "LMModalItemTableViewCell.h"

@interface LMViewController ()

// ratingAlertView is a property so we can retain its state (number of stars)
@property (strong, nonatomic) LMAlertView *ratingAlertView;

@end

@implementation LMViewController

#pragma mark UIAlertViewDelegate delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"%@: Clicked button at index: %li", [alertView class] , (long)buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSLog(@"%@: Did dismiss with button at index: %li", [alertView class] , (long)buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSLog(@"%@: Will dismiss with button at index: %li", [alertView class] , (long)buttonIndex);
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
	NSLog(@"%@: Will present alert view", [alertView class]);
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
	NSLog(@"%@: Did present alert view", [alertView class]);
}

#pragma mark EDStarRatingProtocol delegate methods

- (void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
	NSString *ratingDescription;
	
	switch ([[NSNumber numberWithFloat:rating] integerValue]) {
		case 0:
			ratingDescription = @"Not yet rated";
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
	
	LMModalItemTableViewCell *cell = [self.ratingAlertView buttonCellForIndex:self.ratingAlertView.firstOtherButtonIndex];
	cell.isEnabled = (rating > 0);
	
	self.ratingAlertView.message = ratingDescription;
}

#pragma mark - IBActions

- (IBAction)nativeButtonTapped:(id)sender
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Test" message:@"Message here" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	
	NSLog(@"%@: First other button index: %li", [alertView class], (long)alertView.firstOtherButtonIndex);
	NSLog(@"%@: Cancel button index: %li", [alertView class], (long)alertView.cancelButtonIndex);
	NSLog(@"%@: Number of buttons: %li", [alertView class], (long)alertView.numberOfButtons);
	
	[alertView show];
}

- (IBAction)customButtonTapped:(id)sender
{
//    LMAlertView *alertView = [[LMAlertView alloc] initWithTitle:@"Test" message:@"Message here" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//
//    //[alertView addButtonWithTitle:@"3rd"];
//    for (NSInteger titleIndex = 0; titleIndex < alertView.numberOfButtons; titleIndex++) {
//        NSLog(@"%@: button title for index %i is: %@", [alertView class], titleIndex, [alertView buttonTitleAtIndex:titleIndex]);
//    }
//    
//	NSLog(@"%@: First other button index: %li", [alertView class], (long)alertView.firstOtherButtonIndex);
//	NSLog(@"%@: Cancel button index: %li", [alertView class], (long)alertView.cancelButtonIndex);
//	NSLog(@"%@: Number of buttons: %li", [alertView class], (long)alertView.numberOfButtons);
//	
//	[alertView show];
}

- (IBAction)ratingButtonTapped:(id)sender
{
	if (self.ratingAlertView != nil) {
		[self.ratingAlertView show];
		return;
	}
	
	self.ratingAlertView = [[LMAlertView alloc] initWithTitle:@"Rate this movie" message:@"Average" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Rate", nil];
	CGSize size = self.ratingAlertView.size;
	
	LMModalItemTableViewCell *cell = [self.ratingAlertView buttonCellForIndex: self.ratingAlertView.firstOtherButtonIndex];
	cell.isEnabled = NO;
	
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
	starRating.rating = 0;
	starRating.backgroundColor = [UIColor clearColor];
	
	[contentView addSubview:starRating];
	
	[self.ratingAlertView show];
}

- (IBAction)cardButtonTapped:(id)sender
{
	LMAlertView *cardAlertView = [[LMAlertView alloc] initWithTitle:@"Choose a card" message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
	[cardAlertView setSize:CGSizeMake(270.0, 167.0)];
	
	UIView *contentView = cardAlertView.contentView;
	
	CGFloat yOffset = 55.0;
	
	UIImageView *card1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Visa"]];
	card1ImageView.frame = CGRectMake(45.0, yOffset, card1ImageView.frame.size.width, card1ImageView.frame.size.height);
	card1ImageView.layer.cornerRadius = 5.0;
	card1ImageView.layer.masksToBounds = YES;
	[contentView addSubview:card1ImageView];
	
	UIImageView *card2ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MasterCard"]];
	card2ImageView.frame = CGRectMake(110.0, yOffset, card1ImageView.frame.size.width, card1ImageView.frame.size.height);
	card2ImageView.layer.cornerRadius = 5.0;
	card2ImageView.layer.masksToBounds = YES;
	[contentView addSubview:card2ImageView];
	
	UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
	addButton.frame = CGRectMake(175.0, yOffset, 51.0, 32.0);
	addButton.layer.cornerRadius = 5.0;
	addButton.layer.masksToBounds = YES;
	addButton.layer.borderWidth = 1.0;
	addButton.layer.borderColor = addButton.tintColor.CGColor;
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
	
	[cardAlertView show];
}

@end
