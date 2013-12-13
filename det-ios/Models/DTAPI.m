//
//  DTAPI.m
//  det
//
//  Created by Justin Huang on 10/21/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTAPI.h"
#import "DTUser.h"
#import "DTDebt.h"
#import <Parse/Parse.h>

@implementation DTAPI


+ (void)debtList:(void (^)(NSArray* debts))block {
    NSMutableArray* debtList = [NSMutableArray new];
    
    PFQuery *asDebtorQuery = [PFQuery queryWithClassName:@"Debt"];
    [asDebtorQuery whereKey:@"debtor" equalTo:[DTUser getCurrentUser].user];
    PFQuery *asCreditorQuery = [PFQuery queryWithClassName:@"Debt"];
    [asCreditorQuery whereKey:@"creditor" equalTo:[DTUser getCurrentUser].user];
    PFQuery *debtQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:asDebtorQuery, asCreditorQuery, nil]];
    
    [debtQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            for (PFObject *pfDebt in objects) {
                DTDebt* debt = [[DTDebt alloc] initWithPFObject:pfDebt];
                [debtList addObject:debt];
            }
            block(debtList);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

+ (void)linkUser:(PFUser*)newFBUser {
    
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                       id<FBGraphUser> user,
                                       NSError *error) {
         if (!error) {
             PFQuery *query = [PFUser query];
             [query whereKey:@"fbID" equalTo:user.id];
             PFUser *pf_user = (PFUser*)[query getFirstObject];
             if (pf_user && ![PFFacebookUtils isLinkedWithUser:pf_user]) {
                 [newFBUser deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                     FBAccessTokenData *token = [[FBSession activeSession] accessTokenData];
                     [PFUser logInWithUsernameInBackground:pf_user.username password:@"password" block:^(PFUser *newUser, NSError *error) {
                         [PFFacebookUtils linkUser:newUser facebookId:[user objectForKey:@"id"] accessToken:[token accessToken] expirationDate:[token expirationDate] block:^(BOOL succeeded, NSError *error) {
                             [DTAPI linkUser:[PFUser currentUser]];
                         }];
                     }];
                 }];
             } else {
                 [newFBUser setObject:user.id forKey:@"username"];
                 [newFBUser setObject:[user objectForKey:@"email"] forKey:@"email"];
                 [newFBUser setObject:user.name forKey:@"name"];
                 [newFBUser setObject:user.id forKey:@"fbID"];
                 [newFBUser save];
             }
         } else {
             NSLog(@"error: %@", [error userInfo]);
         }
     }];
}
/*
- (void)friendsList:(void (^)(NSArray* friends))block {
    FBRequest *req = [[FBRequest alloc] initWithSession:[FBSession activeSession] graphPath:@"me/friends"];
    [req startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        //NSLog(@"getFriends error %@", [error userInfo]);
        NSDictionary * rawObject = result;
        NSArray * dataArray = [rawObject objectForKey:@"data"];
        block(dataArray);
    }];
} */
@end
