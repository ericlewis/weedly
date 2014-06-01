//
//  EELMenuTableViewController.m
//  weedly
//
//  Created by Eric Lewis on 5/4/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMenuTableViewController.h"
#import "BFNavigationBarDrawer.h"
#import "EELArrayDataSource.h"

@interface EELMenuTableViewController ()

@property (strong, nonatomic) EELArrayDataSource *dataSource;
@property (strong, nonatomic) EELArrayDataSource *dataSourceUnfiltered;
@property (strong, nonatomic) EELMenu *menuInfo;
@property (strong, nonatomic) BFNavigationBarDrawer *drawer;
@property (strong, nonatomic) REMenu *filterMenu;


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

- (IBAction)showFilterDropdown:(id)sender {
    if (self.filterMenu.isOpen) {
        [self.filterMenu close];
    }else{
        REMenuItem *allItem = [[REMenuItem alloc] initWithTitle:@"All"
                                                                 image:nil
                                                      highlightedImage:nil
                                                                action:^(REMenuItem *item) {
                                                                    NSLog(@"Item: %@", item);
                                                                    
                                                                    self.dataSource = self.dataSourceUnfiltered;
                                                                    [self.tableView reloadData];
                                                                }];
        
        REMenuItem *indicaItem = [[REMenuItem alloc] initWithTitle:@"Indica"
                                                             image:nil
                                                  highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                NSLog(@"Item: %@", item);
                                                                
                                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 1"];
                                                                NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                                
                                                                self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                                [self.tableView reloadData];
                                                            }];
        
        REMenuItem *sativaItem = [[REMenuItem alloc] initWithTitle:@"Sativa"
                                                             image:nil
                                                  highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                NSLog(@"Item: %@", item);
                                                                
                                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 2"];
                                                                NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                                
                                                                self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                                [self.tableView reloadData];
                                                            }];
        
        REMenuItem *hybridItem = [[REMenuItem alloc] initWithTitle:@"Hybrid"
                                                             image:nil
                                                  highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                NSLog(@"Item: %@", item);
                                                                
                                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 3"];
                                                                NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                                
                                                                self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                                [self.tableView reloadData];
                                                            }];
        
        REMenuItem *edibleItem = [[REMenuItem alloc] initWithTitle:@"Edibles"
                                                             image:nil
                                                  highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                NSLog(@"Item: %@", item);
                                                                
                                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 4"];
                                                                NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                                
                                                                self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                                [self.tableView reloadData];
                                                            }];
        
        REMenuItem *concentrateItem = [[REMenuItem alloc] initWithTitle:@"Concentrates"
                                                             image:nil
                                                  highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                NSLog(@"Item: %@", item);
                                                                
                                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 5"];
                                                                NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                                
                                                                self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                                [self.tableView reloadData];
                                                            }];
        
        REMenuItem *gearItem = [[REMenuItem alloc] initWithTitle:@"Gear"
                                                                  image:nil
                                                       highlightedImage:nil
                                                                 action:^(REMenuItem *item) {
                                                                     NSLog(@"Item: %@", item);
                                                                     
                                                                     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 10"];
                                                                     NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                                     
                                                                     self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                                     [self.tableView reloadData];
                                                                 }];
        
        REMenuItem *waxItem = [[REMenuItem alloc] initWithTitle:@"Wax"
                                                           image:nil
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                              
                                                              NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 13"];
                                                              NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                              
                                                              self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                              [self.tableView reloadData];
                                                          }];
        
        self.filterMenu = [[REMenu alloc] initWithItems:@[allItem, indicaItem, sativaItem, hybridItem, edibleItem, concentrateItem, gearItem, waxItem]];
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
        self.dataSourceUnfiltered = self.dataSource;
        
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
    
    // Configure the cell...
    
    // this is the menu updated ago cell
    if(indexPath.section == 0){
        cell.textLabel.text = [NSString stringWithFormat:@"Menu updated %@", self.menuInfo.lastUpdated.timeAgoSinceNow];
        cell.detailTextLabel.text = @"";
    }
    
    // the menu cells
    else if(indexPath.section == 1){
        EELMenuItem *menuItem = self.dataSource.items[indexPath.row];

        cell.textLabel.text = menuItem.name;
        
        NSString *pricesString = @"";
        
        if (menuItem.priceHalfGram > 0) {
            pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d 1/2gm  ", menuItem.priceHalfGram]];
        }
        
        if (menuItem.priceGram > 0) {
            pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d 1gm  ", menuItem.priceGram]];
        }
        
        if (menuItem.priceEighth > 0) {
            pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d 1/8  ", menuItem.priceEighth]];
        }
        
        if (menuItem.priceQtr > 0) {
            pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d 1/4  ", menuItem.priceQtr]];
        }
        
        if (menuItem.priceHalfOZ > 0) {
            pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d 1/2  ", menuItem.priceHalfOZ]];
        }
        
        if (menuItem.priceOZ > 0) {
            pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d OZ  ", menuItem.priceOZ]];
        }
        
        if (menuItem.priceUnit > 0) {
            pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d Per  ", menuItem.priceUnit]];
        }
        
        cell.detailTextLabel.text = pricesString;
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
