//
//  EELNavigationController.m
//  weedly
//
//  Created by 1debit on 9/10/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELNavigationController.h"

@interface EELNavigationController ()

@end

@implementation EELNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSUInteger) supportedInterfaceOrientations {
    if (self.viewControllers.count > 0){
        return [[self.viewControllers objectAtIndex:[self.viewControllers count] - 1] supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskAll;
}

@end
