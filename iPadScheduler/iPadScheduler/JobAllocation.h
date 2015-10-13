//
//  JobAllocation.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 06/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import <Parse/Parse.h>

@interface JobAllocation : NSObject

@property (nonatomic, strong) PFObject *temporaryAgency;
@property (nonatomic, strong) PFObject *job;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

- (void)addJobAllocation;

@end
