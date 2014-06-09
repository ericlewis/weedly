//
//  EELMenuTableViewController.m
//  weedly
//
//  Created by Eric Lewis on 5/4/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMenuTableViewController.h"
#import "EELArrayDataSource.h"

#import "DKScrollingTabController.h"

@interface EELMenuTableViewController () <DKScrollingTabControllerDelegate>

@property (strong, nonatomic) EELArrayDataSource *dataSource;
@property (strong, nonatomic) EELArrayDataSource *dataSourceUnfiltered;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSString *selectedTabName;
@property (strong, nonatomic) EELMenu *menuInfo;
@property (strong, nonatomic) DKScrollingTabController *tabController;


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
    
    self.title = [self.dispensary formattedNameString];
    
    [self getMenuInfo];
    [self getMenuItems];
    
    self.navigationController.navigationBar.translucent = NO;
    
    _tabController = [[DKScrollingTabController alloc] init];
    _tabController.delegate = self;
    [self addChildViewController:_tabController];
    [_tabController didMoveToParentViewController:self];
    [self.view addSubview:_tabController.view];
    _tabController.view.frame = CGRectMake(0, -40, self.view.bounds.size.width, 40);
    _tabController.view.clipsToBounds = YES;
    _tabController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tabController.view.backgroundColor = MAIN_COLOR;
    _tabController.buttonsScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tabController.buttonPadding = 15;
    _tabController.selectedBackgroundColor = [UIColor clearColor];
    _tabController.selectedTextColor = [UIColor whiteColor];
    _tabController.unselectedBackgroundColor = [UIColor clearColor];
    _tabController.unselectedTextColor = [UIColor whiteColor];
    _tabController.underlineIndicator = YES;
    _tabController.selection = @[@"All"];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top = 40;
    self.tableView.contentInset = insets;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
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
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        [items addObject:@"All"];
        
        for (NSString *catID in self.categories) {
            if ([catID isEqualToString:@"1"]) {
                [items addObject:@"Indica"];
            }
            
            else if ([catID isEqualToString:@"2"]) {
                [items addObject:@"Sativa"];
            }
            
            else if ([catID isEqualToString:@"3"]) {
                [items addObject:@"Hybrid"];
            }
            
            else if ([catID isEqualToString:@"4"]) {
                [items addObject:@"Edibles"];
            }
            
            else if ([catID isEqualToString:@"5"]) {
                [items addObject:@"Concentrates"];
            }
            
            else if ([catID isEqualToString:@"6"]) {
                [items addObject:@"Drinks"];
            }
            
            else if ([catID isEqualToString:@"7"]) {
                [items addObject:@"Clones"];
            }
            
            else if ([catID isEqualToString:@"8"]) {
                [items addObject:@"Seeds"];
            }
            
            else if ([catID isEqualToString:@"9"]) {
                [items addObject:@"Tinctures"];
            }
            
            else if ([catID isEqualToString:@"10"]) {
                [items addObject:@"Gear"];
            }
            
            else if ([catID isEqualToString:@"11"]) {
                [items addObject:@"Topicals"];
            }
            
            else if ([catID isEqualToString:@"12"]) {
                [items addObject:@"Prerolls"];
            }
            
            else if ([catID isEqualToString:@"13"]) {
                [items addObject:@"Wax"];
            }
        }
        
        self.tabController.selection = items;
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
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

#pragma mark - TabControllerDelegate

- (void)DKScrollingTabController:(DKScrollingTabController *)controller selection:(NSUInteger)selection {
    // ALL tab is always 0
    if (selection == 0) {
        self.dataSource = self.dataSourceUnfiltered;
    }else{
        NSString *catID = self.categories[selection-1];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"catID = %@", catID]];
        NSArray *filteredArray = [self.dataSourceUnfiltered.items filteredArrayUsingPredicate:predicate];
        
        self.dataSource = [EELArrayDataSource dataSourceWithItems:filteredArray];
    }

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
