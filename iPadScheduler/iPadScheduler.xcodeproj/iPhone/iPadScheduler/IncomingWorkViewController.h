//
//  IncomingWorkViewController.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 22/04/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "BaseViewController.h"
#import "CLWeeklyCalendarView.h"
#include "REMenu.h"

@interface IncomingWorkViewController : BaseViewController <UISplitViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, CLWeeklyCalendarViewDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) Job *job;
@property (nonatomic, strong) TimeSheet *timeSheet;
@property (nonatomic, strong) REMenu *menu;

@property (nonatomic, strong) NSMutableArray *allocatedJobsArray;
@property (nonatomic, strong) NSMutableArray *circleViewColourArray;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITableView *calendarTableView;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UIButton *dropdownbtn;
@property (nonatomic, strong) UIButton *logoutbtn;
@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic) BOOL calendarIsOpen;


@property (nonatomic, strong) CLWeeklyCalendarView *clCalendarView;
@end
