//
//  DTUser.m
//  det
//
//  Created by Justin Huang on 3/3/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import "DTUser.h"
#import "DTDebt.h"

@interface DTUser()
+(NSString*) generateRandomPassword;
@end

@implementation DTUser

- (DTUser*)initWithPFUser:(PFUser *)pf_user {
    self = [super init];
    if (self) {
        self.user = pf_user;
        self.facebookID = [pf_user objectForKey:@"fbID"];
        self.email = pf_user.email;
        self.username = pf_user.username;
        self.password = pf_user.password;
        self.objectID = pf_user.objectId;
        self.name = [pf_user objectForKey:@"name"];
    }
    return self;
}
- (DTUser*)initDefaultWithFacebookID:(NSString *)fbID andName:(NSString *)name {
    return [self initDefaultWithFacebookID:fbID andName:name andEmail:nil];
}

- (DTUser*)initDefaultWithFacebookID:(NSString *)fbID andName:(NSString *)name andEmail:(NSString*)email {
    self = [super init];
    if(self) {
        self.user = [PFUser user];
        self.facebookID = fbID;
        self.password = [DTUser generateRandomPassword];
        self.username = fbID;
        self.email = email;
        self.name = name;
        [self registerUser];
    }
    
    return self;
}

- (void)registerUser {
    self.user.username = self.username;
    self.user.password = self.password;
    if (self.email) {
        [self.user setObject:self.email forKey:@"email"];
    } else {
        [self.user setObject:[NSNull null] forKey:@"email"];
    }
    [self.user setObject:self.facebookID forKey:@"fbID"];
    [self.user setObject:self.name forKey:@"name"];

    
    // User needs to be saved in order for debt row to be saved.
    NSError *error;
    if ([self.user signUp:&error])
    {
        NSLog(@"User created successfully");
    }
    else
    {
        NSLog(@"%@", error);
    }
    
    self.objectID = self.user.objectId;
}

-(void)saveUser {
    self.user.username = self.username;
    self.user.password = self.password;
    self.user.email = self.email;
    [self.user save];
}



+ (DTUser*)getCurrentUser {
    PFUser *current_pf_user = [PFUser currentUser];
    DTUser *current_user = [[DTUser alloc] initWithPFUser:current_pf_user];
    return current_user;
}

+ (DTUser*)getOrCreateUserWithFacebookID:(NSString*)fbID andName:(NSString *)name {
    PFQuery *query = [PFUser query];
    [query whereKey:@"fbID" equalTo:fbID];
    PFUser *pf_user = (PFUser*)[query getFirstObject];
    if (pf_user) {
      return [[DTUser alloc] initWithPFUser:pf_user];
    }
    
    DTUser *user = [[DTUser alloc] initDefaultWithFacebookID:fbID andName:name];
    
    return user;
}

+ (void)linkUserData:(NSString*)fbID andName:(NSString *)name andEmail:(NSString*)email {
    PFQuery *query = [PFUser query];
    [query whereKey:@"fbID" equalTo:fbID];
    PFUser *pf_user = (PFUser*)[query getFirstObject];
    if (pf_user) {
        [PFUser logInWithUsername:pf_user.username password:@"abc"];
        [pf_user setObject:email forKey:@"email"];
        [pf_user save];
    } else {
        DTUser *newUser = [[DTUser alloc] initDefaultWithFacebookID:fbID andName:name andEmail:email];
        [PFUser logInWithUsername:newUser.username password:@"abc"];
    }
    //[[NSNotificationCenter defaultCenter] postNotificationName:nParseLoggedIn object:self];
}

+ (NSString*)generateRandomPassword {
    int NUMBER_OF_CHARS = 15;
    char data[NUMBER_OF_CHARS];
    for (int x=0;x<NUMBER_OF_CHARS;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return @"abc";
    return [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
}




@end
