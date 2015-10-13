//
//  BaseViewController.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 22/04/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Job.h"
#import "User.h"
#import "JobAllocation.h"
#import "TimeSheet.h"
#import "NotificationObject.h"

#define AVAILABILITY_DATE_FORMAT @"dd MMMM yyyy HH:mm"

#define LIGHT_ORANGE [UIColor colorWithRed:245/255.0f green:173/255.0f blue:20/255.0f alpha:1]
#define BEIGE [UIColor colorWithRed:225/255.0f green:225/255.0f blue:223/255.0f alpha:1]
#define MEDIUM_GREY [UIColor colorWithRed:129/255.0f green:138/255.0f blue:137/255.0f alpha:1.0f]
#define ORANGE [UIColor colorWithRed:225/255.0f green:153/255.0f blue:0/255.0f alpha:1]
#define LIGHT_GREY [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1]
#define DARK_GREY [UIColor colorWithRed:45/255.0f green:48/255.0f blue:48/255.0f alpha:1]



@interface BaseViewController : UIViewController <UISplitViewControllerDelegate, UITextFieldDelegate>

@property BOOL changedMonth;
@property BOOL openedDetail;

- (UITextField *)styleTextField: (UITextField *)textField placeHolderText: (NSString *)placeHolderText;
- (UITextField *)setBorder: (UITextField*)textField;
@end
