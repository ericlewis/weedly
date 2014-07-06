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
    if (!alarm_preference) {
        [self registerDefaultsFromSettingsBundle];
    }
    
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
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    BOOL alarm_preference = [[standardUserDefaults objectForKey:@"420_alarm_preference"] boolValue];
    [self toggleAlarm:alarm_preference];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    BOOL alarm_preference = [[standardUserDefaults objectForKey:@"420_alarm_preference"] boolValue];
    [self toggleAlarm:alarm_preference];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)toggleAlarm:(BOOL)switchEnabled {
    if (switchEnabled) {
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
    [weekdayComponents setMinute:19];
    NSDate *referenceTime = [gregorian dateFromComponents:weekdayComponents];
    
    notif.fireDate = referenceTime;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    
    notif.alertBody = @"It's almost 4:20! Toke up!";
    notif.hasAction = NO;
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.repeatInterval = NSDayCalendarUnit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
}

- (void)cancelAlarm{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
