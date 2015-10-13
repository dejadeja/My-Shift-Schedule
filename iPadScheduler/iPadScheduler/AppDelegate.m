//
//  AppDelegate.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 22/04/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "SplashScreenController.h"
#import "IncomingWorkViewController.h"
#import "SignInViewController.h"
#import "TimeSheetsViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()
@end

@implementation AppDelegate
@synthesize launchCount;
@synthesize splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"DIaxlxZqS1D4zwhlw6R723poo9pewyaxG9KOFF3X"
                  clientKey:@"ii8PMoge1HguFkJ4XofBAWAD4X6xl4m6MujizqzG"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if (![PFUser currentUser] || [self launchCount] == 0)
    {
        [self initPageViewController];
    }
    else
    {
        [self initIncomingJobsViewController];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Init UIPageViewController
- (void) initPageViewController {
    
    BaseViewController *splashScreenController = [[SplashScreenController alloc] init];
    UINavigationController *splashScreenNavigation = [[UINavigationController alloc] initWithRootViewController:splashScreenController];
    
    self.window.rootViewController = splashScreenNavigation;
}

#pragma mark - Init initIncomingJobsViewController
- (void) initIncomingJobsViewController {
    
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    navigationController.navigationBar.barTintColor = DARK_GREY;
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    navigationController.viewControllers = [NSArray arrayWithObject:[[IncomingWorkViewController alloc] init]];
    
    self.window.rootViewController = navigationController;
}

#pragma mark - Launching Options
- (NSInteger)launchCount {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    launchCount = [prefs integerForKey:@"launchCount"];
    [prefs setInteger:++launchCount  forKey:@"launchCount"];
    return launchCount;
}

@end
