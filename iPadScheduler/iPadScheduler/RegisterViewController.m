//
//  RegisterViewController.m
//  Scheduling App
//
//  Created by Deja Cespedes on 19/02/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "RegisterViewController.h"
#import "IncomingWorkViewController.h"
#import "SignInViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize startPoint;

- (id)init {
    self = [super init];
    if (self) {
        
        self.user = [[User alloc] init];
        
        self.registerText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        self.registerText.font = [UIFont fontWithName:@"Avenir" size:45];
        self.registerText.textColor = [UIColor whiteColor];
        self.registerText.text = @"Register";
        self.registerText.textAlignment = NSTextAlignmentCenter;
        
        UIPickerView *userTypePickerView = [self createUserTypePickerView];
        
        UIToolbar *userTypeToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0,0, self.view.frame.size.width, 44)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self action:@selector(userTypeSelected)];
        [userTypeToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
        
        self.userTypeTextField = [self styleTextField:self.userTypeTextField placeHolderText:@"Tell Us Who You Are"];
        self.userTypeTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        self.userTypeTextField = [self setBorder:self.userTypeTextField];
        self.userTypeTextField.inputView = userTypePickerView;
        self.userTypeTextField.inputAccessoryView = userTypeToolbar;
        self.userTypeTextField.clearButtonMode = UITextFieldViewModeNever;
        
        
        self.lblTermsAndCond = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3, 80)];
        self.lblTermsAndCond.text = [NSString stringWithFormat:@"By clicking join now, you agree to My Shift Schedule User Agreement, Privacy Policy, and Cookie Policy"];
        self.lblTermsAndCond.textColor = [UIColor grayColor];
        self.lblTermsAndCond.lineBreakMode = NSLineBreakByWordWrapping;
        self.lblTermsAndCond.font = [UIFont systemFontOfSize:12];
        self.lblTermsAndCond.numberOfLines = 2;
        self.lblTermsAndCond.textAlignment = NSTextAlignmentCenter;
        self.lblTermsAndCond.textColor = [UIColor whiteColor];
        
        self.signInBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.signInBtn addTarget:self action:@selector(validateUser) forControlEvents:UIControlEventTouchUpInside];
        self.signInBtn.backgroundColor = ORANGE;
        [self.signInBtn setTitle:@"Get Started" forState:UIControlStateNormal];
        [self.signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.signInBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 50);
        
        self.signUpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.signUpBtn addTarget:self action:@selector(presentSignIn:) forControlEvents:UIControlEventTouchUpInside];
        self.signUpBtn.backgroundColor = [UIColor clearColor];
        self.signUpBtn.titleLabel.numberOfLines = 2;
        [self.signUpBtn setTitle:@"Already Signed Up? Sign In" forState:UIControlStateNormal];
        [self.signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.signUpBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 30);
        self.signUpBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.signUpBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [self updateFieldPositions];
        [self updateSignInPositions];
        
        [self.view addSubview:self.registerText];
        [self.view addSubview:self.userTypeTextField];
        
        [self.view addSubview:self.lblTermsAndCond];
        [self.view addSubview:self.signUpBtn];
        [self.view addSubview:self.signInBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentJobFeed) name:NOTIFICATION_SIGN_UP_USER object:nil];
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

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController.navigationBar setBarTintColor:DARK_GREY];
    [self.navigationController.navigationBar setTranslucent:NO];
    [super viewWillAppear:animated];
}

#pragma mark - Handle User Type
- (NSString *)getUserType:(int)index {
    switch (index) {
        case 0:
            return BUSINESS_USER;
            break;
            
        case 1:
            return AGENCY_USER;
            
        case 2:
            return TEMPORARY_AGENCY_USER;
            
        default:
            return @"";
    }
}

- (void)userTypeSelected {
    if ([self.userTypeTextField.text isEqualToString:@""]) {
        self.userTypeTextField.text = [self getUserType:0];
    }
    self.user.userType = self.userTypeTextField.text;
    [self updateFieldPositions];
    [self changeUserFields];
    [self updateSignInPositions];
    
    [self.userTypeTextField resignFirstResponder];
}

- (void)validateUser {
    
    if (self.user.isUserValid)
    {
        [self.user signUp];
    }
}

#pragma mark - Validate Text Fields
- (void)validateTextFields {
    
}


#pragma mark - Change Field Positions / Remove Field Positions
- (void)updateFieldPositions {
    startPoint =  CGPointMake(self.view.center.x, self.view.frame.size.width/8);
    
    self.registerText.center = startPoint;
    self.userTypeTextField.center = CGPointMake(startPoint.x, startPoint.y+=120);
}

