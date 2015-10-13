//
//  NotificationViewController.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 07/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DARK_GREY;
    self.navigationItem.hidesBackButton = YES;
    self.notificationArray = [NSArray array];
    self.notificationObject = [[NotificationObject alloc] init];
    [self.notificationObject retrieveAllNotifications];
    [self initTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotificationsToTableView:)
                                                 name:NOTIFICATION_RETRIEVE_NOTIFICATIONS object:nil];
}

- (void)initTableView
{
    self.notificationTableView = [[UITableView alloc] init];
    self.notificationTableView.backgroundColor = DARK_GREY;
    self.notificationTableView.frame = CGRectMake
    (0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 40);
    self.notificationTableView.delegate = self;
    self.notificationTableView.dataSource = self;
    [self.view addSubview:self.notificationTableView];
    self.notificationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)addNotificationsToTableView:(NSNotification*)notification
{
    self.notificationArray = [NSArray arrayWithArray:[notification object]];
    [self.notificationTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notificationArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    PFObject *notification;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:AVAILABILITY_DATE_FORMAT];
    
    notification = [self.notificationArray objectAtIndex:indexPath.row];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NULL];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Bold" size:18];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = LIGHT_GREY;
    cell.textLabel.numberOfLines = 2;
    cell.detailTextLabel.text = [dateFormatter stringFromDate:notification.createdAt];
    cell.textLabel.text = notification[@"text"];
    
    return cell;
}

@end
