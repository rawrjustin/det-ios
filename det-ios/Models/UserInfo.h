//
//  UserInfo.h
//  det
//
//  Created by Justin Huang on 3/18/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic, retain) NSMutableDictionary *debts;
@property (nonatomic, retain) NSArray *sortedKeys;
@property (nonatomic, retain) NSMutableDictionary *userLinks;
@property (nonatomic) double owed;
@property (nonatomic) double owe;
+ (UserInfo *)sharedInstance;
- (void)parseDebtData:(NSArray*)data;

@end
