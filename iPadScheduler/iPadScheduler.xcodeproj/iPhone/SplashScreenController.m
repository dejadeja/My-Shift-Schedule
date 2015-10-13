//
//  SplashScreenViewController.m
//  Scheduling App
//
//  Created by Deja Cespedes on 28/01/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "SplashScreenController.h"
#import "SplashScreenView.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"

@interface SplashScreenController ()

@end

@implementation SplashScreenController
@synthesize index, btnSignUp;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = DARK_GREY;
    self.navigationController.navigationBarHidden = TRUE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.dataSource = self;
    [[self.pageViewController view] setFrame:[[self view] bounds]];
    
    SplashScreenView *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:[self.pageViewController view]];
    [self.pageViewController didMoveToParentViewController:self];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = MEDIUM_GREY;
    pageControl.currentPageIndicatorTintColor = ORANGE;
    pageControl.backgroundColor = DARK_GREY;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - PageViewController delegate methods
- (SplashScreenView *)viewControllerAtIndex:(NSUInteger)indexx {
    SplashScreenView *childViewController = [[SplashScreenView alloc] init];
    childViewController.index = indexx;
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger _index = [(SplashScreenView *)viewController index];
    
    if (_index == 0) {
        return nil;
    }
    
    if (_index != 3)
    {
        if (!btnSignUp) {
            [self signInButton:_index];
        }
    }
    
    _index--;
    
    return [self viewControllerAtIndex:_index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger _index = [(SplashScreenView *)viewController index];
    _index++;
    
    if (_index == 3)
    {
        if (!btnSignUp) {
            [self signInButton:_index];
        }
        return nil;
    }
    
    return [self viewControllerAtIndex:_index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return index;
}

#pragma mark - Button
- (void)signInButton: (NSInteger)_index {
    btnSignUp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnSignUp.frame = CGRectMake(0, 0, 120, 50);
    btnSignUp.center = CGPointMake(self.view.center.x, self.view.frame.size.height/1.3);
    btnSignUp.backgroundColor = DARK_GREY;
    [btnSignUp setTitle:@"Sign Up!" forState:UIControlStateNormal];
    btnSignUp.titleLabel.font = [UIFont fontWithName:@"Avenir" size:26.0];
    [btnSignUp setTitleColor:ORANGE forState:UIControlStateNormal];
    [btnSignUp addTarget:self action:@selector(presentSignIn:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btnSignUp];
}

#pragma mark - Change view
- (void)presentSignIn: (id)selector
{
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    navigationController.navigationBar.barTintColor = DARK_GREY;
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    navigationController.viewControllers = [NSArray arrayWithObject:[[RegisterViewController alloc] init]];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}
@end
