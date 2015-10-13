//
//  TimeSheetsViewController.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 23/04/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TimeSheetsViewController :BaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end
