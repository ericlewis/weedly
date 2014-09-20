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

#define ZOOM_OFFSET 0.1

@interface EELMainViewController ()

@property (weak, nonatomic) IBOutlet MKMapView   *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;

@property (nonatomic) int selectedRow;
@property (strong, nonatomic) REMenu *filterMenu;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) EELArrayDataSource *dataSource;
@property (strong, nonatomic) UIButton *myLocationButton;

@property (nonatomic) BOOL didZoomToUser;

@end

@implementation EELMainViewController

CGFloat topPixelsPortrait = 0;
CGFloat topPixelsLandscape = 0;
CGFloat percentOfScreen = 0.649f;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!IS_IPHONE_5) {
        percentOfScreen = 0.585f;
    }
    
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        topPixelsPortrait = CGRectGetHeight(self.view.bounds)*percentOfScreen;
        topPixelsLandscape = CGRectGetWidth(self.view.bounds)*percentOfScreen;
    }else{
        topPixelsPortrait = CGRectGetWidth(self.view.bounds)*percentOfScreen;
        topPixelsLandscape = CGRectGetHeight(self.view.bounds)*percentOfScreen;
    }
    
    [self setupMapView];
    [self setupTableView];
    [self setupSearchBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:kEELYLocationDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorizationStatusDidChange:) name:kEELYLocationStatusDidChange object:nil];
    
    if([[EELYLocationManager sharedManager] respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [[EELYLocationManager sharedManager] requestWhenInUseAuthorization];
    }
    
    [[EELYLocationManager sharedManager] startUpdatingLocation];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

- (void) locationDidChange:(NSNotification*)notification {
    if (!_didZoomToUser) {
        [self zoomToUser];
        _didZoomToUser = YES;
    }
}

- (void)zoomToUser{
    
    _selectedRow = 0;
    
    MKCoordinateRegion region;
    CLLocationCoordinate2D coords = [EELYLocationManager sharedManager].location.coordinate;
    
    MKCoordinateSpan span;
    
    if (self.mapView.region.span.latitudeDelta > 0.12) {
        span.latitudeDelta  = 0.05; // Change these values to change the zoom
        span.longitudeDelta = 0.05;
    }else{
        span.latitudeDelta = self.mapView.region.span.latitudeDelta;
        span.longitudeDelta = self.mapView.region.span.longitudeDelta;
    }
    
    region.span = span;
    region.center = coords;
    
    if (self.mapView.region.span.latitudeDelta != region.span.latitudeDelta && self.mapView.region.span.longitudeDelta != region.span.longitudeDelta) {
        [self.mapView setRegion:region];
    }
    
    coords.latitude -= self.mapView.region.span.latitudeDelta * ZOOM_OFFSET;
    [self.mapView setCenterCoordinate:coords animated:NO];
}

-(MKMapRect)MKMapRectForCoordinateRegion:(MKCoordinateRegion)region
{
    MKMapPoint a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
                                                                      region.center.latitude + region.span.latitudeDelta / 2,
                                                                      region.center.longitude - region.span.longitudeDelta / 2));
    MKMapPoint b = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
                                                                      region.center.latitude - region.span.latitudeDelta / 2,
                                                                      region.center.longitude + region.span.longitudeDelta / 2));
    return MKMapRectMake(MIN(a.x,b.x), MIN(a.y,b.y), ABS(a.x-b.x), ABS(a.y-b.y));
}

- (void) authorizationStatusDidChange:(NSNotification*)notification {
    //do something if they dont set authorization to allow
}

- (void)viewWillAppear:(BOOL)animated{
    [self performSelector:@selector(showSearchBar) withObject:self afterDelay:0.15];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.searchBar resignFirstResponder];
    
    if (self.filterMenu.isOpen) {
        [self.filterMenu close];
    }
}

#pragma mark -
#pragma mark setup
- (void)setupTableView{
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.view.bounds)*percentOfScreen, 0, 0, 0);
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EELListHeaderTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NearbyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EELListTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemHeaderCell"];
}

