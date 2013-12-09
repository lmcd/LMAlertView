//
//  LMTwitterLocationViewController.h
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 07/12/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface LMTwitterLocationViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end
