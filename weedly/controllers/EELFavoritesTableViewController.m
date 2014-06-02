//
//  EELFavoritesTableViewController.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELFavoritesTableViewController.h"
#import "EELDetailTableViewController.h"
#import "EELArrayDataSource.h"
#import "EELItemHeaderViewCell.h"

@interface EELFavoritesTableViewController ()

@property (strong, nonatomic) EELArrayDataSource *favoritesDataSource;

@end

@implementation EELFavoritesTableViewController

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EELItemHeaderViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemHeaderCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
    self.favoritesDataSource = [EELArrayDataSource dataSourceWithItems:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    [self.tableView reloadData];
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
    return self.favoritesDataSource.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EELItemHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemHeaderCell" forIndexPath:indexPath];
    EELDispensary *dispensary = [self.favoritesDataSource.items objectAtIndex:indexPath.row];
    
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
    self.selectedDispensary = [self.favoritesDataSource.items objectAtIndex:indexPath.row];
    
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

@end
