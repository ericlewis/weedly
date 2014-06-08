//
//  EELDispensaryDetailViewController.m
//  weedly
//
//  Created by 1debit on 6/7/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDispensaryDetailViewController.h"
#import "AAPLSegmentedDataSource.h"
#import "EELDispensaryDetailDataSource.h"
#import "EELReviewsDataSource.h"

//#import "AAPLCatDetailHeader.h"

@interface EELDispensaryDetailViewController ()
@property (nonatomic, strong) AAPLSegmentedDataSource *dataSource;
@property (nonatomic, strong) EELDispensaryDetailDataSource *detailDataSource;
@property (nonatomic, strong) EELReviewsDataSource *sightingsDataSource;
@property (nonatomic, strong) id selectedDataSourceObserver;
@end

@implementation EELDispensaryDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[AAPLSegmentedDataSource alloc] init];
    self.detailDataSource = [self newDetailDataSource];
    self.sightingsDataSource = [self newReviewsDataSource];
    
    [self.dataSource addDataSource:self.detailDataSource];
    [self.dataSource addDataSource:self.sightingsDataSource];
        
    self.collectionView.dataSource = self.dataSource;
}

- (EELDispensaryDetailDataSource *)newDetailDataSource
{
    EELDispensaryDetailDataSource *dataSource = [[EELDispensaryDetailDataSource alloc] initWithDispensary:self.dispensary];
    dataSource.title = NSLocalizedString(@"Info", @"Title of cat details section");
    
    dataSource.noContentTitle = NSLocalizedString(@"No Cat", @"The title of the placeholder to show if the cat has no data");
    dataSource.noContentMessage = NSLocalizedString(@"This cat has no information.", @"The message to show when the cat has no information");
    
    dataSource.errorTitle = NSLocalizedString(@"Unable to Load", @"Error message title to show when unable to load cat details");
    
    NSString *errorMessage = NSLocalizedString(@"A network problem occurred loading details for “%@”.", @"Error message to show when unable to load cat details.");
    dataSource.errorMessage = [NSString localizedStringWithFormat:errorMessage, self.dispensary.name];
    
    return dataSource;
}

- (EELReviewsDataSource *)newReviewsDataSource
{
    EELReviewsDataSource *dataSource = [[EELReviewsDataSource alloc] initWithDispensary:self.dispensary];
    dataSource.title = NSLocalizedString(@"Reviews", @"Title of cat sightings section");
    dataSource.noContentTitle = NSLocalizedString(@"No Sightings", @"Title of the no sightings placeholder message");
    dataSource.noContentMessage = NSLocalizedString(@"This cat has not been sighted recently.", @"The message to show when the cat has not been sighted recently");
    
    dataSource.defaultMetrics.separatorColor = [UIColor colorWithWhite:224/255.0 alpha:1];
    dataSource.defaultMetrics.separatorInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    dataSource.defaultMetrics.rowHeight = AAPLRowHeightVariable;
    
    return dataSource;
}

@end
