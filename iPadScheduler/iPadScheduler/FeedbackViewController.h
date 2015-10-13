//
//  FeedbackViewController.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 09/05/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedbackViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *feedbackTableView;
@property (nonatomic, strong) NSArray *tempAgencyArray;

@end
