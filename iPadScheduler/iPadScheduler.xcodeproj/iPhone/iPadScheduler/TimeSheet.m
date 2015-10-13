//
//  TimeSheet.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 09/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "TimeSheet.h"
#import "NotificationObject.h"

@implementation TimeSheet

- (void)updateTimeSheet:(NSDate*)date :(PFObject*)job
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-mm-yyyy"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"TemporaryAgency"];
    
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!error)
        {
            PFObject *timeSheetObject = [PFObject objectWithClassName:@"TimeSheet"];
            timeSheetObject[@"hours"] = [NSNumber numberWithInt:self.hours];
            timeSheetObject[@"minutes"] = [NSNumber numberWithInt:self.minutes];
            timeSheetObject[@"timeSheetDate"] = [df dateFromString:[df stringFromDate:date]];
            timeSheetObject[@"temporaryAgency"] = object;
            timeSheetObject[@"job"] = job;
            timeSheetObject.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            NotificationObject *notification;
            
            // notification to temporary agency
            notification = [[NotificationObject alloc] init];
            notification.recipient = object;
            notification.notificationString = [NSString stringWithFormat:@"You have successfully logged %i hrs and %i mins\nfor job: %@",
                                               self.hours, self.minutes, job[@"jobTitle"]];
            [notification postNotification];
            
            // notification to business
            notification = [[NotificationObject alloc] init];
            notification.recipient = job[@"business"];
            notification.notificationString = [NSString stringWithFormat:@"%@ %@ has successfully logged \n%i hrs and %i mins for job: %@",
                                               object[@"firstName"], object[@"lastName"],
                                               self.hours, self.minutes, job[@"jobTitle"]];
            [notification postNotification];
            
            [timeSheetObject pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_TIMESHEET object:nil];
            }];
            
            [timeSheetObject saveEventually];
        }
    }];
}

- (void) syncDatabase
{
    PFQuery *query = [PFQuery queryWithClassName:@"TimeSheet"];
    
    [query includeKey:@"job"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error)
        {
            [PFObject pinAllInBackground:objects block:^(BOOL succeeded, NSError *error){
               
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_TIMESHEET object:nil];
            }];
        }
    }];
}

@end
