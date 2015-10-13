//
//  User.m
//  iPadScheduler
//
//  Created by Deja Cespedes on 26/04/2015.
//  Copyright (c) 2015 Dejà. All rights reserved.
//

#import "User.h"

@implementation User

- (void)getTempAgenciesForBusiness
{
    PFQuery *query = [PFQuery queryWithClassName:@"Business"];
    
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!error)
        {
            PFQuery *job = [PFQuery queryWithClassName:@"Job"];
            
            [job includeKey:@"business"];
            
            [job whereKey:@"business" equalTo:object];
            
            [job selectKeys:@[@"job"]];
            
            [job findObjectsInBackgroundWithBlock:^(NSArray *jobObjects, NSError *error) {
                
                PFQuery *jobAllocationQuery = [PFQuery queryWithClassName:@"JobAllocation"];
                
                [jobAllocationQuery includeKey:@"temporaryAgency"];
                
                [jobAllocationQuery whereKey:@"job" containedIn:jobObjects];
                
                [jobAllocationQuery selectKeys:@[@"temporaryAgency"]];
                
                [jobAllocationQuery findObjectsInBackgroundWithBlock:^(NSArray *jobAllocObjects, NSError *error) {
                    
                    if (!error)
                    {
                        NSMutableArray *array = [NSMutableArray array];
                        
                        for (PFObject *obj in jobAllocObjects)
                        {
                            if (![array containsObject:obj[@"temporaryAgency"]])
                            {
                                NSArray *recArray = obj[@"temporaryAgency"][@"recommendations"];
                                
                                if (![recArray containsObject:[PFUser currentUser].objectId])
                                {
                                    [array addObject:obj[@"temporaryAgency"]];
                                }
                            }
                        }
                        
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:NOTIFICATION_RETRIEVE_TEMP_AGENCIES_FOR_BUSINESS object:array];
                    }
                }];
            }];
        }
    }];
}

- (void)updateAvailability:(PFObject *)object
{
    [object pinInBackground];
    [object saveEventually];
}

- (void)retrieveAvailability
{
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser)
    {
        PFUser *user = [PFUser currentUser];
        PFQuery *query;
        
        if ([user[@"userType"] isEqualToString:BUSINESS_USER])
        {
            query = [PFQuery queryWithClassName:@"Business"];
        }
        else if ([user[@"userType"] isEqualToString:AGENCY_USER])
        {
            query = [PFQuery queryWithClassName:@"Agency"];
        }
        else if ([user[@"userType"] isEqualToString:TEMPORARY_AGENCY_USER])
        {
            query = [PFQuery queryWithClassName:@"TemporaryAgency"];
        }
        
        //[[query fromLocalDatastore] ignoreACLs];
        
        [query includeKey:@"user"];
        
        [query whereKey:@"user" equalTo:currentUser];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            if (!error)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_AVAILABILITY object:object];
            }
        }];
    }
}

- (BOOL)isUserValid
{
    if (!self.username)
    {
        return NO;
    }
    
    return YES;
}

- (void)signIn
{
    PFUser *pfUser = [PFUser user];
    
    pfUser.username = self.username;
    pfUser.password = self.password;
    pfUser.email = self.email;
    
    [PFUser logInWithUsernameInBackground:pfUser.username password:pfUser.password block:^(PFUser *userObject, NSError *error) {
        
        if (!error)
        {
            [self retrieveUserTypeObject];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SIGN_IN_USER object:nil];
        }
        else
        {
            [self displayErrorMessage:[error userInfo][@"error"]];
        }
    }];
}

- (void)retrieveUserTypeObject
{
    PFUser *user = [PFUser currentUser];
    PFQuery *query;
    
    if ([user[@"userType"] isEqualToString:BUSINESS_USER])
    {
        query = [PFQuery queryWithClassName:@"Business"];
    }
    else if ([user[@"userType"] isEqualToString:AGENCY_USER])
    {
        query = [PFQuery queryWithClassName:@"Agency"];
    }
    else if ([user[@"userType"] isEqualToString:TEMPORARY_AGENCY_USER])
    {
        query = [PFQuery queryWithClassName:@"TemporaryAgency"];
    }
    
    [query includeKey:@"user"];
    
    [query whereKey:@"user" equalTo:user];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        if (!error)
        {
            [object pinInBackground];
        }
    }];
}

- (void)signUp
{
    PFUser *pfUser = [PFUser user];
    
    pfUser.username = self.username;
    pfUser.password = self.password;
    pfUser.email = self.email;
    pfUser[@"userType"] = self.userType;
    pfUser[@"telephoneNumber"] = self.telephoneNumber;
    
    [pfUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error)
        {
            [self createUserTypeObject];
            
            PFACL *typeACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [typeACL setPublicReadAccess:YES];
            pfUser.ACL = typeACL;
            
            [pfUser saveEventually];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SIGN_UP_USER object:nil];
        }
        else
        {
            [self displayErrorMessage:[error userInfo][@"error"]];
        }
    }];
}

- (void)createUserTypeObject
{
    PFObject *pfObject;
    PFACL *typeACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    if ([self.userType isEqualToString:BUSINESS_USER])
    {
        pfObject = [PFObject objectWithClassName:@"Business"];
        
        pfObject[@"address"] = self.address;
        pfObject[@"companyName"] = self.companyName;
        pfObject[@"sector"] = self.sector;
        pfObject[@"managerName"] = self.managerName;
    }
    else
    {
        if ([self.userType isEqualToString:TEMPORARY_AGENCY_USER])
        {
            pfObject = [PFObject objectWithClassName:@"TemporaryAgency"];
            pfObject[@"availableFrom"] = [NSDate date];
            pfObject[@"availableTo"] = [NSDate date];
            [typeACL setPublicWriteAccess:YES];
        }
        else if ([self.userType isEqualToString:AGENCY_USER])
        {
            pfObject = [PFObject objectWithClassName:@"Agency"];
        }
        pfObject[@"firstName"] = self.firstName;
        pfObject[@"lastName"] = self.lastName;
        pfObject[@"address"] = self.address;
    }
    pfObject[@"user"] = [PFUser currentUser];
    
    [typeACL setPublicReadAccess:YES];
    pfObject.ACL = typeACL;
    
    [pfObject pinInBackground];
    [pfObject saveEventually];
}

- (void)displayErrorMessage:(NSString*)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could Not Sign User In" message:error delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
