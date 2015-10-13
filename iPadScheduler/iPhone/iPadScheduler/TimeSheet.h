//
//  TimeSheet.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 09/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import <Parse/Parse.h>

@interface TimeSheet : NSObject

#define NOTIFICATION_RELOAD_TIMESHEET @"notification_reload_timesheet"

@property int hours;
@property int minutes;

- (void)updateTimeSheet:(NSDate*)date :(PFObject*)job;
- (void)syncDatabase;

@end
