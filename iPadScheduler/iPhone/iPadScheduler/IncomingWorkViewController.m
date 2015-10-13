//
//  IncomingWorkViewController.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 22/04/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "IncomingWorkViewController.h"
#import "NIDropDown.h"
#import "SplashScreenController.h"
#import "SearchViewController.h"
#import "SetAvailabilityViewController.h"
#import "NotificationViewController.h"

extern BOOL changedMonth; //checks to see if the month is changed in the CKCalendarView, currently not working

@interface IncomingWorkViewController ()
@end

@implementation IncomingWorkViewController
@synthesize selectedDate;
@synthesize calendarTableView;
@synthesize navigationBar;
@synthesize listTableView;
@synthesize calendarIsOpen;
@synthesize dropdownbtn;
@synthesize logoutbtn;
@synthesize openedDetail;
@synthesize clCalendarView;

- (id)init {
    if (self) {
        
        self.allocatedJobsArray = [NSMutableArray array];
        self.circleViewColourArray = [NSMutableArray array];
        self.job = [[Job alloc] init];
        
        self.calendarTableView = [[UITableView alloc] init];
        self.calendarTableView.dataSource = self;
        self.calendarTableView.delegate = self;
        self.calendarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.listTableView = [[UITableView alloc] init];
        self.listTableView.dataSource = self;
        self.listTableView.delegate = self;
        
        self.selectedDate = [[NSDate alloc] init];
        self.timeSheet = [[TimeSheet alloc] init];
        [self.job retrieveIncomingJobs];
        [self.timeSheet syncDatabase];
        [self initExtraMenu];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadIncomingJobs)
                                                     name:NOTIFICATION_RELOAD_TABLEVIEW object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveJobSetForCompletion:)
                                                     name:NOTIFICATION_RETRIEVE_JOBS_SET_FOR_COMPLETION object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTimeSheet)
                                                     name:NOTIFICATION_RELOAD_TIMESHEET object:nil];
        
        self.clCalendarView = [[CLWeeklyCalendarView alloc] init];
    }
    return self;
}

- (void)reloadTimeSheet
{
    [self.calendarTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    openedDetail = false;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!selectedDate)
    {
        selectedDate = [NSDate date];
    }
    
    [self.job retrieveJobSetForCompletion:self.selectedDate];
}

- (void)reloadIncomingJobs
{
    [self.job retrieveIncomingJobs];
}

- (void)retrieveJobSetForCompletion:(NSNotification*)notification
{
    [self.allocatedJobsArray removeAllObjects];
    [self.allocatedJobsArray addObjectsFromArray:[notification object]];
    [self.calendarTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = DARK_GREY;
    
    [self.listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self initNavBar];
    [self openCalendarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI INITS

- (void)initNavBar {
    [self.navigationController.navigationBar setBarTintColor:DARK_GREY];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    dropdownbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 30)];
    dropdownbtn.center = CGPointMake(self.view.center.x, self.navigationController.navigationBar.center.y);
    [dropdownbtn addTarget:self action:@selector(menuSelected) forControlEvents:UIControlEventTouchUpInside];
    [dropdownbtn setTitle:@"All Jobs" forState:UIControlStateNormal];
    dropdownbtn.layer.borderWidth=1.0f;
    dropdownbtn.layer.cornerRadius = 5.0f;
    dropdownbtn.layer.borderColor=[[UIColor clearColor] CGColor];
    dropdownbtn.titleLabel.font = [UIFont fontWithName:@"Avenir-Bold" size:18];
    [dropdownbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dropdownbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [dropdownbtn setBackgroundColor:LIGHT_ORANGE];
    [self.navigationController.navigationBar addSubview:dropdownbtn];
    
    logoutbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logoutbtn.frame = CGRectMake(0, 0, 60, 40);
    logoutbtn.center = CGPointMake(self.view.frame.size.width * 0.9, self.navigationController.navigationBar.center.y);
    [logoutbtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [logoutbtn setTitle:@"Log out" forState:UIControlStateNormal];
    logoutbtn.layer.borderWidth = 1.0f;
    logoutbtn.layer.cornerRadius = 10.0f;
    logoutbtn.layer.borderColor = [[UIColor clearColor] CGColor];
    logoutbtn.titleLabel.font = [UIFont fontWithName:@"Avenir" size:15];
    [logoutbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutbtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.navigationController.navigationBar addSubview:logoutbtn];
}

- (void)logout
{
    [PFObject unpinAllObjectsInBackground];
    [PFUser logOut];
    [self presentViewController:[[SplashScreenController alloc] init] animated:YES completion:nil];
}


-(CLWeeklyCalendarView *)calendarView
{
    if(clCalendarView){
        clCalendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 125)];
        clCalendarView.delegate = self;
    }
    return clCalendarView;
}

#pragma mark - CLWeeklyCalendarViewDelegate
-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @2,
             };
}



