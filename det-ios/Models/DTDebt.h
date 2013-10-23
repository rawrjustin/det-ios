//
//  DTDebt.h
//  det
//
//  Created by Justin Huang on 3/3/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class DTTransaction;
@class DTUser;
@interface DTDebt : NSObject

@property (nonatomic, retain) PFObject *debt;
@property (nonatomic, retain) DTUser *debtor;
@property (nonatomic, retain) DTUser *creditor;
@property (nonatomic) double amount;

// Initialize a DTDebt instance given a Debt PFObject
-(DTDebt*) initWithPFObject:(PFObject*)pfDebt;

// Initialize a DTDebt instance
-(DTDebt*) initWithDebtor:(DTUser*)debtor
              AndCreditor:(DTUser*)creditor
                AndAmount:(double)amount;

// Save the debt to parse
-(void) saveDebt:(DTTransaction*)transaction;

@end