- (void)changeUserFields {
    [self removeAllFields];
    
    if ([self.userTypeTextField.text isEqual:BUSINESS_USER])
    {
        self.addressTextField = [self styleTextField:self.addressTextField placeHolderText:@"Address"];
        self.addressTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        self.addressTextField = [self setBorder:self.addressTextField];
        self.addressTextField.center = CGPointMake(startPoint.x, startPoint.y+=100);
        [self.addressTextField addTarget:self action:@selector(addressTextFieldEdited)
                        forControlEvents:UIControlEventEditingChanged];
        
        self.companyNameTextField = [self styleTextField:self.companyNameTextField placeHolderText:@"Company name"];
        self.companyNameTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        self.companyNameTextField = [self setBorder:self.companyNameTextField];
        self.companyNameTextField.center = CGPointMake(startPoint.x, startPoint.y+=50);
        [self.companyNameTextField addTarget:self action:@selector(companyNameTextFieldEdited)
                            forControlEvents:UIControlEventEditingChanged];
        
        self.sectorTextField = [self styleTextField:self.sectorTextField placeHolderText:@"Sector"];
        self.sectorTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        self.sectorTextField = [self setBorder:self.sectorTextField];
        self.sectorTextField.center = CGPointMake(startPoint.x, startPoint.y+=50);
        [self.sectorTextField addTarget:self action:@selector(sectorTextFieldEdited)
                       forControlEvents:UIControlEventEditingChanged];
        
        self.managerNameTextField = [self styleTextField:self.managerNameTextField placeHolderText:@"Manager name"];
        self.managerNameTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        self.managerNameTextField = [self setBorder:self.managerNameTextField];
        self.managerNameTextField.center = CGPointMake(startPoint.x, startPoint.y+=50);
        [self.managerNameTextField addTarget:self action:@selector(managerNameTextFieldEdited)
                            forControlEvents:UIControlEventEditingChanged];
        
        [self.view addSubview:self.addressTextField];
        [self.view addSubview:self.companyNameTextField];
        [self.view addSubview:self.sectorTextField];
        [self.view addSubview:self.managerNameTextField];
    }
    else if ([self.userTypeTextField.text isEqualToString:TEMPORARY_AGENCY_USER] ||
             [self.userTypeTextField.text isEqualToString:AGENCY_USER])
    {
        self.firstNameTextField = [self styleTextField:self.firstNameTextField placeHolderText:@"First name"];
        self.firstNameTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        self.firstNameTextField = [self setBorder:self.firstNameTextField];
        self.firstNameTextField.center = CGPointMake(startPoint.x, startPoint.y+=100);
        [self.firstNameTextField addTarget:self action:@selector(firstNameTextFieldEdited)
                          forControlEvents:UIControlEventEditingChanged];
        
        self.lastNameTextField = [self styleTextField:self.lastNameTextField placeHolderText:@"Last name"];
        self.lastNameTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        self.lastNameTextField = [self setBorder:self.lastNameTextField];
        self.lastNameTextField.center = CGPointMake(startPoint.x, startPoint.y+=50);
        [self.lastNameTextField addTarget:self action:@selector(lastNameTextFieldEdited)
                         forControlEvents:UIControlEventEditingChanged];
        
        self.addressTextField = [self styleTextField:self.addressTextField placeHolderText:@"Address"];
        self.addressTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        self.addressTextField = [self setBorder:self.addressTextField];
        self.addressTextField.center = CGPointMake(startPoint.x, startPoint.y+=50);
        [self.addressTextField addTarget:self action:@selector(addressTextFieldEdited)
                        forControlEvents:UIControlEventEditingChanged];
        
        [self.view addSubview:self.firstNameTextField];
        [self.view addSubview:self.lastNameTextField];
        [self.view addSubview:self.addressTextField];
    }
    
    if (!self.telephoneNumberTextField)
    {
        self.telephoneNumberTextField = [self styleTextField:self.telephoneNumberTextField placeHolderText:@"Telephone number"];
        self.telephoneNumberTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        self.telephoneNumberTextField = [self setBorder:self.telephoneNumberTextField];
        [self.telephoneNumberTextField addTarget:self action:@selector(telephoneNumberTextFieldEdited)
                                forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:self.telephoneNumberTextField];
    }
    self.telephoneNumberTextField.center = CGPointMake(startPoint.x, startPoint.y+=80);
    
    if (!self.emailTextField)
    {
        self.emailTextField = [self styleTextField:self.emailTextField placeHolderText:@"Email"];
        self.emailTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        self.emailTextField = [self setBorder:self.emailTextField];
        [self.emailTextField addTarget:self action:@selector(emailTextFieldEdited)
                      forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:self.emailTextField];
    }
    self.emailTextField.center = CGPointMake(startPoint.x, startPoint.y+=50);
    
    if (!self.usernameTextField)
    {
        self.usernameTextField = [self styleTextField:self.usernameTextField placeHolderText:@"Username"];
        self.usernameTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        self.usernameTextField = [self setBorder:self.usernameTextField];
        [self.usernameTextField addTarget:self action:@selector(usernameTextFieldEdited)
                         forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:self.usernameTextField];
    }
    self.usernameTextField.center = CGPointMake(startPoint.x, startPoint.y+=50);
    
    if (!self.passwordTextField)
    {
        self.passwordTextField = [self styleTextField:self.passwordTextField placeHolderText:@"Password"];
        self.passwordTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        self.passwordTextField = [self setBorder:self.passwordTextField];
        self.passwordTextField.secureTextEntry = YES;
        [self.passwordTextField addTarget:self action:@selector(passwordTextFieldEdited)
                         forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:self.passwordTextField];
    }
    self.passwordTextField.center = CGPointMake(startPoint.x, startPoint.y+=50);
    
    if (!self.confirmPasswordTextField)
    {
        self.confirmPasswordTextField = [self styleTextField:self.confirmPasswordTextField placeHolderText:@"Confirm password"];
        self.confirmPasswordTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
        self.confirmPasswordTextField = [self setBorder:self.confirmPasswordTextField];
        self.confirmPasswordTextField.secureTextEntry = YES;
        [self.view addSubview:self.confirmPasswordTextField];
    }
    self.confirmPasswordTextField.center = CGPointMake(startPoint.x, startPoint.y+=50);
}

