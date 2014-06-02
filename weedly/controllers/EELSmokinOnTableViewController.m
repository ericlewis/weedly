//
//  EELSmokinOnTableViewController.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELSmokinOnTableViewController.h"
#import "UIImageView+AFNetworking.h"

#import "EELArrayDataSource.h"

@interface EELSmokinOnTableViewController ()

@property (strong, nonatomic) EELArrayDataSource *dataSource;

@end

@implementation EELSmokinOnTableViewController

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
    
    [self getSmokinOn];
}

- (void)getSmokinOn{
    [[EELWMClient sharedClient] getSmokinOnListWithCompletionBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"noooo: %@", error);
            return;
        }
        
        self.dataSource = [EELArrayDataSource dataSourceWithItems:results];
        [self.tableView reloadData];
    }];
}

- (IBAction)showSidebar:(id)sender {
    [self.revealController showViewController:self.revealController.leftViewController];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    // Configure the cell...
    EELSmokinOn *smokinItem = self.dataSource.items[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ • %@", smokinItem.name, smokinItem.timeAgo.timeAgoSinceNow];
    cell.detailTextLabel.text = [smokinItem formattedStatusString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [[self.dataSource.items objectAtIndex:[indexPath row]] status];
    CGSize size = [text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:12.0f]}];
    CGFloat height = MAX(size.height, 80);
    
    return height + (25 * 2);
}



@end
