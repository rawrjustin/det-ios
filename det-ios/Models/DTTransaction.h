//
//  DTTransaction.h
//  det
//
//  Created by Justin Huang on 3/3/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class DTDebt;
@interface DTTransaction : NSObject

@property (nonatomic, retain) PFObject *transaction;
@property (nonatomic, retain) NSMutableArray *debts;
@property (nonatomic, retain) NSString *description;

// Initialize a DTTransaction instance
-(DTTransaction*) initWithDescription:(NSString*)description;

// Add a debt to the transaction
-(void) addDebt:(DTDebt*)debt;

// Add an array of debts to the transaction
-(void) addDebts:(NSArray*)debts;

// Save the transaction to parse
-(void) saveTransaction;

@end