- (void)updateSignInPositions {
    self.lblTermsAndCond.center = CGPointMake(startPoint.x, startPoint.y+=100);
    self.signInBtn.center = CGPointMake(startPoint.x, startPoint.y+=50);
    self.signUpBtn.center = CGPointMake(startPoint.x, startPoint.y+=50);
}

- (void)removeAllFields {
    if (self.addressTextField)
    {
        [self.addressTextField removeFromSuperview];
        self.addressTextField = NULL;
    }
    
    if (self.companyNameTextField)
    {
        [self.companyNameTextField removeFromSuperview];
        self.companyNameTextField = NULL;
    }
    
    if (self.sectorTextField)
    {
        [self.sectorTextField removeFromSuperview];
        self.sectorTextField = NULL;
    }
    
    if (self.managerNameTextField)
    {
        [self.managerNameTextField removeFromSuperview];
        self.managerNameTextField = NULL;
    }
    
    if (self.firstNameTextField)
    {
        [self.firstNameTextField removeFromSuperview];
        self.firstNameTextField = NULL;
    }
    
    if (self.lastNameTextField)
    {
        [self.lastNameTextField removeFromSuperview];
        self.lastNameTextField = NULL;
    }
}


#pragma mark - Edit Text Field
- (void)addressTextFieldEdited {
    self.user.address = self.addressTextField.text;
}

- (void)sectorTextFieldEdited {
    self.user.sector = self.sectorTextField.text;
}

- (void)managerNameTextFieldEdited {
    self.user.managerName = self.managerNameTextField.text;
}

- (void)companyNameTextFieldEdited {
    self.user.companyName = self.companyNameTextField.text;
}

- (void)firstNameTextFieldEdited {
    self.user.firstName = self.firstNameTextField.text;
}

- (void)lastNameTextFieldEdited {
    self.user.lastName = self.lastNameTextField.text;
}

- (void)usernameTextFieldEdited {
    self.user.username = self.usernameTextField.text;
}

- (void)passwordTextFieldEdited {
    self.user.password = self.passwordTextField.text;
}

- (void)telephoneNumberTextFieldEdited {
    self.user.telephoneNumber = self.telephoneNumberTextField.text;
}

- (void)emailTextFieldEdited {
    self.user.email = self.emailTextField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UIPickerView Delegate Methods
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self getUserType:(int)row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.view.frame.size.width;
}

- (UIPickerView *)createUserTypePickerView {
    UIPickerView *userTypePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.center.x, self.view.frame.size.height/4)];
    userTypePickerView.delegate = self;
    userTypePickerView.showsSelectionIndicator = YES;
    
    return userTypePickerView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    self.userTypeTextField.text = [self getUserType:(int)row];
}


#pragma mark - Change view
- (void)presentJobFeed {
    IncomingWorkViewController *incomingWorkVC = [[IncomingWorkViewController alloc] init];
    UINavigationController *incomingWorkNavigationController = [[UINavigationController alloc] initWithRootViewController:incomingWorkVC];
    [self presentViewController:incomingWorkNavigationController animated:YES completion:NULL];
}

- (void)presentSignIn:(id)selector {
    [self.navigationController pushViewController:[[SignInViewController alloc] init] animated:YES];
}
@end
