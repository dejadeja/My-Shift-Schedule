//
//  JobAllocationViewController.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 04/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "BaseViewController.h"
#import "TimeSchedule.h"

@interface JobAllocationViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Job *job;
@property (nonatomic, strong) JobAllocation *jobAllocation;
@property (nonatomic, strong) PFObject *pfJob;
@property (nonatomic, strong) TimeSchedule *timeSchedule;

@property (nonatomic, strong) NSArray *temporaryAgencies;
@property (nonatomic, strong) NSMutableArray *jobAllocationsArray;
@property (nonatomic, strong) NSMutableArray *selectedAgencyObjects;
@property (nonatomic, strong) NSMutableArray *allocationDates;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UITableView *temporaryAgencyTableView;
@property (nonatomic, strong) UILabel *jobAvailabilityLabel;
@property (nonatomic, strong) UIButton *confirmJobAllocationsBtn;

@end
