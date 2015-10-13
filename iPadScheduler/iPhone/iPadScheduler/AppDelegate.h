//
//  AppDelegate.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 22/04/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSInteger launchCount;
@property (nonatomic, strong) UISplitViewController *splitViewController;
@end

