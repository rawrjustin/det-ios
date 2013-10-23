//
//  DTUser.h
//  det
//
//  Created by Justin Huang on 3/3/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface DTUser : NSObject

@property (nonatomic, retain) PFUser *user;
@property (nonatomic, retain) NSString *objectID;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *facebookID;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *name;

// Given a PFUser, returns a DTUser with property values copied from the
// the PFUser
- (DTUser*)initWithPFUser:(PFUser*)PFUser;

// Given a facebook id, creates a place holder DTUser and registers it as a
// PFUser in the parse database.
-(DTUser*)initDefaultWithFacebookID:(NSString *)fbID andName:(NSString *)name andEmail:(NSString*)email;

// Creates new user in the Parse database.
- (void)registerUser;

// Updates the PFUser associated with this user with the user's property values.
- (void)saveUser;


// Returns a DTUser representing the current user.
+ (DTUser*)getCurrentUser;

// Returns the user with given facebook id. If the user did not already exist,
// a default DTUser with the facebook id will be created. 
+ (DTUser*)getOrCreateUserWithFacebookID:(NSString*)fbID andName:(NSString*)name;

// Links with existing PFuser in database
+ (void)linkUserData:(NSString*)fbID andName:(NSString *)name andEmail:(NSString*)email;
@end
