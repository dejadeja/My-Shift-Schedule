//
//  JobAllocationViewController.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 04/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "JobAllocationViewController.h"

@interface JobAllocationViewController ()

@end

@implementation JobAllocationViewController

#pragma mark - Load Views
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = DARK_GREY;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(returnToIncomingWork)];
    [cancelButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveTemporaryAgencies:) name:NOTIFICATION_RETRIEVE_TEMPORARY_AGENCIES object:nil];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)retrieveTemporaryAgencies:(NSNotification*)notification
{
    self.temporaryAgencies = [notification object];
    [self.temporaryAgencyTableView reloadData];
}


- (void)confirmJobAllocation
{
    NotificationObject *notification;
    
    for (JobAllocation *jobAllocation in self.jobAllocationsArray)
    {
        [jobAllocation addJobAllocation];
        
        // notification to temporary agency
        notification = [[NotificationObject alloc] init];
        notification.recipient = jobAllocation.temporaryAgency;
        notification.notificationString = [NSString stringWithFormat:@"You've been successfully assigned to\n%@ from %@ to %@",
                                           jobAllocation.job[@"jobTitle"], [self.dateFormatter stringFromDate:jobAllocation.startDate],
                                           [self.dateFormatter stringFromDate:jobAllocation.endDate]];
        [notification postNotification];
        
        // notification to business
        notification = [[NotificationObject alloc] init];
        notification.recipient = jobAllocation.job[@"business"];
        notification.notificationString = [NSString stringWithFormat:@"%@ %@ has successfully been assigned\nto your job: %@",
                                           jobAllocation.temporaryAgency[@"firstName"], jobAllocation.temporaryAgency[@"lastName"],
                                           jobAllocation.job[@"jobTitle"]];
        [notification postNotification];
    }
    [self.job setJobForCompletion:self.pfJob];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_TABLEVIEW object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateJobAvailabilityLabelText
{
    if (!self.allocationDates.count) {
        
        self.jobAvailabilityLabel.text = @"Job Successfully Allocated!\n\n\n";
        [self.view addSubview:self.confirmJobAllocationsBtn];
    }
    else
    {
        self.jobAvailabilityLabel.text = [NSString stringWithFormat:@"Allocate Temporary Agencies For Dates From:\n\n%@\n-\n%@",
                                          [self.dateFormatter stringFromDate:self.pfJob[@"startDate"]],
                                          [self.dateFormatter stringFromDate:self.pfJob[@"endDate"]]];
        self.jobAvailabilityLabel.font = [UIFont fontWithName:@"Avenir" size:14];
        [self.confirmJobAllocationsBtn removeFromSuperview];
    }
}


- (void)calculateRemainingAllocationDates:(int)index
{
    self.timeSchedule = [self.allocationDates firstObject];
    PFObject *temporaryAgency = [self.temporaryAgencies objectAtIndex:index];
    
    if ([self.selectedAgencyObjects containsObject:temporaryAgency])
    {
        [self.selectedAgencyObjects removeObject:temporaryAgency];
        [self resetDateAllocations];
    }
    else
    {
        [self.selectedAgencyObjects addObject:temporaryAgency];
        temporaryAgency[@"allocation"] = @"";
        temporaryAgency[@"allocationNumber"] = [NSNumber numberWithInt:1];
        [self addToAllocationTimes:temporaryAgency];
    }
    [self.temporaryAgencyTableView reloadData];
}

- (void)resetDateAllocations
{
    [self.jobAllocationsArray removeAllObjects];
    [self.allocationDates removeAllObjects];
    self.timeSchedule = [[TimeSchedule alloc] init];
    self.timeSchedule.startDate = self.pfJob[@"startDate"];
    self.timeSchedule.endDate = self.pfJob[@"endDate"];
    [self.allocationDates addObject:self.timeSchedule];
    
    for (PFObject *tempAgency in self.selectedAgencyObjects)
    {
        tempAgency[@"allocation"] = @"";
        tempAgency[@"allocationNumber"] = [NSNumber numberWithInt:1];
        
        [self addToAllocationTimes:tempAgency];
    }
}

- (void)addToAllocationTimes:(PFObject*)tempAgency
{
    NSDate *allocationEndDate;
    NSDate *tempAgencyStartDate = tempAgency[@"availableFrom"];
    NSDate *tempAgencyEndDate = tempAgency[@"availableTo"];
    
    NSMutableArray *pocketDeletion = [NSMutableArray array];
    NSMutableArray *pocketAddition = [NSMutableArray array];
    
    // iterate through allocation pockets of dates
    for (int i = 0; i < self.allocationDates.count; i++)
    {
        self.jobAllocation = [[JobAllocation alloc] init];
        self.jobAllocation.temporaryAgency = tempAgency;
        self.jobAllocation.job = self.pfJob;
        
        self.timeSchedule = [self.allocationDates objectAtIndex:i];
        // if temp start date later than job date
        if([tempAgencyStartDate timeIntervalSinceDate:self.timeSchedule.startDate] >= 0.0)
        {
            // if temp availability is not within current pocket then move onto the next pocket
            if([tempAgencyStartDate timeIntervalSinceDate:self.timeSchedule.endDate] >= 0.0)
            {
                continue;
            }
            
            // set a slot date between original job start date and temp start date
            allocationEndDate = self.timeSchedule.endDate;
            self.timeSchedule.endDate = tempAgencyStartDate;
            
            // if current temp end date finishes later than pocket start Date, overlapping occurs
            if ([tempAgencyEndDate timeIntervalSinceDate:allocationEndDate] >= 0.0)
            {
                // create allocation here without new pocket between tempAgency startDate and timeSchedule.end date
                self.jobAllocation.startDate = tempAgencyStartDate;
                self.jobAllocation.endDate = allocationEndDate;
                [self addJobAllocationWithTemporaryAgent:tempAgency];
            }
            else
            {
                // so create allocation between tempAgencyStartDate & tempAgencyEndDate
                self.jobAllocation.startDate = tempAgencyStartDate;
                self.jobAllocation.endDate = tempAgencyEndDate;
                [self addJobAllocationWithTemporaryAgent:tempAgency];
                
                // also create new pocket and finish looping
                self.timeSchedule = [[TimeSchedule alloc] init];
                self.timeSchedule.startDate = tempAgencyEndDate;
                self.timeSchedule.endDate = allocationEndDate;
                [pocketAddition addObject:self.timeSchedule];
                break;
            }
        }
        else
        {
            // if temp Agent stops work after the pocket
            if([tempAgencyEndDate timeIntervalSinceDate:self.timeSchedule.endDate] >= 0.0)
            {
                // so create allocation between self.time start and self.time end
                self.jobAllocation.startDate = self.timeSchedule.startDate;
                self.jobAllocation.endDate = self.timeSchedule.endDate;
                [self addJobAllocationWithTemporaryAgent:tempAgency];
                
                // remove pocket
                [pocketDeletion addObject:self.timeSchedule];
            }
            else if ([tempAgencyEndDate timeIntervalSinceDate:self.timeSchedule.startDate] < 0.0)
            {
                break;
            }
            else
            {
                // if temp agent stops before pocket is finished create allocation
                // between self.time start and tempAgency end
                self.jobAllocation.startDate = self.timeSchedule.startDate;
                self.jobAllocation.endDate = tempAgencyEndDate;
                [self addJobAllocationWithTemporaryAgent:tempAgency];
                
                self.timeSchedule.startDate = tempAgencyEndDate;
                break;
            }
        }
    }
    
    if (!self.jobAllocation.startDate)
    {
        [self.selectedAgencyObjects removeObject:tempAgency];
    }
    
    for (TimeSchedule *time in pocketAddition)
    {
        [self.allocationDates addObject:time];
    }
    
    for (TimeSchedule *time in pocketDeletion)
    {
        [self.allocationDates removeObject:time];
    }
    
    [pocketDeletion removeAllObjects];
    [pocketAddition removeAllObjects];
}

- (void)addJobAllocationWithTemporaryAgent:(PFObject*)tempAgency
{
    NSString *string = @"";
    if (![tempAgency[@"allocation"] isEqualToString:@""])
    {
        string = tempAgency[@"allocation"];
    }
    
    string = [NSString stringWithFormat:@"%@\n%@", string,
              
              [NSString stringWithFormat:@"%@   -   %@",
               [self.dateFormatter stringFromDate:self.jobAllocation.startDate],
               [self.dateFormatter stringFromDate:self.jobAllocation.endDate]]];
    
    tempAgency[@"allocation"] = string;
    tempAgency[@"allocationNumber"] = [NSNumber numberWithInt:(int)[tempAgency[@"allocationNumber"] integerValue] + 1];
    [self.jobAllocationsArray addObject:self.jobAllocation];
}

- (void)returnToIncomingWork
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Init TableView
- (void)initTableView
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:AVAILABILITY_DATE_FORMAT];
    
    UIView *jobAvailabilityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180.0)];
    jobAvailabilityView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:jobAvailabilityView];
    
    self.job = [[Job alloc] init];
    
    self.temporaryAgencyTableView = [[UITableView alloc] init];
    self.temporaryAgencies = [NSArray array];
    self.selectedAgencyObjects = [NSMutableArray array];
    self.allocationDates = [NSMutableArray array];
    self.jobAllocationsArray = [NSMutableArray array];
    
    self.timeSchedule = [[TimeSchedule alloc] init];
    self.timeSchedule.startDate = self.pfJob[@"startDate"];
    self.timeSchedule.endDate = self.pfJob[@"endDate"];
    [self.allocationDates addObject:self.timeSchedule];
    
    self.jobAvailabilityLabel = [[UILabel alloc] initWithFrame:jobAvailabilityView.frame];
    self.jobAvailabilityLabel.numberOfLines = 6;
    
    self.confirmJobAllocationsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.confirmJobAllocationsBtn.frame = CGRectMake(0, 0, 200, 45);
    self.confirmJobAllocationsBtn.center = CGPointMake(jobAvailabilityView.center.x, jobAvailabilityView.frame.size.height*0.68);
    [self.confirmJobAllocationsBtn addTarget:self action:@selector(confirmJobAllocation) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmJobAllocationsBtn setTitle:@"Confirm Allocation" forState:UIControlStateNormal];
    self.confirmJobAllocationsBtn.layer.borderWidth = 1.0f;
    self.confirmJobAllocationsBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    self.confirmJobAllocationsBtn.titleLabel.font = [UIFont fontWithName:@"Avenir" size:19];
    [self.confirmJobAllocationsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmJobAllocationsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.confirmJobAllocationsBtn setBackgroundColor:ORANGE];
    
    self.jobAvailabilityLabel.center = self.jobAvailabilityLabel.center;
    self.jobAvailabilityLabel.textColor = [UIColor blackColor];
    self.jobAvailabilityLabel.font = [UIFont systemFontOfSize:20.0];
    self.jobAvailabilityLabel.textAlignment = NSTextAlignmentCenter;
    [jobAvailabilityView addSubview:self.jobAvailabilityLabel];
    [self updateJobAvailabilityLabelText];
    
    self.temporaryAgencyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, jobAvailabilityView.frame.size.height,
                                                                                  self.view.frame.size.width,
                                                                                  self.view.frame.size.height - jobAvailabilityView.frame.size.height)
                                                                 style:UITableViewStylePlain];
    self.temporaryAgencyTableView.delegate = self;
    self.temporaryAgencyTableView.dataSource = self;
    [self.view addSubview:self.temporaryAgencyTableView];
    self.temporaryAgencyTableView.backgroundColor = [UIColor clearColor];
    
    [self.job retrieveTemporaryAgencies:self.timeSchedule];
}

