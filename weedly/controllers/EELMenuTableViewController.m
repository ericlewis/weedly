//
//  EELMenuTableViewController.m
//  weedly
//
//  Created by 1debit on 5/4/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMenuTableViewController.h"

#import "EELArrayDataSource.h"

@interface EELMenuTableViewController ()

@property (strong, nonatomic) EELArrayDataSource *dataSource;
@property (strong, nonatomic) EELMenu *menuInfo;

@end

@implementation EELMenuTableViewController

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
    
    [self setupTitle];
    
    [self getMenuInfo];
    [self getMenuItems];
}

- (void)getMenuInfo{
    [[EELWMClient sharedClient] getMenuWithDispensaryID:self.dispensary.id.stringValue completionBlock:^(EELMenu *result, NSError *error) {
        if (error) {
            NSLog(@"noooo: %@", error);
            return;
        }
        
        self.menuInfo = result;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)getMenuItems{
    // get the menu items for the dispensary!
    [[EELWMClient sharedClient] getMenuItemsWithDispensaryID:self.dispensary.id.stringValue completionBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"noooo: %@", error);
            return;
        }
        
        // sort by category
        NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"catID" ascending:YES];
        results = [results sortedArrayUsingDescriptors:@[brandDescriptor]];
        
        self.dataSource = [EELArrayDataSource dataSourceWithItems:results];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)setupTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize: 14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"Menu\n%@", [self.dispensary formattedNameString]];
    
    self.navigationItem.titleView = label;
}

- (IBAction)dismissView:(id)sender {
    // wind back to search / favorite list if its where we came from
    if (self.navigationController.childViewControllers.count > 2) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // header that shows last time updated
    if (section == 0) {
        if(self.menuInfo) return 1;
        return 0;
    }
    
    return self.dataSource.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItem" forIndexPath:indexPath];
    
    EELMenuItem *menuItem = self.dataSource.items[indexPath.row];

    // Configure the cell...
    
    // this is the menu updated ago cell
    if(indexPath.section == 0){
        cell.textLabel.text = [NSString stringWithFormat:@"Menu updated %@", self.menuInfo.lastUpdated.timeAgoSinceNow];
        cell.detailTextLabel.text = @"";
    }
    
    // the menu cells
    else if(indexPath.section == 1){
        cell.textLabel.text = menuItem.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 1/8", menuItem.priceEighth];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }
    
    return 50;
}

@end
