//
//  EELMainViewController.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMainViewController.h"

#import "EELDealsViewController.h"
#import "EELFavoritesTableViewController.h"
#import "EELMainTableViewController.h"
#import "EELDetailTableViewController.h"
#import "EELItemHeaderViewCell.h"

#import "EELArrayDataSource.h"

#define LATITUDE_OFFSET -0.01f

@interface EELMainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView   *mapView;
@property (weak, nonatomic) IBOutlet MTLocateMeButton *findMeButton;
@property (weak, nonatomic) IBOutlet UIButton *dealsButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@property (strong, nonatomic) REMenu *filterMenu;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) EELArrayDataSource *dataSource;
@property (strong, nonatomic) CWStatusBarNotification *notification;

@end

@implementation EELMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupKVO];
    [self setupLocationManager];
    [self setupSearchBar];
    
    [self getInitialListings];
    
    [self performSelector:@selector(zoomToUserNotAnimated) withObject:self afterDelay:0.2];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EELItemHeaderViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemHeaderCell"];
    self.mapView.delegate = self;
    
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tableView.layer.borderWidth = 1.0;
}

- (void)viewWillAppear:(BOOL)animated{
    [self performSelector:@selector(showSearchBar) withObject:self afterDelay:0.15];
    
    // landscape fix search
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        if (IS_IPHONE_5) {
            self.searchBar.frame = CGRectMake(90, -6.5f, 400, 40);
        }else{
            self.searchBar.frame = CGRectMake(40, -6.5f, 400, 40);
        }
    }else{
        self.searchBar.frame = CGRectMake(45, 0, 230, 44);
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.searchBar resignFirstResponder];
    
    if (self.filterMenu.isOpen) {
        [self.filterMenu close];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    self.mapView.showsUserLocation = NO;
}

- (void)showSearchBar{
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    anim.springSpeed = 15.0;
    anim.toValue = @(1.0);
    [self.searchBar.layer pop_addAnimation:anim forKey:@"searchBarShow"];
}

- (void)hideSearchBar{
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    anim.springSpeed = 20.0;
    anim.toValue = @(0.0);
    [self.searchBar.layer pop_addAnimation:anim forKey:@"searchBarShow"];
}

#pragma mark -
#pragma mark setup
- (void)getInitialListings{
    [self performSearch:self.searchBar.text];
}

- (void)addPins{
    NSArray *oldAnnotations = self.mapView.annotations;
    NSArray *locations = self.dataSource.items;

    for (int i = 0; i < [locations count]; i++) {
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        annotation.title = [NSString stringWithFormat:@"%d", i];
        EELDispensary *merchant = locations[i];
        CLLocation *location = MakeLocation(merchant.lat, merchant.lng);
        annotation.coordinate = [location coordinate];
        
        [self.mapView addAnnotation:annotation];
    }
    
    [self.mapView removeAnnotations:oldAnnotations];
}

- (void)setupKVO{
    // create KVO controller with observer
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
}

- (void)setupLocationManager{
    // Configure Location Manager
    [MTLocationManager sharedInstance].locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [MTLocationManager sharedInstance].locationManager.distanceFilter = kCLDistanceFilterNone;
    [MTLocationManager sharedInstance].locationManager.headingFilter = 5; // 5 Degrees
    
    [MTLocationManager sharedInstance].mapView = self.mapView;
    [[MTLocationManager sharedInstance] setTrackingMode:MTUserTrackingModeFollow];
    
    [[MTLocationManager sharedInstance] whenLocationChanged:^(CLLocation *location) {
        MKCoordinateRegion region;
        region.center = location.coordinate;
        
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.15; // Change these values to change the zoom
        span.longitudeDelta = 0.15;
        region.span = span;
        
        [self.mapView setRegion:region animated:YES];
    }];
}

