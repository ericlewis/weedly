//
//  EELMainViewController.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMainViewController.h"
#import "EELDetailViewController.h"
#import "EELListHeaderTableViewCell.h"
#import "EELArrayDataSource.h"
#import "EELListTableViewCell.h"

@interface EELMainViewController ()

@property (weak, nonatomic) IBOutlet MKMapView   *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.contentInset = UIEdgeInsetsMake(self.mapView.frame.size.height-40, 0, 0, 0);
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EELListHeaderTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NearbyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EELListTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemHeaderCell"];

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
    
    if (self.dataSource.items.count > 0) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        self.tableView.userInteractionEnabled = YES;
    }else{
        self.tableView.userInteractionEnabled = NO;
    }
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
            
            if (sortedArray.count > 0) {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                // no results found (show no results found maybe)
            }
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
            if (sortedArray.count > 0) {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

            }else{
                // no results found (show no results found maybe)
            }
        }];
        
    }else{
        
        // needs to actually allow search on the objects
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
        NSMutableArray *sortedArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy]; // your mutable copy of the fetched objects
        
        // pull favorites in a KV array with hashes as the root object
        
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
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

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

        self.filterMenu = [[REMenu alloc] initWithItems:@[dispensaryItem, doctorItem]];
        self.filterMenu.backgroundColor = MAIN_COLOR_TRANSLUCENT;
        self.filterMenu.borderColor = [UIColor grayColor];
        self.filterMenu.borderWidth = 0.5f;
        self.filterMenu.separatorColor = [UIColor clearColor];
        self.filterMenu.font = [UIFont fontWithName:@"HelveticaNue-Light" size:20];
        self.filterMenu.textColor = [UIColor whiteColor];
        self.filterMenu.textAlignment = NSTextAlignmentLeft;
        self.filterMenu.textOffset = CGSizeMake(50, 0);
        
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
            span.latitudeDelta  = 0.1; // Change these values to change the zoom
            span.longitudeDelta = 0.1;
            region.span = span;
        }else{
            region.span = self.mapView.region.span;
        }
        
        [self.mapView setRegion:region animated:animated];
        [self performSearch:self.searchBar.text];
    }else{
        MKCoordinateRegion region;
        region.center = CLLocationCoordinate2DMake(37.7733, -122.431297);
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.1; // Change these values to change the zoom
        span.longitudeDelta = 0.1;
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
        annotationView.image = [UIImage imageNamed:@"doctor_marker"];
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[MKUserLocation class]]) {
        [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
        
        NSMutableArray *sortedArray = [self.dataSource.items mutableCopy]; // your mutable copy of the fetched objects
        
        for (EELDispensary *project in sortedArray) {
            CLLocationDegrees lat = project.lat;
            CLLocationDegrees lng = project.lng;
            CLLocation *dispensaryLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            CLLocationDistance meters = [dispensaryLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude]];
            project.currentDistance = @(meters);
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"currentDistance" ascending:YES];
        [sortedArray sortUsingDescriptors:@[sort]];
        
        self.dataSource = [EELArrayDataSource dataSourceWithItems:sortedArray];
        
        if (sortedArray.count > 0) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    // pop to make it bigger
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, view.frame.size.width + 10, view.frame.size.height + 10)];
    [view pop_addAnimation:anim forKey:@"size"];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, view.frame.size.width - 10, view.frame.size.height - 10)];
    [view pop_addAnimation:anim forKey:@"size"];
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

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowItemDetail"]) {
        [self hideSearchBar];
        EELDetailViewController *controller = segue.destinationViewController;
        controller.dispensary = self.selectedDispensary;
    }
}

#pragma mark -
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }

    return self.dataSource.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    EELListHeaderTableViewCell *nearbyCountCell;
    EELListTableViewCell *listTableCell;
    EELDispensary *dispensary = [self.dataSource.items objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
        nearbyCountCell = [tableView dequeueReusableCellWithIdentifier:@"NearbyCell" forIndexPath:indexPath];
        nearbyCountCell.clipsToBounds = YES;
        CALayer *topBorder = [CALayer layer];
        topBorder.borderColor = [UIColor lightGrayColor].CGColor;
        topBorder.borderWidth = 0.25;
        topBorder.frame = CGRectMake(0, 0, 1000, 1);
        [nearbyCountCell.layer addSublayer:topBorder];
        
        NSSet *annSet = [self.mapView annotationsInMapRect:self.mapView.visibleMapRect];
        [nearbyCountCell configureWithAmount:annSet.count];
        
        cell = nearbyCountCell;

    }else{
        listTableCell = [tableView dequeueReusableCellWithIdentifier:@"ItemHeaderCell" forIndexPath:indexPath];
        [listTableCell configureWithDispensary:dispensary];
        cell = listTableCell;
    }
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }
    
    return 107;
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
    if (scrollView.contentOffset.y < self.mapView.frame.size.height*-1 ) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, self.mapView.frame.size.height*-1)];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.tableView.contentInset.top != self.mapView.frame.size.height-40) {
        [self.tableView setContentInset:UIEdgeInsetsMake(self.mapView.frame.size.height-40, 0, 0, 0)];
    }
}

#pragma mark -
#pragma mark - UISearchDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self performSearch:self.searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (self.dataSource.items.count > 0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [UIView commitAnimations];
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
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
