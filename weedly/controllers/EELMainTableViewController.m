//
//  EELMainTableViewController.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMainTableViewController.h"
#import "EELDetailTableViewController.h"

#import "EELArrayDataSource.h"

// cells
#import "EELItemHeaderViewCell.h"

@interface EELMainTableViewController ()

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) REMenu *filterMenu;

@property (strong, nonatomic) EELArrayDataSource *dataSource;

@end

@implementation EELMainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSearchBar];
    
    self.searchBar.tag = self.searchType;
    
    if (self.searchType != 420) {
        self.searchBar.placeholder = @"Search Doctors";
    }
    
    [self.searchBar setText:self.searchTerm];
    [self performSearch:self.searchTerm];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EELItemHeaderViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemHeaderCell"];
    [self.tableView setAllowsSelection:YES];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [self performSelector:@selector(showSearchBar) withObject:self afterDelay:0.15];
    
    // landscape fix search
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        self.searchBar.frame = CGRectMake(90, -6.5f, 400, 40);
    }else{
        self.searchBar.frame = CGRectMake(45, 0, 230, 44);
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.searchBar resignFirstResponder];
    [self hideSearchBar];
    
    if (self.filterMenu.isOpen) {
        [self.filterMenu close];
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

#pragma mark -
#pragma mark - Actions
- (void)performSearch:(NSString*)searchTerm{
    NSString *latVal = [NSString stringWithFormat:@"%.1f", [MTLocationManager sharedInstance].lastKnownLocation.coordinate.latitude ?: 37.773972];
    NSString *lngVal = [NSString stringWithFormat:@"%.1f", [MTLocationManager sharedInstance].lastKnownLocation.coordinate.longitude ?: -122.431297];

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
            
            [self.tableView reloadData];
        }];
    }else{
        [[EELWMClient sharedClient] searchDoctorsWithTerm:searchTerm lat:lat lng:lng completionBlock:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"noooo: %@", error);
                return;
            }
            
            self.dataSource = [EELArrayDataSource dataSourceWithItems:results];
            
            [self.tableView reloadData];
        }];
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

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedDispensary = [self.dataSource.items objectAtIndex:indexPath.row];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ShowItemDetail" sender:self];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowItemDetail"]) {
        [(id)[segue destinationViewController] setDispensary:self.selectedDispensary];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 122;
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight || toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        self.searchBar.frame = CGRectMake(90, -6.5f, 400, 40);
    }else{
        self.searchBar.frame = CGRectMake(45, 0, 230, 44);
    }
}

@end
