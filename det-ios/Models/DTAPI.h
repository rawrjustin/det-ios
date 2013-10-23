//
//  DTAPI.h
//  det
//
//  Created by Justin Huang on 10/21/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTAPI : NSObject

- (void)debtList:(void (^)(NSArray* debts))block;
//- (void)friendsList:(void (^)(NSArray* friends))block;
+ (void)linkUser:(PFUser*)newFBUser;
@end
