//
//  EELSidebarTableViewController.m
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELSidebarTableViewController.h"

@interface EELSidebarTableViewController ()

@property (nonatomic, strong) NSArray *sidebarItems;

@end

@implementation EELSidebarTableViewController

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
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.sidebarItems = @[
                          @{@"image": [UIImage imageNamed:@"accountIcon"],  @"title": @"Account"},
                          @{@"image": [UIImage imageNamed:@"dealsIcon"],    @"title": @"Today's Deals"},
                          @{@"image": [UIImage imageNamed:@"smokinonIcon"], @"title": @"Smokin' On"},
                          @{@"image": [UIImage imageNamed:@"alarmIcon"],    @"title": @"420 Alarm"},
                          ];
    
    [self.revealController setMinimumWidth:270.0 maximumWidth:270.0 forViewController:self];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // header cell
    if (section == 0) return 1;

    return self.sidebarItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell" forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        return cell;
    }else if(indexPath.row != self.sidebarItems.count - 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"SidebarItemSingleLine" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"SidebarItemDoubleLine" forIndexPath:indexPath];
        cell.detailTextLabel.text = @"Set a reminder to toke up!";
    }
    
    // Configure the cell...
    cell.textLabel.text = [[self.sidebarItems objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.imageView.image = [[self.sidebarItems objectAtIndex:indexPath.row] valueForKey:@"image"];
    
    // last cell
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 130;
    }
    
    // height for sidebar options
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        // wiggle the logo
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        CATransform3D transform = CATransform3DMakeRotation(0.1, 0, 0, 1.0);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.toValue = [NSValue valueWithCATransform3D:transform];
        animation.autoreverses = YES;
        animation.duration = 0.12;
        animation.repeatCount = 2;
        animation.delegate=self;
        
        for(UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view.layer addAnimation:animation forKey:@"wiggleAnimation"];
            }
        }
        
    }else{
        
        NSUInteger index = indexPath.row;
        
        // account
        if (index == 0){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            if ([[EELWMClient sharedClient] isAccountLoggedIn]) {
                // needs to push to nav controller
                [self performSegueWithIdentifier:@"ShowAccount" sender:self];
            }else{
                // prompt that they need to login
                [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Would you like to login?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil] show];
            }
        }
        
        // Today's Deals
        else if (index == 1){
            [self performSegueWithIdentifier:@"ShowTodaysDeals" sender:self];
        }
        
        // Smokin' On
        else if (index == 2){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"alloc init yet to occur ;)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            // needs to push to nav controller
            //[self performSegueWithIdentifier:@"ShowSmokinOn" sender:self];
        }
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
