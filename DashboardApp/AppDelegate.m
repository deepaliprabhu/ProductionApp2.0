//
//  AppDelegate.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 13/06/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import <Parse/Parse.h>
#import "Defines.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupParse];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    HomeViewController *homeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:nil toolbarClass:nil];

    [navigationController setViewControllers:@[homeVC]];
    
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupParse {
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"8bt2VSdezwVq4A2VOg86OJDGk51yMSJxapnK2XoR";
        configuration.clientKey = @"6HVTHAoTThUC9uM9UIPBorcxsOyDue3v6t4GRLtK";
        configuration.server = @"https://parseapi.back4app.com/";
    }]];
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicWriteAccess:YES];
    [defaultACL setPublicReadAccess:YES];
    
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
