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

@interface EELMainViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet MTLocateMeButton *findMeButton;
@property (weak, nonatomic) IBOutlet UIButton *dealsButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@property (strong, nonatomic) UISearchBar *searchBar;

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
    
    [self performSelector:@selector(zoomToUser) withObject:self afterDelay:0.2];
    
    [[EELWMClient sharedClient] searchDispensariesWithTerm:@"" completionBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"noooo: %@", error);
            return;
        }
        
        NSLog(@"results: %@", results);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    self.mapView.showsUserLocation = YES;
    [self setupBottomButtons];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self hideBottomButtons];
}

- (void)viewDidDisappear:(BOOL)animated{
    self.mapView.showsUserLocation = NO;
}

#pragma mark -
#pragma mark setup

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
    // add the search bar to the navigation menu
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 230, 44)];
    self.searchBar.center = CGPointMake(self.navigationController.navigationBar.center.x, self.navigationController.navigationBar.center.y / 2);
    
    self.searchBar.translucent = YES;
    self.searchBar.tintColor = [UIColor lightGrayColor];
    
    UITextField *searchBarTextField = nil;
    for (UIView *subview in self.searchBar.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            searchBarTextField.clearButtonMode = UITextFieldViewModeAlways;
            break;
        }
    }
    
    self.searchBar.placeholder = @"Search";
    
    [self.navigationController.navigationBar addSubview:self.searchBar];
}

#pragma mark -
#pragma mark - Actions
- (IBAction)showSidebar:(id)sender {
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (void)zoomToUser{
    if (self.mapView.userLocationVisible) {
        MKCoordinateRegion region;
        region.center = self.mapView.userLocation.coordinate;
        
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.15; // Change these values to change the zoom
        span.longitudeDelta = 0.15;
        region.span = span;
        
        [self.mapView setRegion:region animated:YES];
    }else{
        MKCoordinateRegion region;
        region.center = CLLocationCoordinate2DMake(37.773972, -122.431297);
        
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.15; // Change these values to change the zoom
        span.longitudeDelta = 0.15;
        region.span = span;
        
        [self.mapView setRegion:region animated:YES];
    }
}

#pragma mark -
#pragma mark - MapKitDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    [self.searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
