//
//  FirstViewController.m
//  Scheduling App
//
//  Created by Deja Cespedes on 28/01/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "SplashScreenView.h"
#import "RQShineLabel.h"

@interface SplashScreenView ()
@property (nonatomic, strong) RQShineLabel* shineLabel;
@end

@implementation SplashScreenView
@synthesize index;

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
    self.shineLabel = [[RQShineLabel alloc] initWithFrame:
                       CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2.0)];
    self.shineLabel.center = CGPointMake(self.view.center.x, self.view.frame.size.width/3);
    self.shineLabel.numberOfLines = 3;
    self.shineLabel.text = [self setShineLabelText];
    self.shineLabel.textAlignment = NSTextAlignmentCenter;
    self.shineLabel.font = [UIFont fontWithName:@"Avenir" size:40];
    self.shineLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.shineLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.shineLabel shine];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Shining Text 
- (NSString *) setShineLabelText
{
    NSString *shineLabelText;
    
    switch (index) {
        case 0:
            shineLabelText = [NSString stringWithFormat:@"Manage From Anywhere"];
            break;
            
        case 1:
            shineLabelText = [NSString stringWithFormat:@"iPhone & iPad Compatible"];
            break;

        case 2:
            shineLabelText = [NSString stringWithFormat:@"Register Today"];
            break;
    }
    
    return shineLabelText;
}
@end
