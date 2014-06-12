//
//  EELMenuViewController.m
//  weedly
//
//  Created by 1debit on 6/11/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMenuViewController.h"

#import "AAPLSegmentedDataSource.h"
#import "EELMenuDataSource.h"
#import "EELMenuItemsDataSource.h"

@interface EELMenuViewController ()
@property (nonatomic, strong) AAPLSegmentedDataSource *dataSource;
@property (nonatomic, strong) EELMenuDataSource *menuDataSource;
@property (nonatomic, strong) EELMenuItemsDataSource *itemsDataSource;
@end

@implementation EELMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.dispensary formattedNameString];
    
    self.dataSource = [[AAPLSegmentedDataSource alloc] init];
    self.menuDataSource = [self newMenuDataSource];
    
    self.itemsDataSource = [self newMenuItemsDataSource];
    
    [self.dataSource addDataSource:self.itemsDataSource];
    
    self.collectionView.dataSource = self.dataSource;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

- (EELMenuDataSource *)newMenuDataSource
{
    EELMenuDataSource *dataSource = [[EELMenuDataSource alloc] initWithDispensary:self.dispensary];
    dataSource.title = NSLocalizedString(@"Info", @"Title of dispensary details section");
    
    dataSource.noContentTitle = NSLocalizedString(@"No Dispensary", @"The title of the placeholder to show if the dispensary has no data");
    dataSource.noContentMessage = NSLocalizedString(@"This dispensary has no information.", @"The message to show when the dispensary has no information");
    
    dataSource.errorTitle = NSLocalizedString(@"Unable to Load", @"Error message title to show when unable to load dispensary details");
    
    NSString *errorMessage = NSLocalizedString(@"A network problem occurred loading details for “%@”.", @"Error message to show when unable to load cat details.");
    dataSource.errorMessage = [NSString localizedStringWithFormat:errorMessage, self.dispensary.name];
    
    dataSource.defaultMetrics.separatorColor = [UIColor colorWithWhite:224/255.0 alpha:1];
    dataSource.defaultMetrics.separatorInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    
    return dataSource;
}

- (EELMenuItemsDataSource *)newMenuItemsDataSource
{
    EELMenuItemsDataSource *dataSource = [[EELMenuItemsDataSource alloc] initWithDispensary:self.dispensary];
    dataSource.title = NSLocalizedString(@"Menu", @"Title of reviews section");
    dataSource.noContentTitle = NSLocalizedString(@"No Reviews", @"Title of the no reviews placeholder message");
    dataSource.noContentMessage = NSLocalizedString(@"No reviews are currently available.", @"The message to show when the reviews are empty");
    
    dataSource.defaultMetrics.separatorColor = [UIColor colorWithWhite:224/255.0 alpha:1];
    dataSource.defaultMetrics.separatorInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    dataSource.defaultMetrics.rowHeight = 55;
    
    return dataSource;
}

@end