- (void)setupMapView{
    UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    [panRec setDelegate:self];
    [self.mapView addGestureRecognizer:panRec];
    
    UITapGestureRecognizer *doubletapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    doubletapRec.numberOfTapsRequired = 2;
    [doubletapRec setDelegate:self];
    [self.mapView addGestureRecognizer:doubletapRec];
    self.mapView.delegate = self;
    
    [self setupMyLocationButton];
}

- (void)setupMyLocationButton{
    self.myLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.myLocationButton.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [self.myLocationButton setImage:[UIImage imageNamed:@"myLocation"] forState:UIControlStateNormal];
    [self.myLocationButton addTarget:self action:@selector(zoomToUser) forControlEvents:UIControlEventTouchUpInside];
    self.myLocationButton.backgroundColor = [UIColor whiteColor];
    
    self.myLocationButton.layer.cornerRadius = 5.0;
    self.myLocationButton.layer.masksToBounds = NO;
    self.myLocationButton.layer.borderWidth = 1.0f;
    self.myLocationButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.myLocationButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.myLocationButton.layer.shadowOpacity = 0.4;
    self.myLocationButton.layer.shadowRadius = 3;
    self.myLocationButton.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);

    [self.mapView addSubview:self.myLocationButton];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        [self performSearch:self.searchBar.text];
    }
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSSet *annSet = [self.mapView annotationsInMapRect:self.mapView.visibleMapRect];
        EELListHeaderTableViewCell *countCell = (EELListHeaderTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        if (self.mapView.userLocationVisible && annSet.count > 0) {
            [countCell configureWithAmount:annSet.count-1];
        }else{
            [countCell configureWithAmount:annSet.count];
        }
        
        self.selectedRow = 0;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    });
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
    
    [self.searchBar sizeToFit];
    
    [self.navigationItem setTitleView:self.searchBar];
}

#pragma mark -
#pragma mark - Actions
- (void)performSearch:(NSString*)searchTerm{
    self.selectedRow = 0;
    
    NSString *latVal = [NSString stringWithFormat:@"%.1f", self.mapView.centerCoordinate.latitude];
    NSString *lngVal = [NSString stringWithFormat:@"%.1f", self.mapView.centerCoordinate.longitude];

    [self performSearch:searchTerm lat:(CGFloat)latVal.floatValue lng:(CGFloat)lngVal.floatValue];
}

