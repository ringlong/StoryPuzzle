//
//  PuzzleOperation.m
//  StoryPuzzle
//
//  Created by Vanessa on 15/12/3.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

#import "PuzzleOperation.h"
#import "AppDelegate.h"
#import "Piece.h"
#import "Puzzle.h"
#import "Image.h"

@implementation PuzzleOperation

- (void)main {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    _insertionContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _insertionContext.undoManager = nil;
    _insertionContext.persistentStoreCoordinator = appDelegate.persistentStoreCoordinator;
    
    [_insertionContext save:nil];
}

- (Puzzle *)newPuzzleInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription
            insertNewObjectForEntityForName:@"Puzzle"
            inManagedObjectContext:context];
}

- (Image *)newImageInContext:(NSManagedObjectContext *)context {
    
    return [NSEntityDescription
            insertNewObjectForEntityForName:@"Image"
            inManagedObjectContext:context];
}

- (Piece *)newPieceInContext:(NSManagedObjectContext *)context {
    
    return [NSEntityDescription
            insertNewObjectForEntityForName:@"Piece"
            inManagedObjectContext:context];
}

@end
