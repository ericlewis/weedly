//
//  EELMapHeaderTableViewCell.m
//  weedly
//
//  Created by 1debit on 5/4/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMapHeaderTableViewCell.h"

@implementation EELMapHeaderTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [self.mapView setDelegate:self];
    [self.mapView setUserInteractionEnabled:NO];
}

- (void)zoomToLocation{
    // hack for now
    MKCoordinateRegion region;
    region.center = CLLocationCoordinate2DMake(self.dispensary.lat, self.dispensary.lng);
    
    MKCoordinateSpan span;
    span.latitudeDelta  = 0.0015; // Change these values to change the zoom
    span.longitudeDelta = 0.0015;
    region.span = span;
    
    [self.mapView setRegion:region animated:NO];
}

- (void)addPin{
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    CLLocation *location = MakeLocation(self.dispensary.lat, self.dispensary.lng);
    annotation.coordinate = [location coordinate];
    [self.mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.enabled = NO;
    
    EELDispensary *disp = self.dispensary;
    
    // disp
    if (disp.type == 0) {
        if (disp.featured == 4) {
            annotationView.image = [UIImage imageNamed:@"featured_marker"];
        }else{
            annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_marker", disp.icon]];
        }
    }
    
    // doctor
    else if(disp.type == 1){
        if (disp.featured == 4) {
            // gold
            annotationView.image = [UIImage imageNamed:@"doctor_marker_featured"];
        }else if (disp.featured == 1){
            // bronze
            annotationView.image = [UIImage imageNamed:@"dr_bronze_marker"];
        }else if (disp.featured == 0){
            // free
            annotationView.image = [UIImage imageNamed:@"doctor_marker"];
        }else{
            // else
            annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_marker", disp.icon]];
        }
    }
    
    return annotationView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
