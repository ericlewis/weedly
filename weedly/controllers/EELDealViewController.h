//
//  EELDealViewController.h
//  weedly
//
//  Created by Eric LEwis on 6/24/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EELDealViewController : UIViewController<UIWebViewDelegate>

- (void)loadDealsWithDispensary:(EELDispensary *)dispensary;

@end
