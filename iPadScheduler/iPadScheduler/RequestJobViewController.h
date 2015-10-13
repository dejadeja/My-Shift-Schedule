//
//  RequestJobViewController.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 02/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "BaseViewController.h"

@interface RequestJobViewController : BaseViewController

@property CGPoint startPoint;
@property (nonatomic, strong) Job *job;

@property (nonatomic, strong) UITextField *jobTitleTextField;
@property (nonatomic, strong) UITextField *companyTextField;
@property (nonatomic, strong) UITextField *reportingToTextField;
@property (nonatomic, strong) UITextField *startDateTextField;
@property (nonatomic, strong) UITextField *endDateTextField;
@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UITextField *telephoneTextField;
@property (nonatomic, strong) UITextField *uniformTextField;
@property (nonatomic, strong) UITextField *additionalTextField;
@property (nonatomic, strong) UIButton *requestJobButton;

@end