- (void)setupSearchBar{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 230, 44)];
    self.searchBar.center = CGPointMake(self.navigationController.navigationBar.center.x, self.navigationController.navigationBar.center.y / 2);
    
    // add the search bar to the navigation menu
    self.searchBar.delegate = self;
    
    self.searchBar.translucent = YES;
    self.searchBar.tintColor = [UIColor lightGrayColor];
    
    self.searchBar.placeholder = @"Search Dispensaries";
    self.searchBar.tag = 420;
    
    [self.navigationController.navigationBar addSubview:self.searchBar];
}

#pragma mark -
#pragma mark - Actions
- (void)performSearch:(NSString*)searchTerm{
    NSString *latVal = [NSString stringWithFormat:@"%.1f", self.mapView.centerCoordinate.latitude - LATITUDE_OFFSET];
    NSString *lngVal = [NSString stringWithFormat:@"%.1f", self.mapView.centerCoordinate.longitude];

    [self performSearch:searchTerm lat:(CGFloat)latVal.floatValue lng:(CGFloat)lngVal.floatValue];
}

- (void)performSearch:(NSString*)searchTerm lat:(CGFloat)lat lng:(CGFloat)lng{
    if (self.searchBar.tag == 420) {
        [[EELWMClient sharedClient] searchDispensariesWithTerm:searchTerm lat:lat lng:lng completionBlock:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"noooo: %@", error);
                return;
            }
            
            NSMutableArray *sortedArray = [results mutableCopy]; // your mutable copy of the fetched objects
            
            for (EELDispensary *project in sortedArray) {
                CLLocationDegrees lat = project.lat;
                CLLocationDegrees lng = project.lng;
                CLLocation *dispensaryLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
                CLLocationDistance meters = [dispensaryLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude - LATITUDE_OFFSET longitude:self.mapView.centerCoordinate.longitude]];
                project.currentDistance = @(meters);
            }
            
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"currentDistance" ascending:YES];
            [sortedArray sortUsingDescriptors:@[sort]];
            
            self.dataSource = [EELArrayDataSource dataSourceWithItems:sortedArray];
            
            [self addPins];
            [self.tableView reloadData];
        }];
    }else if(self.searchBar.tag == 911){
        [[EELWMClient sharedClient] searchDoctorsWithTerm:searchTerm lat:lat lng:lng completionBlock:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"noooo: %@", error);
                return;
            }
            
            NSMutableArray *sortedArray = [results mutableCopy]; // your mutable copy of the fetched objects
            
            for (EELDispensary *project in sortedArray) {
                CLLocationDegrees lat = project.lat;
                CLLocationDegrees lng = project.lng;
                CLLocation *dispensaryLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
                CLLocationDistance meters = [dispensaryLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude - LATITUDE_OFFSET longitude:self.mapView.centerCoordinate.longitude]];
                project.currentDistance = @(meters);
            }
            
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"currentDistance" ascending:YES];
            [sortedArray sortUsingDescriptors:@[sort]];
            
            self.dataSource = [EELArrayDataSource dataSourceWithItems:sortedArray];
            
            [self addPins];
            [self.tableView reloadData];
        }];
    }else{
        
        // needs to actually allow search on the objects
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
        
        NSMutableArray *sortedArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy]; // your mutable copy of the fetched objects
        
        for (EELDispensary *project in sortedArray) {
            CLLocationDegrees lat = project.lat;
            CLLocationDegrees lng = project.lng;
            CLLocation *dispensaryLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            CLLocationDistance meters = [dispensaryLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude]];
            project.currentDistance = @(meters);
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"currentDistance" ascending:YES];
        [sortedArray sortUsingDescriptors:@[sort]];
        
        self.dataSource = [EELArrayDataSource dataSourceWithItems:sortedArray];
        [self.tableView reloadData];

        [self addPins];
    }
}