-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    [self reDraw];
    selectedDate = date;
    [self.job retrieveJobSetForCompletion:date];
}

- (void)initExtraMenu
{
    PFUser *user = [PFUser currentUser];
    REMenuItem *allJobsItem = [[REMenuItem alloc] initWithTitle:@"All Jobs"
                                                       subtitle:@""
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self.navigationController popToRootViewControllerAnimated:NO];
                                                             [dropdownbtn setTitle:@"All Jobs" forState:UIControlStateNormal];
                                                             if (!calendarIsOpen)
                                                                 [self openCalendarView];
                                                         }];
    
    REMenuItem *notificationItem = [[REMenuItem alloc] initWithTitle:@"Notifications"
                                                            subtitle:@""
                                                               image:nil
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                  [self.navigationController popToRootViewControllerAnimated:NO];
                                                                  [dropdownbtn setTitle:@"Notifications" forState:UIControlStateNormal];
                                                                  [self.navigationController pushViewController:
                                                                   [[NotificationViewController alloc] init] animated:NO];
                                                              }];
    
    REMenuItem *availabilityItem = [[REMenuItem alloc] initWithTitle:@"Set Availability"
                                                            subtitle:@""
                                                               image:nil
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                  [self.navigationController popToRootViewControllerAnimated:NO];
                                                                  [dropdownbtn setTitle:@"Set Availability" forState:UIControlStateNormal];
                                                                  [self.navigationController pushViewController:
                                                                   [[SetAvailabilityViewController alloc] init] animated:NO];
                                                              }];
    
    
    if ([user[@"userType"] isEqualToString:TEMPORARY_AGENCY_USER])
    {
        self.menu = [[REMenu alloc] initWithItems:@[allJobsItem, availabilityItem ,notificationItem]];
    }
    
    self.menu.font = [UIFont fontWithName:@"Avenir" size:20.0f];
    self.menu.textColor = [UIColor whiteColor];
    self.menu.appearsBehindNavigationBar = NO;
    self.menu.bounce = NO;
}

- (void)menuSelected
{
    if (self.menu.isOpen)
    {
        [self.menu close];
    }
    else
    {
        [self.menu showFromNavigationController:self.navigationController];
    }
}

#pragma mark - Open Calendar View/TableView
- (void) openCalendarView {
    
    calendarIsOpen = !calendarIsOpen;
    [self.navigationController popViewControllerAnimated:YES];
    if (calendarIsOpen)
    {
        [self calendarView];
        
        [self.listTableView removeFromSuperview];
        
        [self.view addSubview:self.clCalendarView];
        [self.view addSubview:self.calendarTableView];
        [self.calendarTableView reloadData];
    }
}

#pragma mark - Split View Delegate Methods
- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    [barButtonItem setTitle:@"TEST"];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - Re Draw Calendar Table
- (void)reDraw {
    [self configureTableView:self.selectedDate];
    self.calendarTableView.frame = CGRectMake(0, self.clCalendarView.bounds.size.height, self.clCalendarView.bounds.size.width,
                                              self.view.frame.size.height - self.clCalendarView.bounds.size.height);
    [self.calendarTableView reloadData];
}

- (void)configureTableView: (NSDate *)date{
    self.calendarTableView.frame = CGRectMake(0, self.clCalendarView.bounds.size.height-10, self.clCalendarView.bounds.size.width, 500);
    self.calendarTableView.backgroundColor = [UIColor clearColor];
    
    [self.calendarTableView reloadData];
    [self.view addSubview:self.calendarTableView];
}

