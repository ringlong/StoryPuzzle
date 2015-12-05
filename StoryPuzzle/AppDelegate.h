//
//  AppDelegate.h
//  StoryPuzzle
//
//  Created by Ryan on 15/11/20.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

#define YELLOW [UIColor colorWithRed:1.0 green:200.0/255.0 blue:0.0 alpha:1.0]
#define WOOD [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wood.jpg"]]

@import UIKit;
@import CoreData;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

