//
//  BaseViewController.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 22/04/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize changedMonth;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
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

#pragma mark - Textfield Style
- (UITextField *)styleTextField: (UITextField *)textField placeHolderText: (NSString *)placeHolderText
{
    textField =[[UITextField alloc] init];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont fontWithName:@"Avenir" size:20];
    textField.textColor = [UIColor whiteColor];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.layer.masksToBounds = YES;
    
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolderText attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    return textField;
}

@end
