//
//  FeedbackViewController.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 09/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController


#pragma mark - Loads
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DARK_GREY;
    self.navigationItem.hidesBackButton = YES;
    self.tempAgencyArray = [NSArray array];
    User *user = [[User alloc] init];
    [user getTempAgenciesForBusiness];
    [self initTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTempsToTableView:)
                                                 name:NOTIFICATION_RETRIEVE_TEMP_AGENCIES_FOR_BUSINESS object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Init Table View

- (void)initTableView
{
    self.feedbackTableView = [[UITableView alloc] init];
    self.feedbackTableView.backgroundColor = DARK_GREY;
    self.feedbackTableView.frame = CGRectMake
    (0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 40);
    self.feedbackTableView.delegate = self;
    self.feedbackTableView.dataSource = self;
    [self.view addSubview:self.feedbackTableView];
    self.feedbackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - Handle Temps
- (void)addTempsToTableView:(NSNotification*)notification
{
    self.tempAgencyArray = [NSArray arrayWithArray:[notification object]];
    [self.feedbackTableView reloadData];
}

- (void)recommendTemp:(UIButton*)sender
{
    PFObject *temp = [self.tempAgencyArray objectAtIndex:(int)[sender tag]];
    
    NSMutableArray *array;
    
    if (!temp[@"recommendations"])
    {
        array = [NSMutableArray array];
    }
    else
    {
        array = temp[@"recommendations"];
    }
    
    if (![array containsObject:[PFUser currentUser].objectId])
    {
        [array addObject:[PFUser currentUser].objectId];
    }
    
    temp[@"recommendations"] = array;
    
    [temp saveEventually];
    [self.feedbackTableView reloadData];
}


#pragma mark - Table View Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tempAgencyArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    PFObject *temp;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:AVAILABILITY_DATE_FORMAT];
    
    temp = [self.tempAgencyArray objectAtIndex:indexPath.row];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NULL];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Bold" size:18];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = ORANGE;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", temp[@"firstName"], temp[@"lastName"]];
    
    if (![temp[@"recommendations"] containsObject:[PFUser currentUser].objectId])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0, 0, 140, 45);
        btn.center = CGPointMake(self.view.frame.size.width * 0.88, 40);
        [btn setTag:indexPath.row];
        [btn addTarget:self action:@selector(recommendTemp:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderWidth = 1.0f;
        btn.layer.cornerRadius = 10.0f;
        btn.layer.borderColor = [[UIColor clearColor] CGColor];
        btn.titleLabel.font = [UIFont fontWithName:@"Avenir" size:19];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:ORANGE];
        [cell addSubview:btn];
        [btn setTitle:@"Recommend" forState:UIControlStateNormal];
    }
    
    return cell;
}
@end
