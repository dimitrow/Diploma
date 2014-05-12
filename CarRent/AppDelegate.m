//
//  AppDelegate.m
//  CarRent
//
//  Created by Eugene Dimitrow on 3/18/14.
//  Copyright (c) 2014 RockyTurtle. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Constants.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [Parse setApplicationId:@"mnju9WvdIprYzFQBzMh5alvKigwWN5faO44fKCGE"
                  clientKey:@"FloNH7ZoSMpwMW00hUpPYb8rqDfYN6fQLztOtbHd"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [[UINavigationBar appearance] setBarTintColor:COLOR_MAIN_BLUE];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:COLOR_MAIN_BLUE];
    [[UITabBar appearance] setTintColor:COLOR_MAIN_WHITE];
    [PFImageView class];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Deftone Stylus"  size:30.0], NSFontAttributeName, nil]];
    
    //NSLog(@"%@", [UIFont familyNames]);
    return YES;
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
