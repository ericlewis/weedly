//
//  EELMainViewController.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMainViewController.h"
#import "EELDetailViewController.h"

#import "EELArrayDataSource.h"
#import "EELDetailHeader.h"

@interface EELMainViewController ()

@property (weak, nonatomic) IBOutlet MKMapView   *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;

@property (strong, nonatomic) REMenu *filterMenu;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) EELArrayDataSource *dataSource;

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
    
    [self setupLocationManager];
    [self setupSearchBar];
    
    [self getInitialListings];
    
    
    
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.collectionView.contentInset = UIEdgeInsetsMake(self.mapView.frame.size.height-40, 0, 0, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([EELDetailHeader class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([EELDetailHeader class])];
    
    UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    [panRec setDelegate:self];
    [self.mapView addGestureRecognizer:panRec];
    self.mapView.delegate = self;
    [self performSelector:@selector(zoomToUserNotAnimated) withObject:self afterDelay:0.2];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        [self performSearch:self.searchBar.text];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self performSelector:@selector(showSearchBar) withObject:self afterDelay:0.15];

    // landscape fix search
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        if (IS_IPHONE_5) {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                self.searchBar.frame = CGRectMake(90, -4.f, 400, 40);
            }else{
                self.searchBar.frame = CGRectMake(90, -6.5f, 400, 40);
            }
        }else{
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                self.searchBar.frame = CGRectMake(40, -4.f, 400, 40);
            }else{
                self.searchBar.frame = CGRectMake(40, -6.5f, 400, 40);
            }
        }
    }else{
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            self.searchBar.frame = CGRectMake(10, 0, 260, 44);
        }else{
            self.searchBar.frame = CGRectMake(0, 0, 275, 44);
        }
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

#pragma mark -
#pragma mark setup
- (void)getInitialListings{
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

- (void)setupLocationManager{
    // Configure Location Manager
    [MTLocationManager sharedInstance].locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [MTLocationManager sharedInstance].locationManager.distanceFilter = kCLDistanceFilterNone;
    [MTLocationManager sharedInstance].locationManager.headingFilter = 5; // 5 Degrees
    
    [MTLocationManager sharedInstance].mapView = self.mapView;
    [[MTLocationManager sharedInstance] setTrackingMode:MTUserTrackingModeFollow];
    
    [[MTLocationManager sharedInstance] whenLocationChanged:^(CLLocation *location) {
        MKCoordinateRegion region;
        CLLocationCoordinate2D coords = location.coordinate;
        coords.latitude = coords.latitude;
        region.center = coords;
        
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.12; // Change these values to change the zoom
        span.longitudeDelta = 0.12;
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
    NSString *latVal = [NSString stringWithFormat:@"%.1f", self.mapView.centerCoordinate.latitude];
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
                CLLocationDistance meters = [dispensaryLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude]];
                project.currentDistance = @(meters);
            }
            
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"currentDistance" ascending:YES];
            [sortedArray sortUsingDescriptors:@[sort]];
            
            self.dataSource = [EELArrayDataSource dataSourceWithItems:sortedArray];
            
            [self addPins];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
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
                CLLocationDistance meters = [dispensaryLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude]];
                project.currentDistance = @(meters);
            }
            
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"currentDistance" ascending:YES];
            [sortedArray sortUsingDescriptors:@[sort]];
            
            self.dataSource = [EELArrayDataSource dataSourceWithItems:sortedArray];
            
            [self addPins];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
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
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];

        [self addPins];
    }
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
                                                                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
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
#pragma mark -
#pragma mark - MapKitDelegate

- (void)zoomToUser{
    [self zoomToUser:YES];
}

- (void)zoomToUserNotAnimated{
    [self zoomToUser:NO];
}

- (void)zoomToUser:(BOOL)animated{
    if (self.mapView.userLocationVisible) {
        MKCoordinateRegion region;
        region.center = CLLocationCoordinate2DMake(self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude);
        MKCoordinateSpan span;
        
        if (self.mapView.region.span.latitudeDelta > 1) {
            span.latitudeDelta  = 0.17; // Change these values to change the zoom
            span.longitudeDelta = 0.17;
            region.span = span;
        }else{
            region.span = self.mapView.region.span;
        }
        
        [self.mapView setRegion:region animated:animated];
        [self performSearch:self.searchBar.text];
    }else{
        MKCoordinateRegion region;
        region.center = CLLocationCoordinate2DMake(37.733972, -122.431297);
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.17; // Change these values to change the zoom
        span.longitudeDelta = 0.17;
        region.span = span;
        
        [self.mapView setRegion:region animated:animated];
        [self performSearch:self.searchBar.text];
    }
}

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
    }
}

#pragma mark -
#pragma mark - Collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.items.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (EELDetailHeader *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EELDetailHeader *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EELDetailHeader class]) forIndexPath:indexPath];
    EELDispensary *dispensary = [self.dataSource.items objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    [cell configureWithDispensary:dispensary];
    
    return cell;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < self.mapView.frame.size.height*-1 ) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, self.mapView.frame.size.height*-1)];
    }
}

#pragma mark -
#pragma mark - UISearchDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self performSearch:self.searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // non optimal hack for getting results back
    if (searchBar.text.length == 0) {
        [self performSearch:self.searchBar.text];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight || toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        if (IS_IPHONE_5) {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                self.searchBar.frame = CGRectMake(90, -4.f, 400, 40);
            }else{
                self.searchBar.frame = CGRectMake(90, -6.5f, 400, 40);
            }
        }else{
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                self.searchBar.frame = CGRectMake(40, -4.f, 400, 40);
            }else{
                self.searchBar.frame = CGRectMake(40, -6.5f, 400, 40);
            }
        }
    }else{
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            self.searchBar.frame = CGRectMake(10, 0, 260, 44);
        }else{
            self.searchBar.frame = CGRectMake(0, 0, 275, 44);
        }
    }
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



@end