#pragma mark - Table View Delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int numberOfRows = (int)self.allocatedJobsArray.count;
    
    return numberOfRows;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    PFObject *job;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-mm-yyyy"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:AVAILABILITY_DATE_FORMAT];
    
    if (calendarIsOpen)
    {
        job = [self.allocatedJobsArray objectAtIndex:indexPath.row];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        cell.backgroundColor = [UIColor clearColor];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor whiteColor];
        [self circleView:indexPath tableCell:cell];
        
        if ([[[PFUser currentUser] objectForKey:@"userType"] isEqualToString:TEMPORARY_AGENCY_USER])
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(0, 0, 120, 45);
            btn.center = CGPointMake(self.view.frame.size.width * 0.9, 40);
            [btn setTag:indexPath.row];
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.borderWidth = 1.0f;
            btn.layer.cornerRadius = 10.0f;
            btn.layer.borderColor = [[UIColor clearColor] CGColor];
            btn.titleLabel.font = [UIFont fontWithName:@"Avenir" size:15];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [btn setBackgroundColor:ORANGE];
            [cell addSubview:btn];
            
            PFQuery *query = [PFQuery queryWithClassName:@"TimeSheet"];
            
            [[query fromLocalDatastore] ignoreACLs];
            
            [query includeKey:@"job"];
            
            [query whereKey:@"job" equalTo:job];
            
            [query whereKey:@"timeSheetDate" equalTo:[df dateFromString:[df stringFromDate:selectedDate]]];
            
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                
                if (!error)
                {
                    [btn setTitle:@"Added!" forState:UIControlStateNormal];
                }
                else
                {
                    [btn setTitle:@"Add Hours" forState:UIControlStateNormal];
                }
            }];
        }
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:12];
    cell.textLabel.text = [NSString stringWithFormat:@"        %@, %@, %@, %@   |   %@\n        %@ -> %@",
                           job[@"jobTitle"], job[@"company"], job[@"telephone"], job[@"uniform"],
                           job[@"business"][@"companyName"], [dateFormatter stringFromDate:job[@"startDate"]],
                           [dateFormatter stringFromDate:job[@"endDate"]]];
    
    cell.textLabel.numberOfLines = 2;
    
    return cell;
}

-(void)updateTimeSheet:(id)sender
{
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:
                                    self.datePicker.date];
    
    self.timeSheet.hours = (int)[components hour];
    self.timeSheet.minutes = (int)[components minute];
    [self.timeSheet updateTimeSheet:self.selectedDate :[self.allocatedJobsArray objectAtIndex:(int)[sender tag]]];
}

- (void)buttonAction:(UIButton *)sender
{
    self.timeSheet = [[TimeSheet alloc] init];
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView *popoverView = [[UIView alloc] init];
    
    self.datePicker = [[UIDatePicker alloc]init];
    self.datePicker.frame = CGRectMake(0,0,self.view.frame.size.width, 220);
    self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    self.datePicker.tag = sender.tag;
    [self.datePicker addTarget:self action:@selector(updateTimeSheet:) forControlEvents:UIControlEventValueChanged];
    [popoverView addSubview:self.datePicker];
    
    popoverContent.view = popoverView;
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [popoverController setPopoverContentSize:CGSizeMake(self.view.frame.size.width, 200) animated:NO];
    [popoverController presentPopoverFromRect:CGRectMake(0, 0, 240, 40) inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark - CircleView for Table Cells
-(UITableViewCell *) circleView: (NSIndexPath*)indexPath tableCell:(UITableViewCell *)cell {
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,16,16)];
    circleView.layer.cornerRadius = circleView.bounds.size.width / 2.0;
    circleView.center = CGPointMake(25, 40);
    
    if (indexPath.row >= self.circleViewColourArray.count)
    {
        UIColor *colour;
        
        colour = [UIColor colorWithRed:0.93 green:0.56 blue:0.56 alpha:1.0];
        [self.circleViewColourArray addObject:colour];
        
        colour = [UIColor colorWithRed:0.64 green:0.93 blue:0.56 alpha:1.0];
        [self.circleViewColourArray addObject:colour];
        
        colour = [UIColor colorWithRed:0.58 green:0.60 blue:0.92 alpha:1.0];
        [self.circleViewColourArray addObject:colour];
        
        colour = [UIColor colorWithRed:0.95 green:0.93 blue:0.49 alpha:1.0];
        [self.circleViewColourArray addObject:colour];
    }
    
    circleView.backgroundColor = [self.circleViewColourArray objectAtIndex:(int)indexPath.row % self.circleViewColourArray.count];
    [cell addSubview:circleView];
    
    return cell;
}
@end