- (void)performSearch:(NSString*)searchTerm lat:(CGFloat)lat lng:(CGFloat)lng{
    if (self.searchBar.tag == 420) {
        [[EELWMClient sharedClient] searchDispensariesWithTerm:searchTerm map:self.mapView completionBlock:^(NSArray *results, NSError *error) {
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
            
            // no search results
            if (sortedArray.count == 0 && self.searchBar.isFirstResponder) {
                [self.searchBar resignFirstResponder];
            }
            
            [self addPins];
        }];
    }else if(self.searchBar.tag == 911){
        [[EELWMClient sharedClient] searchDoctorsWithTerm:searchTerm map:self.mapView completionBlock:^(NSArray *results, NSError *error) {
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    
    EELDispensary *disp = [self.dataSource.items objectAtIndex:[annotation.title integerValue]];

    NSString *iconName = @"delivery";
    
    // disp
    if([[[disp formattedTypeString] lowercaseString] isEqualToString:@"dispensary"]){
        iconName = @"lp";
    }
    
    // doctor
    else if(disp.type == 1){
        iconName = @"doctor";
    }
    
    annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_marker", iconName]];

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[MKUserLocation class]]) {
        
        CLLocationCoordinate2D coords = view.annotation.coordinate;
        CLLocationCoordinate2D center = coords;
        center.latitude -= self.mapView.region.span.latitudeDelta * ZOOM_OFFSET;
        [self.mapView setCenterCoordinate:center animated:YES];
        
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSSet *annSet = [self.mapView annotationsInMapRect:self.mapView.visibleMapRect];
            EELListHeaderTableViewCell *countCell = (EELListHeaderTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            if (self.mapView.userLocationVisible && annSet.count > 0) {
                [countCell configureWithAmount:annSet.count-1];
            }else{
                [countCell configureWithAmount:annSet.count];
            }
            self.selectedRow = 1;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        });
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
    
    if (self.selectedRow == 0) {
        [self performSearch:self.searchBar.text];
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
    }else if(section == 1){
        
        if (self.searchBar.text.length == 0) {
            NSSet *annSet = [self.mapView annotationsInMapRect:self.mapView.visibleMapRect];
            NSInteger count = annSet.count;
            
            if (self.mapView.userLocationVisible) {
                count--;
            }
            
            if (count == 0) {
                POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
                anim.springSpeed = 1.0;
                anim.toValue = @(0.0);
                [self.tableView.layer pop_addAnimation:anim forKey:@"showTable"];
                
                [self.myLocationButton setFrame:CGRectMake(self.myLocationButton.frame.size.width/2, -self.tableView.contentOffset.y-60, self.myLocationButton.frame.size.width, self.myLocationButton.frame.size.width)];
            }else{
                POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
                anim.springSpeed = 1.0;
                anim.toValue = @(1.0);
                [self.tableView.layer pop_addAnimation:anim forKey:@"hideTable"];
            }
            
            return count;
            
        }else{
            if (self.dataSource.items.count == 0) {
                POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
                anim.springSpeed = 15.0;
                anim.toValue = @(0.0);
                [self.tableView.layer pop_addAnimation:anim forKey:@"showTable"];
                
                [self.myLocationButton setFrame:CGRectMake(self.myLocationButton.frame.size.width/2, -self.tableView.contentOffset.y-60, self.myLocationButton.frame.size.width, self.myLocationButton.frame.size.width)];
            }else{
                POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
                anim.springSpeed = 15.0;
                anim.toValue = @(1.0);
                [self.tableView.layer pop_addAnimation:anim forKey:@"hideTable"];
            }
            
            return self.dataSource.items.count;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    EELListHeaderTableViewCell *nearbyCountCell;
    EELListTableViewCell *listTableCell;
    
    if (indexPath.section == 0) {
        nearbyCountCell = [tableView dequeueReusableCellWithIdentifier:@"NearbyCell" forIndexPath:indexPath];
        nearbyCountCell.clipsToBounds = YES;
        CALayer *topBorder = [CALayer layer];
        topBorder.borderColor = [UIColor lightGrayColor].CGColor;
        topBorder.borderWidth = 0.25;
        topBorder.frame = CGRectMake(0, 0, 1000, 1);
        [nearbyCountCell.layer addSublayer:topBorder];

        cell = nearbyCountCell;

    }else{
        EELDispensary *dispensary = [self.dataSource.items objectAtIndex:indexPath.row];
        listTableCell = [tableView dequeueReusableCellWithIdentifier:@"ItemHeaderCell" forIndexPath:indexPath];
        [listTableCell configureWithDispensary:dispensary];
        cell = listTableCell;
        
        if (self.selectedRow == 1 && indexPath.row == 0) {
            cell.backgroundColor = [UIColor colorWithRed:238/255.0f green:250/255.0f blue:254/255.0f alpha:1.0f];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }
    
    return 95;
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedDispensary = [self.dataSource.items objectAtIndex:indexPath.row];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"ShowItemDetail" sender:self];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.tableView.hidden == NO) {
        [self.myLocationButton setFrame:CGRectMake(self.myLocationButton.frame.size.width/2, -self.tableView.contentOffset.y-60, self.myLocationButton.frame.size.width, self.myLocationButton.frame.size.width)];
    }

    if (scrollView.contentOffset.y < (self.mapView.frame.size.height*-1) + 100) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, (self.mapView.frame.size.height*-1) + 100)];
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
        if ([self.tableView numberOfRowsInSection:1] > 0) {
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // non optimal hack for getting results back
    if (searchBar.text.length == 0) {
        [self performSearch:self.searchBar.text];
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

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
