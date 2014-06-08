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

#import "AAPLCatDetailHeader.h"

@interface EELDispensaryDetailViewController ()
@property (nonatomic, strong) AAPLSegmentedDataSource *dataSource;
@property (nonatomic, strong) EELDispensaryDetailDataSource *detailDataSource;
@property (nonatomic, strong) EELReviewsDataSource *reviewsDataSource;
@property (nonatomic, strong) id selectedDataSourceObserver;
@end

@implementation EELDispensaryDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.dispensary.name;
    
    self.dataSource = [[AAPLSegmentedDataSource alloc] init];
    self.detailDataSource = [self newDetailDataSource];
    self.reviewsDataSource = [self newReviewsDataSource];
    
    [self.dataSource addDataSource:self.detailDataSource];
    [self.dataSource addDataSource:self.reviewsDataSource];

    __weak typeof(&*self) weakself = self;

    AAPLLayoutSupplementaryMetrics *globalHeader = [self.dataSource newHeaderForKey:@"globalHeader"];
    globalHeader.visibleWhileShowingPlaceholder = YES;
    globalHeader.height = 100;
    globalHeader.supplementaryViewClass = [AAPLCatDetailHeader class];
    globalHeader.configureView = ^(UICollectionReusableView *view, AAPLDataSource *dataSource, NSIndexPath *indexPath) {
        AAPLCatDetailHeader *headerView = (AAPLCatDetailHeader *)view;
        headerView.bottomBorderColor = nil;
        [headerView configureWithDispensary:weakself.dispensary];
    };
        
    self.collectionView.dataSource = self.dataSource;
}

- (EELDispensaryDetailDataSource *)newDetailDataSource
{
    EELDispensaryDetailDataSource *dataSource = [[EELDispensaryDetailDataSource alloc] initWithDispensary:self.dispensary];
    dataSource.title = NSLocalizedString(@"Info", @"Title of dispensary details section");
    
    dataSource.noContentTitle = NSLocalizedString(@"No Dispensary", @"The title of the placeholder to show if the dispensary has no data");
    dataSource.noContentMessage = NSLocalizedString(@"This dispensary has no information.", @"The message to show when the dispensary has no information");
    
    dataSource.errorTitle = NSLocalizedString(@"Unable to Load", @"Error message title to show when unable to load dispensary details");
    
    NSString *errorMessage = NSLocalizedString(@"A network problem occurred loading details for “%@”.", @"Error message to show when unable to load cat details.");
    dataSource.errorMessage = [NSString localizedStringWithFormat:errorMessage, self.dispensary.name];
    
    return dataSource;
}

- (EELReviewsDataSource *)newReviewsDataSource
{
    EELReviewsDataSource *dataSource = [[EELReviewsDataSource alloc] initWithDispensary:self.dispensary];
    dataSource.title = NSLocalizedString(@"Reviews", @"Title of reviews section");
    dataSource.noContentTitle = NSLocalizedString(@"No Reviews", @"Title of the no reviews placeholder message");
    dataSource.noContentMessage = NSLocalizedString(@"No reviews are currently available.", @"The message to show when the reviews are empty");
    
    dataSource.defaultMetrics.separatorColor = [UIColor colorWithWhite:224/255.0 alpha:1];
    dataSource.defaultMetrics.separatorInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    dataSource.defaultMetrics.rowHeight = AAPLRowHeightVariable;
    
    return dataSource;
}

@end
