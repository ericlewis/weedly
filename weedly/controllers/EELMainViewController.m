//
//  EELMainViewController.m
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMainViewController.h"

#import "EELDealsViewController.h"
#import "EELFavoritesTableViewController.h"
#import "EELMainTableViewController.h"
#import "EELDetailTableViewController.h"

#import "EELArrayDataSource.h"

@interface EELMainViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
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
}

- (void)viewWillAppear:(BOOL)animated{
    self.mapView.showsUserLocation = YES;
    [self setupBottomButtons];
    
    [self performSelector:@selector(showSearchBar) withObject:self afterDelay:0.15];
    
    // landscape fix search
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        self.searchBar.frame = CGRectMake(90, -6.5f, 400, 40);
    }else{
        self.searchBar.frame = CGRectMake(45, 0, 230, 44);
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [self hideBottomButtons];
    [self.searchBar resignFirstResponder];
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

- (void)setupBottomButtons{
    // do animation stuff
    [self showBottomButtons];

    // find me button
    [self.findMeButton addTarget:self action:@selector(zoomToUser) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showBottomButtons{
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 57, 57)];
    [self.findMeButton pop_addAnimation:anim forKey:@"bottomBar"];
    
    POPSpringAnimation *anim2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim2.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 57, 57)];
    [self.dealsButton pop_addAnimation:anim2 forKey:@"bottomBar"];
    
    POPSpringAnimation *anim3 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim3.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 57, 57)];
    [self.listButton pop_addAnimation:anim3 forKey:@"bottomBar"];
    
    POPSpringAnimation *anim4 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim4.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 57, 57)];
    [self.favoritesButton pop_addAnimation:anim4 forKey:@"bottomBar"];
}

- (void)hideBottomButtons{
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)];
    [self.findMeButton pop_addAnimation:anim forKey:@"bottomBar"];
    
    POPSpringAnimation *anim2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim2.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)];
    [self.dealsButton pop_addAnimation:anim2 forKey:@"bottomBar"];
    
    POPSpringAnimation *anim3 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim3.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)];
    [self.listButton pop_addAnimation:anim3 forKey:@"bottomBar"];
    
    POPSpringAnimation *anim4 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim4.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)];
    [self.favoritesButton pop_addAnimation:anim4 forKey:@"bottomBar"];
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
            
            self.dataSource = [EELArrayDataSource dataSourceWithItems:results];
            
            [self addPins];
        }];
    }else{
        [[EELWMClient sharedClient] searchDoctorsWithTerm:searchTerm lat:lat lng:lng completionBlock:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"noooo: %@", error);
                return;
            }
            
            self.dataSource = [EELArrayDataSource dataSourceWithItems:results];
            
            [self addPins];
        }];
    }
}

- (IBAction)showSidebar:(id)sender {
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
        
        self.filterMenu = [[REMenu alloc] initWithItems:@[dispensaryItem, doctorItem]];
        self.filterMenu.backgroundColor = [UIColor whiteColor];
        self.filterMenu.borderColor = [UIColor clearColor];
        self.filterMenu.separatorColor = [UIColor clearColor];
        self.filterMenu.textColor = [UIColor grayColor];
        self.filterMenu.textAlignment = NSTextAlignmentLeft;
        self.filterMenu.textOffset = CGSizeMake(50, 0);
        
        self.filterMenu.liveBlur = YES;
        
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
        region.center = self.mapView.userLocation.coordinate;
        
        MKCoordinateSpan span;
        
        if (self.mapView.region.span.latitudeDelta > 1) {
            span.latitudeDelta  = 0.15; // Change these values to change the zoom
            span.longitudeDelta = 0.15;
            region.span = span;
        }else{
            region.span = self.mapView.region.span;
        }
        
        [self.mapView setRegion:region animated:animated];
    }else{
        MKCoordinateRegion region;
        region.center = CLLocationCoordinate2DMake(37.773972, -122.431297);
        
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.15; // Change these values to change the zoom
        span.longitudeDelta = 0.15;
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

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    [self hideBottomButtons];
    [self.searchBar resignFirstResponder];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self showBottomButtons];
    for (NSObject *annotation in [mapView annotations])
    {
        if ([annotation isKindOfClass:[MKUserLocation class]])
        {
            MKAnnotationView *view = [mapView viewForAnnotation:(MKUserLocation *)annotation];
            [[view superview] bringSubviewToFront:view];
        }
    }
    
    [self performSearch:self.searchBar.text];
}

#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowItemDetail"]) {
        [(id)[[segue destinationViewController] topViewController] setDispensary:self.selectedDispensary];
        [self hideSearchBar];
    }else if([[segue identifier] isEqualToString:@"ShowList"]){
        [(id)[[segue destinationViewController] topViewController] setSearchTerm:self.searchBar.text];
        [(id)[[segue destinationViewController] topViewController] setSearchType:self.searchBar.tag];
    }
}

#pragma mark -
#pragma mark - UISearchDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self performSearch:searchBar.text];
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
        self.searchBar.frame = CGRectMake(90, -6.5f, 400, 40);
    }else{
        self.searchBar.frame = CGRectMake(45, 0, 230, 44);
    }
}

@end
