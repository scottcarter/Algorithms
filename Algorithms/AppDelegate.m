//
//  AppDelegate.m
//  Algorithms
//
//  Created by Scott Carter on 8/15/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)navigationController.topViewController;
    
    // Initialize our database.
    self.algorithmDatabase = @[@{@"sectionLabel": @"Numerical",
                                 @"algorithms" : @[
                                         @{@"algorithmLabel": @"Two Dice Roll Simulation", @"algorithmName": @"TwoDiceRollSimulation",
                                           @"about":@"Simulates rolling two six-sided dice and draws a bar chart showing the number of times each roll occurs.\nAlso shows expected percentage of the time one should get each roll.\n\nGreater number of trials reduce the percentage difference between random roll percentages and expected percentages."},
                                         ]},
                               @{@"sectionLabel": @"General",
                                 @"algorithms" : @[
                                         @{@"algorithmLabel": @"Misc Tests", @"algorithmName": @"Console",
                                           @"about":@"Misc C++ tests that output to the console."},
                                         ]},
                               ];
    
    

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
