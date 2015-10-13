//
//  Job.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 03/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "Job.h"
#import "User.h"

@implementation Job

- (void)retrieveIncomingJobs
{
    [self syncDatabase];
}

- (void)setJobForCompletion:(PFObject *)object
{
    object[@"isSetForCompletion"] = [NSNumber numberWithBool:YES];
    [object saveEventually];
}

- (void)searchIncomingJobs
{
    PFQuery *query = [PFQuery queryWithClassName:@"Job"];
    
    [query includeKey:@"business"];
    
    [query whereKey:@"isSetForCompletion" equalTo:[NSNumber numberWithBool:false]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RETRIEVE_INCOMING_JOBS object:objects];
        }
    }];
}

- (void)retrieveJobSetForCompletion:(NSDate*)date
{
    PFUser *user = [PFUser currentUser];
    
    //date = [date dateByAddingTimeInterval:24*60*60];

    if ([user[@"userType"] isEqualToString:TEMPORARY_AGENCY_USER])
    {
        PFQuery *query = [PFQuery queryWithClassName:@"TemporaryAgency"];
        
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            if (!error)
            {
                PFQuery *allocationQuery = [PFQuery queryWithClassName:@"JobAllocation"];
                
                [allocationQuery includeKey:@"job"];
                
                [allocationQuery whereKey:@"temporaryAgency" equalTo:object];
                
                [allocationQuery whereKey:@"startDate" lessThanOrEqualTo:date];
                
                [allocationQuery whereKey:@"endDate" greaterThanOrEqualTo:date];
                
                [allocationQuery findObjectsInBackgroundWithBlock:^(NSArray *allocationObjects, NSError *error) {
                    
                    if (!error)
                    {
                        NSMutableArray *array = [NSMutableArray array];
                        
                        for (PFObject *pfObject in allocationObjects)
                        {
                            [array addObject:pfObject[@"job"]];
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RETRIEVE_JOBS_SET_FOR_COMPLETION object:array];
                    }
                }];
            }
        }];
    }
}

- (void)syncDatabase
{
    PFQuery *query = [PFQuery queryWithClassName:@"Job"];
    
    [query includeKey:@"business"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error)
        {
            [PFObject pinAllInBackground:objects block:^(BOOL succeeded, NSError *error) {
                
                [self searchIncomingJobs];
            }];
            
        } else {
            
            [self searchIncomingJobs];
        }
    }];
}

- (BOOL)isJobValid
{
    return true;
}

- (void)requestJob
{
    PFObject *jobObject = [PFObject objectWithClassName:@"Job"];
    
    jobObject[@"jobTitle"] = self.jobTitle;
    jobObject[@"company"] = self.company;
    jobObject[@"reportingTo"] = self.reportingTo;
    jobObject[@"startDate"] = self.startDate;
    jobObject[@"endDate"] = self.endDate;
    jobObject[@"address"] = self.address;
    jobObject[@"telephone"] = self.telephone;
    jobObject[@"uniform"] = self.uniform;
    jobObject[@"additional"] = self.additional;
    jobObject[@"isSetForCompletion"] = [NSNumber numberWithBool:false];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Business"];
    
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!error)
        {
            jobObject[@"business"] = object;
            [jobObject pinInBackground];
            [jobObject saveEventually];
        }
    }];
}

@end
