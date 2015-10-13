//
//  RegisterViewController.h
//  Scheduling App
//
//  Created by Deja Cespedes on 19/02/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController <UITextFieldDelegate, UIApplicationDelegate, UIPickerViewDelegate>

@property (nonatomic, strong) User *user;

@property CGPoint startPoint;
@property (nonatomic, strong) UILabel *registerText;
@property (nonatomic, strong) UIPickerView *userTypePickerView;
@property (nonatomic, strong) UITextField *userTypeTextField;

//SIGN UP
@property (nonatomic, strong) UILabel *lblTermsAndCond;
@property (nonatomic, strong) UIButton *signInBtn;
@property (nonatomic, strong) UIButton *signUpBtn;

//BUSINESS
@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UITextField *companyNameTextField;
@property (nonatomic, strong) UITextField *sectorTextField;
@property (nonatomic, strong) UITextField *managerNameTextField;

//AGENCY / TEMPORARY AGENCY
@property (nonatomic, strong) UITextField *firstNameTextField;
@property (nonatomic, strong) UITextField *lastNameTextField;

//USER DETAILS
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *telephoneNumberTextField;

- (void)presentSignIn: (id)selector;
- (void)presentJobFeed;
- (NSString *)getUserType:(int)index;
- (void)userTypeSelected;
- (void)validateUser;

@end
