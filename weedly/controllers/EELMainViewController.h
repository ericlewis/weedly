//
//  EELMainViewController.h
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EELMainViewController : UIViewController<MKMapViewDelegate, UISearchBarDelegate, UITextFieldDelegate>

@property (strong, nonatomic) EELDispensary *selectedDispensary;

@end
