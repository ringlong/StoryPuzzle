//
//  PuzzleOperation.h
//  StoryPuzzle
//
//  Created by Vanessa on 15/12/3.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

@import Foundation;
@import CoreData;

@class PuzzleOperation;
@protocol PuzzleOperationDelegate <NSObject>

@optional
// Notification posted by NSManagedObjectContext when saved.
- (void)puzzleDidSave:(NSNotification *)saveNotification;
// Called by the importer when parsing is finished.
- (void)puzzleDidFinishParsingData:(PuzzleOperation *)importer;
// Called by the importer in the case of an error.
- (void)puzzle:(PuzzleOperation *)importer didFailWithError:(NSError *)error;

@end

@interface PuzzleOperation : NSOperation

@property (nonatomic, weak) id<PuzzleOperationDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *insertionContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, assign) BOOL loadingGame;

@end
