//
//  EELMapHeaderTableViewCell.h
//  weedly
//
//  Created by Eric Lewis on 5/4/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EELMapHeaderTableViewCell : UITableViewCell<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) EELDispensary *dispensary;

- (void)zoomToLocation;
- (void)addPin;

@end