- (IBAction)showSidebar:(id)sender {
    [self.searchBar resignFirstResponder];
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (IBAction)showFilterDropdown:(id)sender {
    if (self.filterMenu.isOpen) {
        [self.filterMenu close];
    }else{
        REMenuItem *dispensaryItem = [[REMenuItem alloc] initWithTitle:@"Dispensaries"
                                                           image:nil
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                              self.searchBar.placeholder = @"Search Dispensaries";
                                                              self.searchBar.tag = 420;
                                                              [self performSearch:self.searchBar.text];
                                                          }];
        
        REMenuItem *doctorItem = [[REMenuItem alloc] initWithTitle:@"Doctors"
                                                           image:nil
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                              self.searchBar.placeholder = @"Search Doctors";
                                                              self.searchBar.tag = 911;
                                                              [self performSearch:self.searchBar.text];
                                                          }];
        
        REMenuItem *favoriteItem = [[REMenuItem alloc] initWithTitle:@"Favorites"
                                                             image:nil
                                                  highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                NSLog(@"Item: %@", item);
                                                                self.searchBar.placeholder = @"Search Favorites";
                                                                self.searchBar.tag = 421;
                                                                
                                                                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
                                                                self.dataSource = [EELArrayDataSource dataSourceWithItems:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
                                                                [self addPins];
                                                                [self.tableView reloadData];
                                                            }];
        
        self.filterMenu = [[REMenu alloc] initWithItems:@[dispensaryItem, doctorItem, favoriteItem]];
        self.filterMenu.backgroundColor = MAIN_COLOR;
        self.filterMenu.borderColor = [UIColor grayColor];
        self.filterMenu.borderWidth = 0.5f;
        self.filterMenu.separatorColor = [UIColor clearColor];
        self.filterMenu.textColor = [UIColor whiteColor];
        self.filterMenu.textAlignment = NSTextAlignmentLeft;
        self.filterMenu.textOffset = CGSizeMake(50, 0);
        
        self.filterMenu.liveBlur = NO;
        
        [self.filterMenu showFromNavigationController:self.navigationController];
    }
}

- (void)zoomToUser{
    [self zoomToUser:YES];
}

- (void)zoomToUserNotAnimated{
    [self zoomToUser:NO];
}

- (void)zoomToUser:(BOOL)animated{
    if (self.mapView.userLocationVisible) {
        MKCoordinateRegion region;
        region.center = CLLocationCoordinate2DMake(self.mapView.userLocation.coordinate.latitude + LATITUDE_OFFSET, self.mapView.userLocation.coordinate.longitude);
        MKCoordinateSpan span;
        
        if (self.mapView.region.span.latitudeDelta > 1) {
            span.latitudeDelta  = 0.17; // Change these values to change the zoom
            span.longitudeDelta = 0.17;
            region.span = span;
        }else{
            region.span = self.mapView.region.span;
        }
        
        [self.mapView setRegion:region animated:animated];
    }else{
        MKCoordinateRegion region;
        region.center = CLLocationCoordinate2DMake(37.733972, -122.431297);
        
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.17; // Change these values to change the zoom
        span.longitudeDelta = 0.17;
        region.span = span;
        
        [self.mapView setRegion:region animated:animated];
    }
}

#pragma mark -
#pragma mark - MapKitDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    
    EELDispensary *disp = [self.dataSource.items objectAtIndex:[annotation.title integerValue]];
    
    // disp
    if (disp.type == 0) {
        if (disp.featured == 4) {
            annotationView.image = [UIImage imageNamed:@"featured_marker"];
        }else{
            annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_marker", disp.icon]];
        }
    }
    
    // doctor
    else if(disp.type == 1){
        if (disp.featured == 4) {
            // gold
            annotationView.image = [UIImage imageNamed:@"doctor_marker_featured"];
        }else if (disp.featured == 1){
            // bronze
            annotationView.image = [UIImage imageNamed:@"dr_bronze_marker"];
        }else if (disp.featured == 0){
            // free
            annotationView.image = [UIImage imageNamed:@"doctor_marker"];
        }else{
            // else
            annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_marker", disp.icon]];
        }
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];

    if (![view.annotation isKindOfClass:[MKUserLocation class]]) {
        self.selectedDispensary = [self.dataSource.items objectAtIndex:[view.annotation.title integerValue]];
        [self performSegueWithIdentifier:@"ShowItemDetail" sender:self];
    }
}

