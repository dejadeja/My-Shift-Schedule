//
//  SetAvailabilityViewController.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 01/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "BaseViewController.h"

@interface SetAvailabilityViewController : BaseViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) PFObject *availabilityObject;
@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) UITextField *availableFromTextField;
@property (nonatomic, strong) UITextField *availableToTextField;

@end
