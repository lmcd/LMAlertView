//
//  LMTwitterLocationViewController.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 07/12/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMTwitterLocationViewController.h"
#import "LMModalViewController.h"

@interface LMTwitterLocationViewController ()

@end

@implementation LMTwitterLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
	[self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
	
    if (numberOfViewControllers < 2) {
        return nil;
	}
    else {
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(BOOL)!indexPath.row inSection:0]];
	lastCell.accessoryType = UITableViewCellAccessoryNone;
	
	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
	
	LMModalViewController *twitterViewController = (LMModalViewController *)[self backViewController];
	[twitterViewController setLocationTitle:selectedCell.textLabel.text];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
