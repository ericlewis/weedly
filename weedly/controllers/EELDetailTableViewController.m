//
//  EELDetailTableViewController.m
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDetailTableViewController.h"

@interface EELDetailTableViewController ()

@end

@implementation EELDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    // set the map
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:@"MapHeaderCell" forIndexPath:indexPath];
        }else if(indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"ItemHeaderCell" forIndexPath:indexPath];
        }
    }
    
    // set the action menu
    else if(indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ItemActionCell" forIndexPath:indexPath];
        
        NSUInteger row = indexPath.row;
        
        if (row == 0) {
            cell.textLabel.text = @"Directions";
            cell.imageView.image = [UIImage imageNamed:@"map_marker-128"];
        }else if (row == 1) {
            cell.textLabel.text = @"Call";
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
    }
    
    // Configure the cell...
    
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
    // show menu!
    if (indexPath.row == 2) {
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
