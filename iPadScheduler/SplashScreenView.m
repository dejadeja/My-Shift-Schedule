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
    self.shineLabel.center = CGPointMake(self.view.center.x, self.view.frame.size.width/7);
    self.shineLabel.numberOfLines = 3;
    self.shineLabel.text = [self initialiseView];
    self.shineLabel.textAlignment = NSTextAlignmentCenter;
    self.shineLabel.font = [UIFont fontWithName:@"Avenir" size:60];
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


#pragma mark - Set Image
-(UIImageView *)setImageForIndicator: (NSInteger)viewIndex {
    UIImage *introScreenImage;

    if (index == 0) {
        introScreenImage = [UIImage imageNamed:@"ManageFrom.png"];
    }
    else if (index == 1) {
      introScreenImage = [UIImage imageNamed:@"iPhoneiPad.png"];
    }
    else{
        introScreenImage = [UIImage imageNamed:@"Register Today.png"];
    }
        
    UIImageView *introImgView = [[UIImageView alloc] initWithImage:introScreenImage];
    introImgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    return introImgView;
}

#pragma mark - Shine Label
- (NSString *) initialiseView
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
    UIImageView *scrollViewimgView = [self setImageForIndicator:index];
    [self.view addSubview:scrollViewimgView];
    
    return shineLabelText;
}
@end
