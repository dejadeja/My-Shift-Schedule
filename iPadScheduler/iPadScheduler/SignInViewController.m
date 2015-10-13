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
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize signInBtn;
@synthesize signInLbl;
 
- (id)init {
    self = [super init];
    if (self) {
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(returnToSignIn)];
        
        self.navigationItem.leftBarButtonItem = cancelButton;
        
        self.user = [[User alloc] init];
        
        [self usernameTextFieldInit];
        [self passwordTextFieldInit];
        [self signInButtonInit];
        [self signInLabelInit];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSignIn) name:NOTIFICATION_SIGN_IN_USER object:nil];
    }
    return self;
}

#pragma mark - Load Views
- (void)loadView {
    [super loadView];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = DARK_GREY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - INITS
- (void)signInLabelInit {
    self.signInLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 100)];
    self.signInLbl.font = [UIFont fontWithName:@"Avenir" size:45];
    self.signInLbl.textColor = [UIColor whiteColor];
    self.signInLbl.text = @"Sign In";
    self.signInLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.signInLbl];
}

- (void)usernameTextFieldInit {
    usernameTextField = [self styleTextField:usernameTextField placeHolderText:@"Username"];
    usernameTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
    usernameTextField.center = CGPointMake(self.view.center.x, self.view.frame.size.height/3);
    usernameTextField = [self setBorder:usernameTextField];
    [usernameTextField addTarget:self action:@selector(usernameTextFieldEdited)
                forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:usernameTextField];
}

- (void)passwordTextFieldInit {
    passwordTextField = [self styleTextField:passwordTextField placeHolderText:@"Password"];
    passwordTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
    passwordTextField.center = CGPointMake(self.view.center.x, self.view.frame.size.height/2.5);
    passwordTextField = [self setBorder:passwordTextField];
    [passwordTextField addTarget:self action:@selector(passwordTextFieldEdited)
                forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passwordTextField];
}

- (void)signInButtonInit {
    signInBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [signInBtn addTarget:self action:@selector(userSignIn) forControlEvents:UIControlEventTouchUpInside];
    signInBtn.backgroundColor = ORANGE;
    [signInBtn setTitle:@"Sign In" forState:UIControlStateNormal];
    [signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signInBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 50);
    signInBtn.center = CGPointMake(self.view.center.x, self.view.frame.size.height/2.0);
    [self.view addSubview:signInBtn];
}


#pragma mark - Text Fields
- (void)usernameTextFieldEdited {
    self.user.username = usernameTextField.text;
}

- (void)passwordTextFieldEdited {
    self.user.password = passwordTextField.text;
}

#pragma mark - Sign in and Return to sign in
- (void)userSignIn {
    [self.user signIn];
}

- (void)returnToSignIn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Text Fields UI
- (UITextField *)setBorder: (UITextField*)textField {
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor whiteColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    return textField;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Change view
- (void)presentSignIn {
    IncomingWorkViewController *incomingWorkVC = [[IncomingWorkViewController alloc] init];
    UINavigationController *incomingWorkNavigationController = [[UINavigationController alloc] initWithRootViewController:incomingWorkVC];
    [self presentViewController:incomingWorkNavigationController animated:YES completion:NULL];
}
@end
