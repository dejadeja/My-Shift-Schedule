//
//  SetAvailabilityViewController.m
//  iPadScheduler
// 
//  Created by Deja Cespedes on 01/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "SetAvailabilityViewController.h"

@interface SetAvailabilityViewController ()

@end

@implementation SetAvailabilityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = DARK_GREY;
    self.user = [[User alloc] init];
    [self.user retrieveAvailability];
    
    UILabel *availableFromLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    availableFromLabel.text = @"Available From";
    availableFromLabel.textColor = [UIColor whiteColor];
    availableFromLabel.center = CGPointMake(self.view.center.x, self.view.frame.size.height/3.7);
    availableFromLabel.textAlignment = NSTextAlignmentCenter;
    availableFromLabel.font = [UIFont systemFontOfSize:18.0];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.center.x, self.view.frame.size.height/4)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(datePickerFromChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0,0, self.view.frame.size.width, 44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                             target:self action:@selector(datePickerFromDone)];
    [toolbar setItems:[NSArray arrayWithObjects: doneButton, nil] animated:NO];
    
    self.availableFromTextField = [self styleTextField:self.availableFromTextField placeHolderText:@""];
    self.availableFromTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
    self.availableFromTextField = [self setBorder:self.availableFromTextField];
    self.availableFromTextField.center = CGPointMake(self.view.center.x, self.view.frame.size.height/3);
    self.availableFromTextField.inputView = datePicker;
    self.availableFromTextField.inputAccessoryView = toolbar;
    self.availableFromTextField.clearButtonMode = UITextFieldViewModeNever;
    
    UILabel *availableToLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    availableToLabel.text = @"Available To";
    availableToLabel.textColor = [UIColor whiteColor];
    availableToLabel.center = CGPointMake(self.view.center.x, self.view.frame.size.height/2.27);
    availableToLabel.textAlignment = NSTextAlignmentCenter;
    availableToLabel.font = [UIFont systemFontOfSize:18.0];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.center.x, self.view.frame.size.height/4)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(datePickerToChanged:) forControlEvents:UIControlEventValueChanged];
    
    toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0,0, self.view.frame.size.width, 44)];
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                             target:self action:@selector(datePickerToDone)];
    [toolbar setItems:[NSArray arrayWithObjects: doneButton, nil] animated:NO];
    
    self.availableToTextField = [self styleTextField:self.availableToTextField placeHolderText:@""];
    self.availableToTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
    self.availableToTextField = [self setBorder:self.availableToTextField];
    self.availableToTextField.center = CGPointMake(self.view.center.x, self.view.frame.size.height/2);
    self.availableToTextField.inputView = datePicker;
    self.availableToTextField.inputAccessoryView = toolbar;
    self.availableToTextField.clearButtonMode = UITextFieldViewModeNever;
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.saveBtn addTarget:self action:@selector(saveAvailability) forControlEvents:UIControlEventTouchUpInside];
    self.saveBtn.backgroundColor = ORANGE;
    [self.saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 50);
    self.saveBtn.center = CGPointMake(self.view.center.x, self.view.frame.size.height/1.5);
    
    [self.view addSubview:self.availableFromTextField];
    [self.view addSubview:self.availableToTextField];
    [self.view addSubview:availableFromLabel];
    [self.view addSubview:availableToLabel];
    [self.view addSubview:self.saveBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAvailablityTextFields:) name:NOTIFICATION_USER_AVAILABILITY object:nil];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)saveAvailability
{
    [self.user updateAvailability:self.availabilityObject];
    [self.availableFromTextField resignFirstResponder];
    [self.availableToTextField resignFirstResponder];
    [self.saveBtn setTitle:@"Saved!" forState:UIControlStateNormal];
}

- (void)setAvailablityTextFields:(NSNotification*)notification
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:AVAILABILITY_DATE_FORMAT];
    self.availabilityObject = [notification object];
    self.availableFromTextField.text = [dateFormat stringFromDate:self.availabilityObject[@"availableFrom"]];
    self.availableToTextField.text = [dateFormat stringFromDate:self.availabilityObject[@"availableTo"]];
    
    UIDatePicker *datePicker;
    
    datePicker = (UIDatePicker*)self.availableFromTextField.inputView;
    datePicker.date = self.availabilityObject[@"availableFrom"];
    
    datePicker = (UIDatePicker*)self.availableToTextField.inputView;
    datePicker.date = self.availabilityObject[@"availableTo"];
}

- (void)datePickerFromChanged:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:AVAILABILITY_DATE_FORMAT];
    self.availabilityObject[@"availableFrom"] = [sender date];
    self.availableFromTextField.text = [dateFormat stringFromDate:[sender date]];
}

- (void)datePickerFromDone
{
    [self.availableFromTextField resignFirstResponder];
    [self.saveBtn setTitle:@"Save" forState:UIControlStateNormal];
}

- (void)datePickerToChanged:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:AVAILABILITY_DATE_FORMAT];
    self.availabilityObject[@"availableTo"] = [sender date];
    self.availableToTextField.text = [dateFormat stringFromDate:[sender date]];
}

- (void)datePickerToDone
{
    [self.availableToTextField resignFirstResponder];
    [self.saveBtn setTitle:@"Save" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
