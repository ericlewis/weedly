//
//  EELDispensaryDetailViewController.m
//  weedly
//
//  Created by Eric LEwis on 6/7/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMainViewController.h"
#import "EELDetailViewController.h"
#import "EELMenuViewController.h"
#import "EELDealViewController.h"

#import "AAPLSegmentedDataSource.h"
#import "EELDispensaryDetailDataSource.h"
#import "EELReviewsDataSource.h"

#import "EELDetailHeader.h"

@interface EELDetailViewController ()
@property (nonatomic, strong) AAPLSegmentedDataSource *dataSource;
@property (nonatomic, strong) EELDispensaryDetailDataSource *detailDataSource;
@property (nonatomic, strong) EELReviewsDataSource *reviewsDataSource;
@property (nonatomic, strong) UIViewController *backViewController;
@end

@implementation EELDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.dispensary formattedNameString];
    
    self.dataSource = [[AAPLSegmentedDataSource alloc] init];
    self.detailDataSource = [self newDetailDataSource];
    self.reviewsDataSource = [self newReviewsDataSource];
    
    [self.dataSource addDataSource:self.detailDataSource];
    [self.dataSource addDataSource:self.reviewsDataSource];

    __weak typeof(&*self) weakself = self;

    AAPLLayoutSupplementaryMetrics *globalHeader = [self.dataSource newHeaderForKey:@"globalHeader"];
    globalHeader.visibleWhileShowingPlaceholder = YES;
    globalHeader.height = 110;
    globalHeader.supplementaryViewClass = [EELDetailHeader class];
    globalHeader.configureView = ^(UICollectionReusableView *view, AAPLDataSource *dataSource, NSIndexPath *indexPath) {
        EELDetailHeader *headerView = (EELDetailHeader *)view;
        headerView.bottomBorderColor = nil;
        [headerView configureWithDispensary:weakself.dispensary];
    };
        
    self.collectionView.dataSource = self.dataSource;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([self.backViewController isKindOfClass:[EELMainViewController class]]) {
        [(id)self.backViewController hideSearchBar];
    }
}

- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
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
    
    dataSource.defaultMetrics.separatorColor = [UIColor colorWithWhite:224/255.0 alpha:1];
    dataSource.defaultMetrics.separatorInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    dataSource.defaultMetrics.rowHeight = AAPLRowHeightVariable;
    
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

- (void)toggleFavorite:(id)sender
{
    self.dispensary.favorite = !self.dispensary.favorite;
    
    // should check + write the favorites here with NSArchiver into a KV array- hash of dispensary : dispensary
    NSMutableArray *favoritesOnDisk = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY]];
    
    if ([favoritesOnDisk containsObject:self.dispensary]) {
        [favoritesOnDisk removeObject:self.dispensary];
    }else{
        favoritesOnDisk = [[NSMutableArray alloc] initWithObjects:self.dispensary, nil];
    }

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:favoritesOnDisk];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:FAVORITES_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowMenu"]) {
        EELMenuViewController *controller = segue.destinationViewController;
        controller.dispensary = self.dispensary;
    }else if ([segue.identifier isEqualToString:@"ShowDeals"]) {
        EELDealViewController *controller = segue.destinationViewController;
        [controller loadDealsWithDispensary:self.dispensary];
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // selected the info tab
    if ([self.dataSource.selectedDataSource isKindOfClass:[EELDispensaryDetailDataSource class]]) {
        NSDictionary *menuItem = [self.dataSource.selectedDataSource itemAtIndexPath:indexPath];
        
        if ([menuItem[@"segue"] isEqualToString:@"ShowMenu"]) {
            [self performSegueWithIdentifier:menuItem[@"segue"] sender:self];

        }else if([menuItem[@"segue"] isEqualToString:@"ShowDirections"]){
            CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(self.dispensary.lat, self.dispensary.lng);
            
            MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:coords addressDictionary: nil];
            MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark: place];
            destination.name = [self.dispensary formattedNameString];
            NSArray *items = [[NSArray alloc] initWithObjects:destination, nil];
            NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     MKLaunchOptionsDirectionsModeDriving,
                                     MKLaunchOptionsDirectionsModeKey, nil];
            [MKMapItem openMapsWithItems:items launchOptions:options];
            
        }else if([menuItem[@"segue"] isEqualToString:@"ShowPhonePrompt"]){
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"telprompt://"]]) {
                NSString *phoneNumber = [@"telprompt://" stringByAppendingString:[[self.dispensary.phone componentsSeparatedByCharactersInSet:
                                                                                   [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                                                                  componentsJoinedByString:@""]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            }else{
                // can't open phones
            }

        }else if([menuItem[@"segue"] isEqualToString:@"ShowDeals"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://weedmaps.com/dispensaries/%@/deals/420", self.dispensary.id]]];
        }
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

@end
