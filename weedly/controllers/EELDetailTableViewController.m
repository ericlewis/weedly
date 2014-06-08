//
//  EELDetailTableViewController.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDetailTableViewController.h"

#import "EELArrayDataSource.h"

// cells
#import "EELItemHeaderViewCell.h"
#import "EELMapHeaderTableViewCell.h"

@interface EELDetailTableViewController ()

@property (strong, nonatomic) EELArrayDataSource *reviewDataSource;

@end

@implementation EELDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.dispensary formattedNameString];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EELItemHeaderViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EELMapHeaderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MapHeaderCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if (self.navigationController.childViewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissView:)];
    }
    
    NSMutableArray *favoritesOnDisk = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY]];
    if ([favoritesOnDisk containsObject:self.dispensary]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"liked-75"] style:UIBarButtonItemStylePlain target:self action:@selector(favoriteButton:)];
    }
    
    [self getReviews];
}

- (void)getReviews{
    [[EELWMClient sharedClient] getReviewsWithDispensaryID:self.dispensary.id.stringValue completionBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"noooo: %@", error);
            return;
        }
        
        self.reviewDataSource = [EELArrayDataSource dataSourceWithItems:results];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
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
    
    // 1. map && header
    // 2. actions
    // 3. reviews
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // map + header
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 3;
    }
    
    return self.reviewDataSource.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    UITableViewCell *reviewCell;
    EELItemHeaderViewCell *headerCell;
    EELMapHeaderTableViewCell *mapCell;
    
    // set the map
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            mapCell = [tableView dequeueReusableCellWithIdentifier:@"MapHeaderCell" forIndexPath:indexPath];
            cell = mapCell;
        }else if(indexPath.row == 1){
            headerCell = [tableView dequeueReusableCellWithIdentifier:@"ItemHeaderCell" forIndexPath:indexPath];
            cell = headerCell;
        }
    }
    
    // set the action menu
    else if(indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ItemActionCell" forIndexPath:indexPath];
        
        NSUInteger row = indexPath.row;
        
        if (row == 0) {
            if (self.dispensary.address.length > 0 && ![self.dispensary.icon isEqualToString:@"delivery"]) {
                cell.userInteractionEnabled = YES;
                cell.textLabel.enabled = YES;
            }else{
                cell.userInteractionEnabled = NO;
                cell.textLabel.enabled = NO;
                cell.accessoryView = [[UIView alloc] init];
            }
            cell.textLabel.text = @"Directions";
            cell.imageView.image = [UIImage imageNamed:@"map_marker-128"];
        }else if (row == 1) {
            
            // handle if phone is enabled
            if (self.dispensary.phone.length > 0) {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"telprompt://"]]) {
                    cell.userInteractionEnabled = YES;
                    cell.textLabel.enabled = YES;
                }else{
                    cell.userInteractionEnabled = NO;
                    cell.textLabel.enabled = NO;
                    cell.accessoryView = [[UIView alloc] init];
                }
                
                cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.dispensary formattedPhoneString]];
            }else{
                cell.userInteractionEnabled = NO;
                cell.textLabel.enabled = NO;
                cell.textLabel.text = @"Phone number unavailable";
                cell.accessoryView = [[UIView alloc] init];
            }
            
            cell.imageView.image = [UIImage imageNamed:@"phone1-128"];
            
        }else if (row == 2) {
            cell.textLabel.text = @"Menu";
            cell.imageView.image = [UIImage imageNamed:@"list_ingredients-128"];
        }else if (row == 3) {
            cell.textLabel.text = @"Deals";
            cell.imageView.image = [UIImage imageNamed:@"price_tag-128 2"];
        }else if (row == 4) {
            cell.textLabel.text = @"Add Review";
            cell.imageView.image = [UIImage imageNamed:@"quote-128"];
        }else if (row == 5) {
            cell.textLabel.text = @"More Info";
            cell.imageView.image = [UIImage imageNamed:@"info-128"];
        }
    }else{
        reviewCell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
        cell = reviewCell;
    }
    
    // Configure the Map cell
    [mapCell setUserInteractionEnabled:NO];
    [mapCell setDispensary:self.dispensary];
    [mapCell zoomToLocation];
    [mapCell addPin];
    
    // Configure the header cell
    
    // fix HTML entities in the names of some dispensaries.
    headerCell.nameLabel.text = [self.dispensary formattedNameString];
    headerCell.typeLabel.text = [self.dispensary formattedTypeString];
    
    
    if (self.dispensary.opensAt.length > 0 && self.dispensary.closesAt.length > 0) {
        headerCell.hoursLabel.text = [NSString stringWithFormat:@"Hours: %@ - %@", self.dispensary.opensAt, self.dispensary.closesAt];
    }else{
        headerCell.hoursLabel.text = @"Hours unavailable";
    }
    
    // switch the text and color if we are closed
    if (self.dispensary.isOpen.boolValue) {
        headerCell.isOpenLabel.text = @"Currently Open";
    }else{
        headerCell.isOpenLabel.text = @"Currently Closed";
    }
    
    headerCell.isOpenLabel.textColor = MAIN_COLOR;
    
    // hide reviews if we don't have a count
    if (self.dispensary.ratingCount == 0) {
        [headerCell.reviewsView setHidden:YES];
    }else{
        [headerCell.reviewsView setHidden:NO];
        
        headerCell.reviewsLabel.text = [NSString stringWithFormat:@"%.1f • %i reviews", self.dispensary.rating, self.dispensary.ratingCount];
        [headerCell.reviewsLabel sizeToFit];
        
        CGFloat reviewStarsWidth = headerCell.reviewsStarsImage.frame.size.width;
        reviewStarsWidth = (reviewStarsWidth*2) * (self.dispensary.rating * 0.1);
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        maskLayer.frame = CGRectMake(0.0, 0.0, reviewStarsWidth, reviewStarsWidth);
        
        headerCell.reviewsStarsImage.layer.mask = maskLayer;
    }
    
    headerCell.addressLabel.text = [self.dispensary formattedAddressString];
    
    // handle review cells
    if (indexPath.section == 2) {
        EELReview *review = self.reviewDataSource.items[indexPath.row];
        reviewCell.textLabel.numberOfLines = 2;
        reviewCell.textLabel.text = [NSString stringWithFormat:@"%@ \n%@ • %@", review.title, [@"" stringByPaddingToLength:review.rating withString:@"★" startingAtIndex:0], review.name];
        reviewCell.detailTextLabel.text = review.comment;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // reviews
    if (indexPath.section == 2){
        NSString *text = [[self.reviewDataSource.items objectAtIndex:[indexPath row]] comment];
        CGSize constraint = CGSizeMake(320 - (20 * 2), 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height = MAX(size.height, 50.0f);
        
        return height + (30 * 2);
    }
    
    if (indexPath.section == 0) {
        return 122;
    }
    
    return 44;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 5;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // open directions
    if (indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(self.dispensary.lat, self.dispensary.lng);

        MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:coords addressDictionary: nil];
        MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark: place];
        destination.name = [self.dispensary formattedNameString];
        NSArray *items = [[NSArray alloc] initWithObjects:destination, nil];
        NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 MKLaunchOptionsDirectionsModeDriving,
                                 MKLaunchOptionsDirectionsModeKey, nil];
        [MKMapItem openMapsWithItems:items launchOptions:options];
    }
    
    // call location
    else if(indexPath.row == 1){
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:[[self.dispensary.phone componentsSeparatedByCharactersInSet:
                                                                           [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                                                          componentsJoinedByString:@""]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    
    // show menu!
    else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"TestCollection" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowMenu"]) {
        [[segue destinationViewController] setDispensary:self.dispensary];
    }else{
        [[segue destinationViewController] setDispensary:self.dispensary];
    }
}

- (IBAction)favoriteButton:(id)sender {
    NSString *key = FAVORITES_KEY;
    
    NSData *onDisk = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSMutableArray *favoritesOnDisk = [NSKeyedUnarchiver unarchiveObjectWithData:onDisk];
    
    if (favoritesOnDisk.count == 0) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:self.dispensary, nil];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"liked-75"] style:UIBarButtonItemStylePlain target:self action:@selector(favoriteButton:)];
    }else{
        
        // add fave, update heart
        if (![favoritesOnDisk containsObject:self.dispensary]){
            [favoritesOnDisk addObject:self.dispensary];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:favoritesOnDisk];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"liked-75"] style:UIBarButtonItemStylePlain target:self action:@selector(favoriteButton:)];
        }
        
        // remove fave, update heart
        else{
            [favoritesOnDisk removeObject:self.dispensary];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:favoritesOnDisk];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"like-75"] style:UIBarButtonItemStylePlain target:self action:@selector(favoriteButton:)];
        }
    }
    
    // read back
    NSData *data2 = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSArray *favorites = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
    
    NSLog(@"%@", favorites);
}

@end
