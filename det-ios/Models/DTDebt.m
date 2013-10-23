//
//  DTDebt.m
//  det
//
//  Created by Justin Huang on 3/3/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTDebt.h"
#import "DTUser.h"
#import "DTTransaction.h"
#import <Parse/Parse.h>

@implementation DTDebt

- (DTDebt*)initWithPFObject:(PFObject*)pfDebt {
    self = [super init];
    if (self) {
        PFUser *pf_debtor = [pfDebt objectForKey:@"debtor"];
        [pf_debtor fetch];
        PFUser *pf_creditor = [pfDebt objectForKey:@"creditor"];
        [pf_creditor fetch];
        self.debtor = [[DTUser alloc] initWithPFUser:pf_debtor];
        self.creditor = [[DTUser alloc] initWithPFUser:pf_creditor];
        self.amount = [[pfDebt objectForKey:@"amount"] doubleValue];
        self.debt = pfDebt;
    }
    return self;
}

- (DTDebt*)initWithDebtor:(DTUser*)debtor
              AndCreditor:(DTUser*)creditor
                AndAmount:(double)amount {
    self = [super init];
    if(self)
    {
        // Set instance attributes
        self.debtor = debtor;
        self.creditor = creditor;
        self.amount = amount;
        
        // Create debts row for parse
        self.debt = [PFObject objectWithClassName:@"Debt"];
        [self.debt setObject:self.debtor.user forKey:@"debtor"];
        [self.debt setObject:self.creditor.user forKey:@"creditor"];
        [self.debt setObject:[NSNumber numberWithDouble:self.amount] forKey:@"amount"];
    }
    
    return self;
}

- (void)saveDebt:(DTTransaction*)transaction {
    // Link debt to it's transaction
    [self.debt setObject:transaction.transaction forKey:@"transaction"];
    
    // Save debts row for parse
    [self.debt saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The debt saved successfully.
            NSLog(@"Successfully added debt row");
        } else {
            // There was an error saving the debt.
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Adding debt row failed with error: %@", errorString);
        }
    }];
}

@end
