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
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) EELMenu *menuInfo;
@property (strong, nonatomic) BFNavigationBarDrawer *drawer;
@property (strong, nonatomic) REMenu *filterMenu;
@property (strong, nonatomic) NSString *filterMenuSelected;


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
                                                                    self.filterMenuSelected = item.title;
                                                                    [self setupTitle];

                                                                    self.dataSource = self.dataSourceUnfiltered;
                                                                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                }];
        
        REMenuItem *indicaItem = [[REMenuItem alloc] initWithTitle:@"Indica"
                                                             image:nil
                                                  highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                self.filterMenuSelected = item.title;
                                                                [self setupTitle];

                                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 1"];
                                                                NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                                
                                                                self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                            }];
        
        REMenuItem *sativaItem = [[REMenuItem alloc] initWithTitle:@"Sativa"
                                                             image:nil
                                                  highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                self.filterMenuSelected = item.title;
                                                                [self setupTitle];

                                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 2"];
                                                                NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                                
                                                                self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                            }];
        
        REMenuItem *hybridItem = [[REMenuItem alloc] initWithTitle:@"Hybrid"
                                                             image:nil
                                                  highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                self.filterMenuSelected = item.title;
                                                                [self setupTitle];

                                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 3"];
                                                                NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                                
                                                                self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                            }];
        
        REMenuItem *edibleItem = [[REMenuItem alloc] initWithTitle:@"Edibles"
                                                             image:nil
                                                  highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                self.filterMenuSelected = item.title;
                                                                [self setupTitle];

                                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 4"];
                                                                NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                                
                                                                self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                            }];
        
        REMenuItem *concentrateItem = [[REMenuItem alloc] initWithTitle:@"Concentrates"
                                                             image:nil
                                                  highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                self.filterMenuSelected = item.title;
                                                                [self setupTitle];

                                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 5"];
                                                                NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                                
                                                                self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                            }];
        
        REMenuItem *gearItem = [[REMenuItem alloc] initWithTitle:@"Gear"
                                                                  image:nil
                                                       highlightedImage:nil
                                                                 action:^(REMenuItem *item) {
                                                                     self.filterMenuSelected = item.title;
                                                                     [self setupTitle];

                                                                     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 10"];
                                                                     NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                                     
                                                                     self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                                     [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                 }];
        
        REMenuItem *waxItem = [[REMenuItem alloc] initWithTitle:@"Wax"
                                                           image:nil
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              self.filterMenuSelected = item.title;
                                                              [self setupTitle];

                                                              NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 13"];
                                                              NSArray *beginWithB = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
                                                              
                                                              self.dataSource = [EELArrayDataSource dataSourceWithItems:beginWithB];
                                                              [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                          }];
        
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        [items addObject:allItem];
        
        for (NSString *catID in self.categories) {
            if ([catID isEqualToString:@"1"]) {
                [items addObject:indicaItem];
            }
            
            else if ([catID isEqualToString:@"2"]) {
                [items addObject:sativaItem];
            }
            
            else if ([catID isEqualToString:@"3"]) {
                [items addObject:hybridItem];
            }
            
            else if ([catID isEqualToString:@"4"]) {
                [items addObject:edibleItem];
            }
            
            else if ([catID isEqualToString:@"5"]) {
                [items addObject:concentrateItem];
            }
            
            else if ([catID isEqualToString:@"10"]) {
                [items addObject:gearItem];
            }
            
            else if ([catID isEqualToString:@"13"]) {
                [items addObject:waxItem];
            }
        }
        
        
        self.filterMenu = [[REMenu alloc] initWithItems:items];
        self.filterMenu.backgroundColor = [UIColor colorWithRed:36/255.0f green:223/255.0f blue:177/255.0f alpha:1.0f];
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
        
        NSArray *arrOriginal = results;
        NSMutableDictionary *grouped = [[NSMutableDictionary alloc] initWithCapacity:arrOriginal.count];
        for (NSDictionary *dict in arrOriginal) {
            NSNumber *key = [dict valueForKey:@"catID"];
            
            NSMutableArray *tmp = [grouped objectForKey:key];
            if (tmp == nil) {
                tmp = [[NSMutableArray alloc] init];
                [grouped setValue:key.stringValue forKey:key.stringValue];
            }
            [tmp addObject:dict];
        }
        
        NSArray *sortedArray = [[grouped allValues] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];
        
        self.categories = sortedArray;
        
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
    label.text = [NSString stringWithFormat:@"Menu: %@\n%@", self.filterMenuSelected ?: @"All", [self.dispensary formattedNameString]];
    
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

        cell.textLabel.text = [menuItem formattedNameString];
        
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
