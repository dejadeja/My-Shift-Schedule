//
//  TimeSheetsViewController.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 23/04/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "TimeSheetsViewController.h"
#import "TimeSheetsCell.h"

@interface TimeSheetsViewController ()

@end

@implementation TimeSheetsViewController
@synthesize tableView;

- (id)init {
    if (self) {
        [self initNav];
        self.tableView = [[UITableView alloc] init];
        self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        self.tableView.backgroundColor = DARK_GREY;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self initNav];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:self.tableView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
        self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Navigation Bar
- (void)initNav {
    [self.navigationController.navigationBar setBarTintColor:DARK_GREY];
    [self.navigationController.navigationBar setTranslucent:FALSE];
}

#pragma mark - Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeSheetsCell *cell = [[TimeSheetsCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 60)];
    cell.backgroundColor = [UIColor clearColor];

    cell.jobTitleLbl.text = @" Booking Name - Company Name"; //needs padding - temp fix
    cell.businessInfoLbl.text = @"test-business";
    cell.clientInfoLbl.text = @"test-client";
    return cell;
}
@end
