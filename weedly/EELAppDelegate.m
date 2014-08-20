//
//  EELAppDelegate.m
//  weedly
//
//  Created by Eric Lewis on 5/1/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELAppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation EELAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    // color is the MAIN one used, should set constant
    [[UINavigationBar appearance] setBarTintColor:MAIN_COLOR];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationController *front = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FrontViewController"];
    self.window.rootViewController = front;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *alarm_preference = [standardUserDefaults objectForKey:@"420_alarm_preference"];
    NSString *seventen_alarm_preference = [standardUserDefaults objectForKey:@"710_alarm_preference"];

    if (!alarm_preference || !seventen_alarm_preference) {
        [self cancel420Alarm];
        [self cancel710Alarm];
        
        [self registerDefaultsFromSettingsBundle];
    }
    
    [UAAppReviewManager setAppID:@"885158116"];
    [UAAppReviewManager setSignificantEventsUntilPrompt:3];
    
    // IDK if this is bad practice. we will see.
    [Crashlytics startWithAPIKey:@"aa3ebef69236c7e1ec3eb569123ce003350b80c9"];

    return YES;
}

- (void)registerDefaultsFromSettingsBundle {
    // this function writes default settings as settings
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
            NSLog(@"writing as default %@ to the key %@",[prefSpecification objectForKey:@"DefaultValue"],key);
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    BOOL fourtwenty_alarm_preference = [[standardUserDefaults objectForKey:@"420_alarm_preference"] boolValue];
    [self toggle420Alarm:fourtwenty_alarm_preference];
    
    BOOL seventen_alarm_preference = [[standardUserDefaults objectForKey:@"710_alarm_preference"] boolValue];
    [self toggle710Alarm:seventen_alarm_preference];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)toggle710Alarm:(BOOL)switchEnabled {
    if (switchEnabled) {
        [self schedule420Alarm];
    }else{
        [self cancel420Alarm];
    }
}

- (void)schedule710Alarm{
    [self createAlarmsWithID:@"710" notificationText:@"It's almost 7:10! Dab up!" andHour:19 andMinute:9];
}

- (void)cancel710Alarm{
    [self cancelAlarmsWithID:@"710"];
}

- (void)toggle420Alarm:(BOOL)switchEnabled {
    if (switchEnabled) {
        [self schedule420Alarm];
    }else{
        [self cancel420Alarm];
    }
}

- (void)schedule420Alarm{
    [self createAlarmsWithID:@"420" notificationText:@"It's almost 4:20! Toke up!" andHour:16 andMinute:19];
}

- (void)cancel420Alarm{
    [self cancelAlarmsWithID:@"420"];
}

- (void)createAlarmsWithID:(NSString*)id notificationText:(NSString*)text andHour:(int)hour andMinute:(int)minute{
    [self cancelAlarmsWithID:id];
    
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
    [weekdayComponents setHour:hour];
    [weekdayComponents setMinute:minute];
    NSDate *referenceTime = [gregorian dateFromComponents:weekdayComponents];
    
    notif.fireDate = referenceTime;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    
    notif.alertBody = text;
    notif.hasAction = NO;
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.repeatInterval = NSDayCalendarUnit;
    notif.userInfo = @{@"id": id};
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
}

- (void)cancelAlarmsWithID:(NSString*)id{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"id"]];
        if ([uid isEqualToString:id])
        {
            [app cancelLocalNotification:oneEvent];
        }
    }
}

@end
