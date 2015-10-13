//
//  NotificationObject.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 07/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import <Parse/Parse.h>

@interface NotificationObject : NSObject

#define NOTIFICATION_RETRIEVE_NOTIFICATIONS @"notification_retrieve_notifications"

@property (nonatomic, strong) NSString *notificationString;
@property (nonatomic, strong) PFObject *recipient;

- (void)postNotification;
- (void)retrieveAllNotifications;

@end
