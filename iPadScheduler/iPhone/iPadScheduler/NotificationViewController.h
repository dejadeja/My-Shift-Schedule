//
//  NotificationViewController.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 07/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "BaseViewController.h"

@interface NotificationViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *notificationArray;
@property (nonatomic, strong) NotificationObject *notificationObject;
@property (nonatomic, strong) UITableView *notificationTableView;

@end
