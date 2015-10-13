//
//  Job.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 03/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import <Parse/Parse.h>
#import "TimeSchedule.h"

#define NOTIFICATION_RETRIEVE_INCOMING_JOBS @"retrieve_incoming_jobs_notifcation"
#define NOTIFICATION_RETRIEVE_TEMPORARY_AGENCIES @"retrieve_temporary_agencies"
#define NOTIFICATION_RELOAD_TABLEVIEW @"notification_reload_table_view"
#define NOTIFICATION_RETRIEVE_JOBS_SET_FOR_COMPLETION @"notification_retrieve_jobs_set_For_Completion"

@interface Job : NSObject

@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *reportingTo;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *uniform;
@property (nonatomic, strong) NSString *additional;

- (BOOL)isJobValid;
- (void)requestJob;
- (void)retrieveIncomingJobs;
- (void)retrieveJobSetForCompletion:(NSDate*)date;
- (void)retrieveTemporaryAgencies:(TimeSchedule*)timeSchedule;
- (void)setJobForCompletion:(PFObject*)object;

@end
