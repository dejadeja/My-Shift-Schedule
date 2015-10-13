//
//  BaseViewController+SignInViewController.h
//  Scheduling App
//
//  Created by Deja Cespedes on 11/03/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "BaseViewController.h"

@interface SignInViewController : BaseViewController <UITableViewDelegate, UITextFieldDelegate, UISplitViewControllerDelegate>

@property (nonatomic, strong) User *user;

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *signInBtn;
@end
