//
//  NotificationObject.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 07/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "NotificationObject.h"
#import "User.h"

@implementation NotificationObject

- (void)postNotification
{
    PFObject *object = [PFObject objectWithClassName:@"Notification"];

    object[@"text"] = self.notificationString;
    
    object.ACL = [PFACL ACLWithUser:self.recipient[@"user"]];
    
    [object pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
       
        [object saveEventually];
    }];
}

- (void)retrieveAllNotifications
{
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser)
    {
        PFQuery *notificationsQuery = [PFQuery queryWithClassName:@"Notification"];
        
        [notificationsQuery setLimit:50];
        
        [notificationsQuery orderByDescending:@"createdAt"];
        
        [notificationsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RETRIEVE_NOTIFICATIONS object:objects];
        }];
    }
}

@end