- (void) mapView:(MKMapView *)aMapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *view in views)
    {
        if ([[view annotation] isKindOfClass:[MKUserLocation class]])
        {
            [[view superview] bringSubviewToFront:view];
        }
        else
        {
            [[view superview] sendSubviewToBack:view];
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    for (NSObject *annotation in [mapView annotations])
    {
        if ([annotation isKindOfClass:[MKUserLocation class]])
        {
            MKAnnotationView *view = [mapView viewForAnnotation:(MKUserLocation *)annotation];
            [[view superview] bringSubviewToFront:view];
        }
    }
    
    [self performSearch:self.searchBar.text];
    
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowItemDetail"]) {
        [(id)[segue destinationViewController] setDispensary:self.selectedDispensary];
        [self hideSearchBar];
    }else if([[segue identifier] isEqualToString:@"ShowList"]){
        [(id)[[segue destinationViewController] topViewController] setSearchTerm:self.searchBar.text];
        [(id)[[segue destinationViewController] topViewController] setSearchType:self.searchBar.tag];
    }
}

#pragma mark -
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataSource.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EELItemHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemHeaderCell" forIndexPath:indexPath];
    EELDispensary *dispensary = [self.dataSource.items objectAtIndex:indexPath.row];
    
    // Configure the header cell
    cell.nameLabel.text = [dispensary formattedNameString];
    cell.typeLabel.text = [dispensary formattedTypeString];
    
    if (dispensary.opensAt.length > 0 && dispensary.closesAt.length > 0) {
        cell.hoursLabel.text = [NSString stringWithFormat:@"Hours: %@ - %@", dispensary.opensAt, dispensary.closesAt];
    }else{
        cell.hoursLabel.text = @"Hours unavailable";
    }
    
    // switch the text and color if we are closed
    if (dispensary.isOpen.boolValue) {
        cell.isOpenLabel.text = @"Currently Open";
    }else{
        cell.isOpenLabel.text = @"Currently Closed";
    }
    
    cell.isOpenLabel.textColor = MAIN_COLOR;
    
    // hide reviews if we don't have a count
    if (dispensary.ratingCount == 0) {
        [cell.reviewsView setHidden:YES];
    }else{
        [cell.reviewsView setHidden:NO];
        
        cell.reviewsLabel.text = [NSString stringWithFormat:@"%.1f • %i reviews", dispensary.rating, dispensary.ratingCount];
        [cell.reviewsLabel sizeToFit];
        
        CGFloat reviewStarsWidth = cell.reviewsStarsImage.frame.size.width;
        reviewStarsWidth = (reviewStarsWidth*2) * (dispensary.rating * 0.1);
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        maskLayer.frame = CGRectMake(0.0, 0.0, reviewStarsWidth, reviewStarsWidth);
        
        cell.reviewsStarsImage.layer.mask = maskLayer;
    }
    
    cell.addressLabel.text = [dispensary formattedAddressString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 122;
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedDispensary = [self.dataSource.items objectAtIndex:indexPath.row];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ShowItemDetail" sender:self];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f - %f", scrollView.frame.origin.y, scrollView.contentOffset.y);
    
    /*if(scrollView.frame.origin.y > 0){
        CGRect frame = scrollView.frame;
        frame.origin.y = scrollView.frame.origin.y-scrollView.contentOffset.y;
        frame.size.height = scrollView.frame.size.height+scrollView.contentOffset.y;
        scrollView.frame = frame;
        
        scrollView.contentOffset = CGPointMake(0, 0);
    }*/
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{

}

#pragma mark -
#pragma mark - UISearchDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self performSearch:self.searchBar.text];
    [searchBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    // non optimal hack for getting results back
    if (searchBar.text.length == 0) {
        [self performSearch:self.searchBar.text];
    }
    
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight || toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        if (IS_IPHONE_5) {
            self.searchBar.frame = CGRectMake(90, -6.5f, 400, 40);
        }else{
            self.searchBar.frame = CGRectMake(40, -6.5f, 400, 40);
        }
    }else{
        self.searchBar.frame = CGRectMake(45, 0, 230, 44);
    }
}

@end
