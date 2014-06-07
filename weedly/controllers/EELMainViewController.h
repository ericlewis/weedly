//
//  EELMainViewController.h
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EELMainViewController : SLParallaxController<MKMapViewDelegate, UISearchBarDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, SLParallaxControllerDelegate>

@property (strong, nonatomic) EELDispensary *selectedDispensary;

@end
