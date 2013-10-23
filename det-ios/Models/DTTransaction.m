//
//  DTTransaction.m
//  det
//
//  Created by Justin Huang on 3/3/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTTransaction.h"
#import "DTDebt.h"
#import <Parse/Parse.h>

@implementation DTTransaction

- (DTTransaction*)initWithDescription:(NSString*)description
{
    self = [super init];
    if (self) {
        self.transaction = [PFObject objectWithClassName:@"Transaction"];
        self.debts = [NSMutableArray array];
        self.description = description;
        [self.transaction setObject:self.description forKey:@"description"];
    }
    
    return self;
}


- (void)addDebt:(DTDebt*)debt {
    [self.debts addObject:debt];
}

- (void)addDebts:(NSArray*)debts {
    [self.debts addObjectsFromArray:debts];
}

- (void)saveTransaction {
    NSMutableArray *arrayToSave = [NSMutableArray array];
    for (DTDebt* debtIterator in self.debts) {
        [arrayToSave addObject:debtIterator.debt];
    }
    
    [self.transaction setObject:arrayToSave forKey:@"debts"];
    [self.transaction saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The transaction saved successfully.
            NSLog(@"Successfully added transaction (and its corresponding debts)");
        } else {
            // There was an error saving the transaction.
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Adding transaction failed with error: %@", errorString);
        }
    }];
}


@end
