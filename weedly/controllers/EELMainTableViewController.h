//
//  EELMainTableViewController.h
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EELMainTableViewController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) EELDispensary *selectedDispensary;
@property (strong, nonatomic) NSString *searchTerm;
@property (nonatomic, assign) NSInteger searchType;

@end
