//
//  BaseViewController+SignInViewController.m
//  Scheduling App
//
//  Created by Deja Cespedes on 11/03/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "SignInViewController.h"
#import "IncomingWorkViewController.h"

@implementation SignInViewController
@synthesize usernameTextField, passwordTextField, signInBtn;
 
- (id)init
{
    self = [super init];
    if (self) {
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(returnToSignIn)];
        
        self.navigationItem.leftBarButtonItem = cancelButton;
        
        self.user = [[User alloc] init];
        
        usernameTextField = [self styleTextField:usernameTextField placeHolderText:@"Username"];
        usernameTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        usernameTextField.center = CGPointMake(self.view.center.x, self.view.frame.size.height/2.8);
        usernameTextField = [self setBorder:usernameTextField];
        [usernameTextField addTarget:self action:@selector(usernameTextFieldEdited)
                        forControlEvents:UIControlEventEditingChanged];
        
        passwordTextField = [self styleTextField:passwordTextField placeHolderText:@"Password"];
        passwordTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        passwordTextField.center = CGPointMake(self.view.center.x, self.view.frame.size.height/2.35);
        passwordTextField = [self setBorder:passwordTextField];
        [passwordTextField addTarget:self action:@selector(passwordTextFieldEdited)
                    forControlEvents:UIControlEventEditingChanged];
        
        signInBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [signInBtn addTarget:self action:@selector(userSignIn) forControlEvents:UIControlEventTouchUpInside];
        signInBtn.backgroundColor = ORANGE;
        [signInBtn setTitle:@"Sign In" forState:UIControlStateNormal];
        [signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        signInBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 40);
        signInBtn.center = CGPointMake(self.view.center.x, self.view.frame.size.height/1.8);

        [self.view addSubview:signInBtn];
        [self.view addSubview:usernameTextField];
        [self.view addSubview:passwordTextField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSignIn) name:NOTIFICATION_SIGN_IN_USER object:nil];
    }
    return self;
}

- (void)userSignIn
{
    [self.user signIn];
}

- (void)usernameTextFieldEdited
{
    self.user.username = usernameTextField.text;
}

- (void)passwordTextFieldEdited
{
    self.user.password = passwordTextField.text;
}

- (void)returnToSignIn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    [super loadView];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = DARK_GREY;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UITextField *)setBorder: (UITextField*)textField
{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor whiteColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    return textField;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Change view
- (void)presentSignIn
{
    IncomingWorkViewController *incomingWorkVC = [[IncomingWorkViewController alloc] init];
    UINavigationController *incomingWorkNavigationController = [[UINavigationController alloc] initWithRootViewController:incomingWorkVC];
    [self presentViewController:incomingWorkNavigationController animated:YES completion:NULL];
}
@end
