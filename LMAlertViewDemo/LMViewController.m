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

@property (strong, nonatomic) LMAlertView* ratingAlertView;
@property (strong, nonatomic) LMAlertView* cardAlertView;

@end

@implementation LMViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nativeButtonTapped:(id)sender
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Test" message:@"Message here" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
	
	[alertView show];
}

- (IBAction)vcButtonTapped:(id)sender
{
	LMAlertView *customAlertView = [[LMAlertView alloc] initWithSize:CGSizeMake(290, 200)];
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
	UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"navigationModal"];
	navigationController.view.frame = customAlertView.contentView.frame;
	navigationController.view.backgroundColor = [UIColor clearColor];
	[navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	navigationController.navigationBar.translucent = YES;
	navigationController.navigationBar.barStyle = UIBarStyleDefault;
	navigationController.navigationBar.backgroundColor = [UIColor clearColor];
	navigationController.visibleViewController.view.backgroundColor = [UIColor clearColor];
	
	[customAlertView.contentView addSubview:navigationController.view];
	
	[customAlertView show];
}

- (IBAction)customButtonTapped:(id)sender
{
	LMAlertView *customAlertView = [[LMAlertView alloc] initWithTitle:@"Test" message:@"Message here" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
	
	[customAlertView show];
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
	
	UIImageView *card1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Visa"]];
	card1ImageView.frame = CGRectMake(45.0, 55.0, card1ImageView.frame.size.width, card1ImageView.frame.size.height);
	[contentView addSubview:card1ImageView];
	
	UILabel *card1Label = [[UILabel alloc] initWithFrame:CGRectMake(45.0, 87.0, card1ImageView.frame.size.width, 21.0)];
	card1Label.text = @"4056";
	card1Label.font = [UIFont systemFontOfSize:13.0];
	card1Label.textAlignment = NSTextAlignmentCenter;
	[contentView addSubview:card1Label];
	
	UIImageView *card2ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MasterCard"]];
	card2ImageView.frame = CGRectMake(110.0, 55.0, card1ImageView.frame.size.width, card1ImageView.frame.size.height);
	[contentView addSubview:card2ImageView];
	
	UILabel *card2Label = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 87.0, card1ImageView.frame.size.width, 21.0)];
	card2Label.text = @"3123";
	card2Label.font = [UIFont systemFontOfSize:13.0];
	card2Label.textAlignment = NSTextAlignmentCenter;
	[contentView addSubview:card2Label];
	
	UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
	addButton.frame = CGRectMake(175.0, 55.0, 51.0, 32.0);
	[addButton setImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
	[contentView addSubview:addButton];
	
	[self.cardAlertView show];
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
