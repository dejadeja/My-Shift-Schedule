//
//  SplashScreenViewController.h
//  Scheduling App
//
//  Created by Deja Cespedes on 28/01/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "BaseViewController.h"
@class SplashScreenController;

@interface SplashScreenController : BaseViewController <UIPageViewControllerDataSource>

@property (nonatomic) NSInteger index;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UIButton *btnSignUp;

- (void)signInButton:(NSInteger)_index;
- (void)presentSignIn: (id)selector;

@end
