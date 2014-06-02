//
//  EELSidebarTableViewController.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELSidebarTableViewController.h"

#import "EELMainViewController.h"
#import "EELSmokinOnTableViewController.h"

#define ACCOUNT_TITLE @"Account"
#define DEALS_TITLE @"Today's Deals"
#define MAP_TITLE @"Find Dispensaries"
#define SMOKIN_TITLE @"Smokin' On"
#define ALARM_TITLE @"4:20 Alarm"

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
                          //@{@"image": [UIImage imageNamed:@"accountIcon"],  @"title": ACCOUNT_TITLE},
                          @{@"image": [UIImage imageNamed:@"dealsIcon"],    @"title": DEALS_TITLE},
                          @{@"image": [UIImage imageNamed:@"map_marker-128"], @"title": MAP_TITLE},
                          @{@"image": [UIImage imageNamed:@"smokinonIcon"], @"title": SMOKIN_TITLE},
                          @{@"image": [UIImage imageNamed:@"alarmIcon"],    @"title": ALARM_TITLE},
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
    
    
    // configure the switch for alarm
    // i didn't feel like making a new tablecell
    // so loop and assign as needed

    UISwitch *alarmSwitch;
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UISwitch class]]) {
            alarmSwitch = (UISwitch*)view;
        }
    }
    
    if ([[[UIApplication sharedApplication] scheduledLocalNotifications] count] > 0) {
        [alarmSwitch setOn:YES];
    }else{
        [alarmSwitch setOn:NO];
    }
    
    [alarmSwitch addTarget:self action:@selector(toggleAlarm:) forControlEvents:UIControlEventValueChanged];
    
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
        NSString *title = [[self.sidebarItems objectAtIndex:index] valueForKey:@"title"];
        
        // account
        if ([title isEqualToString:ACCOUNT_TITLE]){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            if ([[EELWMClient sharedClient] isAccountLoggedIn]) {
                // needs to push to nav controller
                [self performSegueWithIdentifier:@"ShowAccount" sender:self];
            }else{
                // prompt that they need to login
                [self performSegueWithIdentifier:@"ShowLogin" sender:self];
            }
        }
        
        // Today's Deals
        else if ([title isEqualToString:DEALS_TITLE]){
            [self performSegueWithIdentifier:@"ShowTodaysDeals" sender:self];
        }
        
        // map
        else if ([title isEqualToString:MAP_TITLE]){
            UINavigationController *nav = (UINavigationController*)self.revealController.frontViewController;
            if (![nav.topViewController isKindOfClass:[EELMainViewController class]]) {
                UINavigationController *front = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FrontViewController"];
                [self.revealController setFrontViewController:front];
            }
            
            [self.revealController showViewController:self.revealController.frontViewController animated:YES completion:nil];
        }
        
        // Smokin' On
        else if ([title isEqualToString:SMOKIN_TITLE]){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            // needs to push to nav controller
            //[self performSegueWithIdentifier:@"ShowSmokinOn" sender:self];
            UINavigationController *nav = (UINavigationController*)self.revealController.frontViewController;
            if (![nav.topViewController isKindOfClass:[EELSmokinOnTableViewController class]]) {
                UINavigationController *front = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SmokinOnNav"];
                [self.revealController setFrontViewController:front];
            }
            
            [self.revealController showViewController:self.revealController.frontViewController animated:YES completion:nil];

        }
    }
}

- (IBAction)toggleAlarm:(id)sender {
    UISwitch *alarmSwitch = (UISwitch*)sender;
    
    if (alarmSwitch.isOn) {
        [self scheduleAlarm];
    }else{
        [self cancelAlarm];
    }
}

- (void)scheduleAlarm{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    UILocalNotification *notif = [[UILocalNotification alloc] init];
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
    [weekdayComponents setHour:16];
    [weekdayComponents setMinute:20];
    NSDate *referenceTime = [gregorian dateFromComponents:weekdayComponents];
    
    notif.fireDate = referenceTime;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    
    notif.alertBody = @"It's 4:20! Toke up!";
    notif.hasAction = NO;
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.repeatInterval = NSDayCalendarUnit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
}

- (void)cancelAlarm{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
