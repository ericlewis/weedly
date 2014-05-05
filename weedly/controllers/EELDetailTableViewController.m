//
//  EELDetailTableViewController.m
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDetailTableViewController.h"

// cells
#import "EELItemHeaderViewCell.h"
#import "EELMapHeaderTableViewCell.h"

@interface EELDetailTableViewController ()

@end

@implementation EELDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.dispensary.name;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EELItemHeaderViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EELMapHeaderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MapHeaderCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // map + header
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 6;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
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
            }
            cell.textLabel.text = @"Directions";
            cell.imageView.image = [UIImage imageNamed:@"map_marker-128"];
        }else if (row == 1) {
            
            // handle if phone is enabled
            if (self.dispensary.phone.length > 0) {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
                    cell.userInteractionEnabled = YES;
                    cell.textLabel.enabled = YES;
                }else{
                    cell.userInteractionEnabled = NO;
                    cell.textLabel.enabled = NO;
                }
                
                cell.textLabel.text = [NSString stringWithFormat:@"Call: %@", self.dispensary.phone];
            }else{
                cell.userInteractionEnabled = NO;
                cell.textLabel.enabled = NO;
                cell.textLabel.text = @"Call";
            }
            
            cell.imageView.image = [UIImage imageNamed:@"phone1-128"];
            cell.accessoryView = [[UIView alloc] init];
            
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
    }
    
    // Configure the Map cell
    [mapCell setUserInteractionEnabled:NO];
    [mapCell setDispensary:self.dispensary];
    [mapCell zoomToLocation];
    [mapCell addPin];
    
    // Configure the header cell
    
    // fix HTML entities in the names of some dispensaries.
    NSAttributedString *formattedName = [[NSAttributedString alloc] initWithData:[self.dispensary.name dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    headerCell.nameLabel.text = formattedName.string;
    
    // we will just text replace the icon names for types
    NSString *dispensaryType  = self.dispensary.icon;
    
    // disps
    if (self.dispensary.type == 0) {
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"gold" withString:@"Dispensary"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"silver" withString:@"Dispensary"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"bronze" withString:@"Dispensary"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"lp" withString:@"Dispensary"];
    }
    
    // doctors
    else if(self.dispensary.type == 1){
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"free" withString:@"Doctor"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"bronze" withString:@"Doctor"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"silver" withString:@"Doctor"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"gold" withString:@"Doctor"];
    }
    
    headerCell.typeLabel.text = dispensaryType.capitalizedString;
    
    
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
    
    NSString *cleanState = self.dispensary.state;
    NSString *cleanAddress = [self.dispensary.address stringByReplacingOccurrencesOfString:@"." withString:@""];

    // long state name, change to short one
    if (self.dispensary.state.length > 2) {
        cleanState = [cleanState stateAbbreviationFromFullName];
    }
    
    // delivery
    if ([self.dispensary.icon isEqualToString:@"delivery"]) {
        headerCell.addressLabel.text = [NSString stringWithFormat:@"%@, %@", self.dispensary.city.capitalizedString, cleanState.uppercaseString];
    }else{
        headerCell.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@", cleanAddress, self.dispensary.city.capitalizedString, cleanState.uppercaseString];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        return 45;
    }
    
    return 120;
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
        
        NSAttributedString *formattedName = [[NSAttributedString alloc] initWithData:[self.dispensary.name dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
        
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(self.dispensary.lat, self.dispensary.lng);

        MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:coords addressDictionary: nil];
        MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark: place];
        destination.name = formattedName.string;
        NSArray *items = [[NSArray alloc] initWithObjects:destination, nil];
        NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 MKLaunchOptionsDirectionsModeDriving,
                                 MKLaunchOptionsDirectionsModeKey, nil];
        [MKMapItem openMapsWithItems:items launchOptions:options];
    }
    
    // call location
    else if(indexPath.row == 1){
        [tableView deselectRowAtIndexPath:indexPath animated:NO];

        NSString *phoneNumber = [@"tel://" stringByAppendingString:self.dispensary.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    
    // show menu!
    else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"ShowMenu" sender:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
