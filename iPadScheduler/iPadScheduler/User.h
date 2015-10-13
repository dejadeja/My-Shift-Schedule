//
//  User.h
//  iPadScheduler
//
//  Created by Deja Cespedes on 26/04/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import <Parse/Parse.h>

#define BUSINESS_USER @"Business"
#define AGENCY_USER @"Agency"
#define TEMPORARY_AGENCY_USER @"Temporary Agency"

#define NOTIFICATION_SIGN_UP_USER @"sign_up_user_notification"
#define NOTIFICATION_SIGN_IN_USER @"sign_in_user_notification"
#define NOTIFICATION_USER_AVAILABILITY @"user_Availablility"
#define NOTIFICATION_RETRIEVE_TEMP_AGENCIES_FOR_BUSINESS @"notifcation_retrieve_temp_agencies"

@interface User : NSObject

@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) PFObject *userTypeObject;
@property (nonatomic, strong) NSString *address;

//BUSINESS
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *sector;
@property (nonatomic, strong) NSString *managerName;

//AGENCY / TEMPORARY AGENCY
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

//USER DETAILS
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *telephoneNumber;

//AVAILABILITY (FOR TEMP AGENCY)
@property (nonatomic, strong) NSDate *availableFrom;
@property (nonatomic, strong) NSDate *availableTo;

- (BOOL)isUserValid;
- (void)signUp;
- (void)signIn;
- (void)retrieveAvailability;
- (void)updateAvailability:(PFObject*)object;
- (void)getTempAgenciesForBusiness;

@end
