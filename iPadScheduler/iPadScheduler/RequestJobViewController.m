//
//  RequestJobViewController.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 02/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "RequestJobViewController.h"

@interface RequestJobViewController ()

@end

@implementation RequestJobViewController

@synthesize startPoint;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.job = [[Job alloc] init];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = DARK_GREY;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:AVAILABILITY_DATE_FORMAT];
    startPoint =  CGPointMake(self.view.center.x, self.view.frame.size.width/7);
    NSInteger sepration = 80;
    UIDatePicker *datePicker;
    UIBarButtonItem *doneButton;
    UIToolbar *toolbar;
    
    self.jobTitleTextField = [self styleTextField:self.jobTitleTextField placeHolderText:@"Job title"];
    self.jobTitleTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
    self.jobTitleTextField = [self setBorder:self.jobTitleTextField];
    self.jobTitleTextField.center = CGPointMake(startPoint.x, startPoint.y);
    
    self.companyTextField = [self styleTextField:self.companyTextField placeHolderText:@"Company"];
    self.companyTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
    self.companyTextField = [self setBorder:self.companyTextField];
    self.companyTextField.center = CGPointMake(startPoint.x, startPoint.y+=sepration);
    
    self.reportingToTextField = [self styleTextField:self.reportingToTextField placeHolderText:@"Reporting to"];
    self.reportingToTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
    self.reportingToTextField = [self setBorder:self.reportingToTextField];
    self.reportingToTextField.center = CGPointMake(startPoint.x, startPoint.y+=sepration);
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.center.x, self.view.frame.size.height/4)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(datePickerDateStart:) forControlEvents:UIControlEventValueChanged];
    
    toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0,0, self.view.frame.size.width, 44)];
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self action:@selector(startDateTextFieldDone)];
    [toolbar setItems:[NSArray arrayWithObjects: doneButton, nil] animated:NO];
    
    self.startDateTextField = [self styleTextField:self.startDateTextField placeHolderText:@"Start date"];
    self.startDateTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
    self.startDateTextField = [self setBorder:self.startDateTextField];
    self.startDateTextField.center = CGPointMake(startPoint.x, startPoint.y+=sepration);
    self.startDateTextField.inputView = datePicker;
    self.startDateTextField.inputAccessoryView = toolbar;
    self.startDateTextField.text = [dateFormat stringFromDate:[NSDate date]];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.center.x, self.view.frame.size.height/4)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(datePickerDateEnd:) forControlEvents:UIControlEventValueChanged];
    
    toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0,0, self.view.frame.size.width, 44)];
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                               target:self action:@selector(endDateTextFieldDone)];
    [toolbar setItems:[NSArray arrayWithObjects: doneButton, nil] animated:NO];
    
    self.endDateTextField = [self styleTextField:self.endDateTextField placeHolderText:@"End date"];
    self.endDateTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
    self.endDateTextField = [self setBorder:self.endDateTextField];
    self.endDateTextField.center = CGPointMake(startPoint.x, startPoint.y+=sepration);
    self.endDateTextField.inputView = datePicker;
    self.endDateTextField.inputAccessoryView = toolbar;
    self.endDateTextField.text = [dateFormat stringFromDate:[NSDate date]];
    
    self.addressTextField = [self styleTextField:self.addressTextField placeHolderText:@"Address"];
    self.addressTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
    self.addressTextField = [self setBorder:self.addressTextField];
    self.addressTextField.center = CGPointMake(startPoint.x, startPoint.y+=sepration);
    
    self.telephoneTextField = [self styleTextField:self.telephoneTextField placeHolderText:@"Telephone"];
    self.telephoneTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
    self.telephoneTextField = [self setBorder:self.telephoneTextField];
    self.telephoneTextField.center = CGPointMake(startPoint.x, startPoint.y+=sepration);
    
    self.uniformTextField = [self styleTextField:self.uniformTextField placeHolderText:@"Uniform"];
    self.uniformTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
    self.uniformTextField = [self setBorder:self.uniformTextField];
    self.uniformTextField.center = CGPointMake(startPoint.x, startPoint.y+=sepration);
    
    self.additionalTextField = [self styleTextField:self.additionalTextField placeHolderText:@"Additional"];
    self.additionalTextField.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 44);
    self.additionalTextField = [self setBorder:self.additionalTextField];
    self.additionalTextField.center = CGPointMake(startPoint.x, startPoint.y+=sepration);
    
    self.requestJobButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.requestJobButton addTarget:self action:@selector(requestJob) forControlEvents:UIControlEventTouchUpInside];
    self.requestJobButton.backgroundColor = ORANGE;
    [self.requestJobButton setTitle:@"Request Job" forState:UIControlStateNormal];
    [self.requestJobButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.requestJobButton.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 50);
    self.requestJobButton.center = CGPointMake(startPoint.x, startPoint.y+=110);
    
    self.job.startDate = [NSDate date];
    self.job.endDate = [NSDate date];
    
    [self.view addSubview:self.jobTitleTextField];
    [self.view addSubview:self.companyTextField];
    [self.view addSubview:self.reportingToTextField];
    [self.view addSubview:self.startDateTextField];
    [self.view addSubview:self.endDateTextField];
    [self.view addSubview:self.addressTextField];
    [self.view addSubview:self.telephoneTextField];
    [self.view addSubview:self.uniformTextField];
    [self.view addSubview:self.additionalTextField];
    [self.view addSubview:self.requestJobButton];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)endDateTextFieldDone
{
    [self.endDateTextField resignFirstResponder];
}

- (void)startDateTextFieldDone
{
    [self.startDateTextField resignFirstResponder];
}

- (void)datePickerDateStart:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:AVAILABILITY_DATE_FORMAT];
    self.startDateTextField.text = [dateFormat stringFromDate:[sender date]];
    self.job.startDate = [sender date];
}

- (void)datePickerDateEnd:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:AVAILABILITY_DATE_FORMAT];
    self.endDateTextField.text = [dateFormat stringFromDate:[sender date]];
    self.job.endDate = [sender date];
}

- (void)requestJob
{
    if ([self.job isJobValid])
    {
        self.job.jobTitle = self.jobTitleTextField.text;
        self.job.company = self.companyTextField.text;
        self.job.reportingTo = self.reportingToTextField.text;
        self.job.address = self.addressTextField.text;
        self.job.telephone = self.telephoneTextField.text;
        self.job.uniform = self.uniformTextField.text;
        self.job.additional = self.additionalTextField.text;
        [self.job requestJob];
        
        self.jobTitleTextField.text = @"";
        self.companyTextField.text = @"";
        self.reportingToTextField.text = @"";
        self.addressTextField.text = @"";
        self.telephoneTextField.text = @"";
        self.uniformTextField.text = @"";
        self.additionalTextField.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
