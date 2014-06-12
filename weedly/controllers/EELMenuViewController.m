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
#import "EELFlowerMenuItemsDataSource.h"
#import "EELConcentratesMenuItemsDataSource.h"
#import "EELEdiblesMenuItemsDataSource.h"

#import "EELDetailHeader.h"

@interface EELMenuViewController ()
@property (nonatomic, strong) AAPLSegmentedDataSource *dataSource;
@property (nonatomic, strong) EELMenuDataSource *menuDataSource;
@property (nonatomic, strong) EELFlowerMenuItemsDataSource *itemsDataSource;
@property (nonatomic, strong) EELConcentratesMenuItemsDataSource *itemsConcentrateDataSource;
@property (nonatomic, strong) EELEdiblesMenuItemsDataSource *itemsEdibleDataSource;

@end

@implementation EELMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Menu";
    
    self.dataSource = [[AAPLSegmentedDataSource alloc] init];
    self.menuDataSource = [self newMenuDataSource];
    
    self.itemsDataSource = [self newMenuItemsDataSource];
    self.itemsConcentrateDataSource = [self newMenuItemsConcentratesDataSource];
    self.itemsEdibleDataSource = [self newMenuItemsEdiblesDataSource];
    
    [self.dataSource addDataSource:self.itemsDataSource];
    [self.dataSource addDataSource:self.itemsConcentrateDataSource];
    [self.dataSource addDataSource:self.itemsEdibleDataSource];
    
    __weak typeof(&*self) weakself = self;
    
    AAPLLayoutSupplementaryMetrics *globalHeader = [self.dataSource newHeaderForKey:@"globalHeader"];
    globalHeader.visibleWhileShowingPlaceholder = YES;
    globalHeader.height = 110;
    globalHeader.supplementaryViewClass = [EELDetailHeader class];
    globalHeader.configureView = ^(UICollectionReusableView *view, AAPLDataSource *dataSource, NSIndexPath *indexPath) {
        NSLog(@"%@", [self.menuDataSource itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]);
        
        EELDetailHeader *headerView = (EELDetailHeader *)view;
        headerView.bottomBorderColor = nil;
        [headerView configureWithDispensary:weakself.dispensary];
    };
    
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
    dataSource.defaultMetrics.separatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    return dataSource;
}

- (EELFlowerMenuItemsDataSource *)newMenuItemsDataSource
{
    EELFlowerMenuItemsDataSource *dataSource = [[EELFlowerMenuItemsDataSource alloc] initWithDispensary:self.dispensary];
    dataSource.title = NSLocalizedString(@"Flowers", @"Title of reviews section");
    dataSource.noContentTitle = NSLocalizedString(@"No menu items", @"Title of the no reviews placeholder message");
    dataSource.noContentMessage = NSLocalizedString(@"No flowers are currently available.", @"The message to show when the flowers are empty");
    
    dataSource.defaultMetrics.separatorColor = [UIColor colorWithWhite:224/255.0 alpha:1];
    dataSource.defaultMetrics.separatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    dataSource.defaultMetrics.rowHeight = 55;
    
    return dataSource;
}

- (EELConcentratesMenuItemsDataSource *)newMenuItemsConcentratesDataSource
{
    EELConcentratesMenuItemsDataSource *dataSource = [[EELConcentratesMenuItemsDataSource alloc] initWithDispensary:self.dispensary];
    dataSource.title = NSLocalizedString(@"Concentrates", @"Title of reviews section");
    dataSource.noContentTitle = NSLocalizedString(@"No menu items", @"Title of the no reviews placeholder message");
    dataSource.noContentMessage = NSLocalizedString(@"No concentrates are currently available.", @"The message to show when the concentrates are empty");
    
    dataSource.defaultMetrics.separatorColor = [UIColor colorWithWhite:224/255.0 alpha:1];
    dataSource.defaultMetrics.separatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    dataSource.defaultMetrics.rowHeight = 55;
    
    return dataSource;
}

- (EELEdiblesMenuItemsDataSource *)newMenuItemsEdiblesDataSource
{
    EELEdiblesMenuItemsDataSource *dataSource = [[EELEdiblesMenuItemsDataSource alloc] initWithDispensary:self.dispensary];
    dataSource.title = NSLocalizedString(@"Edibles", @"Title of reviews section");
    dataSource.noContentTitle = NSLocalizedString(@"No menu items", @"Title of the no reviews placeholder message");
    dataSource.noContentMessage = NSLocalizedString(@"No edibles are currently available.", @"The message to show when the edibles are empty");
    
    dataSource.defaultMetrics.separatorColor = [UIColor colorWithWhite:224/255.0 alpha:1];
    dataSource.defaultMetrics.separatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    dataSource.defaultMetrics.rowHeight = 55;
    
    return dataSource;
}

@end
