//
//  DTAppDelegate.h
//  det-ios
//
//  Created by Justin Huang on 10/22/13.
//  Copyright (c) 2013 Justin Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTAppDelegate : UIResponder <UIApplicationDelegate> {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UIWindow *window;

- (NSString *)applicationDocumentsDirectory;

@end
