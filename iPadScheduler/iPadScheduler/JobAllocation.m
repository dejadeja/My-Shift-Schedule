//
//  JobAllocation.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 06/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "JobAllocation.h"

@implementation JobAllocation

- (void)addJobAllocation
{
    PFObject *jobAllocationObject = [PFObject objectWithClassName:@"JobAllocation"];
    jobAllocationObject[@"temporaryAgency"] = self.temporaryAgency;
    jobAllocationObject[@"job"] = self.job;
    jobAllocationObject[@"startDate"] = self.startDate;
    jobAllocationObject[@"endDate"] = self.endDate;
    
    [jobAllocationObject pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [jobAllocationObject saveEventually];
    }];
}

@end