#pragma mark - UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *temporaryAgency = [self.temporaryAgencies objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    NSString *allocationString = @"";
    
    cell.font = [UIFont fontWithName:@"avenir" size:13];
    cell.backgroundColor = [UIColor clearColor];
    
    if ([self.selectedAgencyObjects containsObject:temporaryAgency])
    {
        allocationString = [NSString stringWithFormat:@"\nAllocated Dates:%@", temporaryAgency[@"allocation"]];
        cell.backgroundColor = ORANGE;
        cell.textLabel.numberOfLines = 3 + (int)[temporaryAgency[@"allocationNumber"] integerValue];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:14.0];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@  |  Availability: %@ - %@ | (%lu)\n%@",
                           temporaryAgency[@"firstName"], temporaryAgency[@"lastName"],
                           [self.dateFormatter stringFromDate:temporaryAgency[@"availableFrom"]],
                           [self.dateFormatter stringFromDate:temporaryAgency[@"availableTo"]],
                           [temporaryAgency[@"recommendations"] count], allocationString];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *temporaryAgency = [self.temporaryAgencies objectAtIndex:indexPath.row];
    
    if ([self.selectedAgencyObjects containsObject:temporaryAgency])
    {
        int rowHeight = 80 + (20 * (int)[temporaryAgency[@"allocationNumber"] integerValue]);
        
        return rowHeight;
    }
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.temporaryAgencies.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.allocationDates.count || [cell.backgroundColor isEqual:ORANGE])
    {
        if ([cell.backgroundColor isEqual:ORANGE])
        {
            cell.backgroundColor = [UIColor clearColor];
        }
        else
        {
            cell.backgroundColor = ORANGE;
        }
        
        [self calculateRemainingAllocationDates:(int)indexPath.row];
        [self updateJobAvailabilityLabelText];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
