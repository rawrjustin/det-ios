//
//  UserInfo.m
//  det
//
//  Created by Justin Huang on 3/18/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "UserInfo.h"
#import "DTUser.h"
#import "DTDebt.h"

@implementation UserInfo
@synthesize debts,userLinks;
@synthesize sortedKeys;
+ (UserInfo *)sharedInstance {
    static UserInfo *instance = nil;
    if (instance == nil) {
        instance = [[UserInfo alloc] init];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        instance.debts = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"SAVED.debts"]];
        //instance.userLinks = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"SAVED.userLinks"]];
        instance.userLinks = [NSMutableDictionary dictionary];
        instance.sortedKeys = [NSArray arrayWithArray:[defaults objectForKey:@"SAVED.sortedKeys"]];
//        instance.debts = [NSMutableDictionary dictionary];
//        instance.sortedKeys = [NSArray array];
//        instance.userLinks = [NSMutableDictionary dictionary];
    }
    return instance;
}

- (void)parseDebtData:(NSArray*)data {
    NSString *myFBid = [DTUser getCurrentUser].facebookID;
    NSMutableDictionary *debtCopy = [NSMutableDictionary dictionary];
    
    for (DTDebt *debt in data) {
        if ([debt.debtor.facebookID isEqualToString:myFBid]) {
            [self.userLinks setObject:debt.creditor forKey:debt.creditor.facebookID];

            NSNumber *amount = [[debtCopy objectForKey:debt.creditor.facebookID] objectForKey:@"amount"];
            if (amount) {
                NSDictionary *debtDictionary = @{@"amount" : [NSNumber numberWithDouble:[amount doubleValue] - debt.amount],
                                                 @"name" : debt.creditor.name};
                [debtCopy setObject:debtDictionary forKey:debt.creditor.facebookID];
            } else {
                NSDictionary *debtDictionary = @{@"amount" : [NSNumber numberWithDouble:-debt.amount],
                                                 @"name" : debt.creditor.name};
                [debtCopy setObject:debtDictionary forKey:debt.creditor.facebookID];
            }
        } else if ([debt.creditor.facebookID isEqualToString:myFBid]){
            [self.userLinks setObject:debt.debtor forKey:debt.debtor.facebookID];

            NSNumber *amount = [[debtCopy objectForKey:debt.debtor.facebookID] objectForKey:@"amount"];

            if (amount) {
                NSDictionary *debtDictionary = @{@"amount" : [NSNumber numberWithDouble:[amount doubleValue] + debt.amount],
                                                 @"name" : debt.debtor.name};
                [debtCopy setObject:debtDictionary forKey:debt.debtor.facebookID];
            } else {
                NSDictionary *debtDictionary = @{@"amount" : [NSNumber numberWithDouble:debt.amount],
                                                 @"name" : debt.debtor.name};
                [debtCopy setObject:debtDictionary forKey:debt.debtor.facebookID];
            }
        } else {
            NSLog(@"SOMETHING WENT WRONG IN USERINFO");
        }
    }
    self.debts = debtCopy;
    self.sortedKeys = [self.debts allKeys];
    [self save];
}

- (void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.sortedKeys forKey:@"SAVED.sortedKeys"];
    [defaults setObject:self.debts forKey:@"SAVED.debts"];
    //[defaults setObject:self.userLinks forKey:@"SAVED.userLinks"];
    [defaults synchronize];
}


@end
