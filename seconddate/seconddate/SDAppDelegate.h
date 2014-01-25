//
//  SDAppDelegate.h
//  seconddate
//
//  Created by Eytan Moudahi on 1/25/2014.
//  Copyright (c) 2014 WTLP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
