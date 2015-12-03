//
//  Puzzle+CoreDataProperties.h
//  StoryPuzzle
//
//  Created by Vanessa on 15/12/2.
//  Copyright © 2015年 BitAuto. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Puzzle.h"

NS_ASSUME_NONNULL_BEGIN

@interface Puzzle (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *elapsedTime;
@property (nullable, nonatomic, retain) NSDate *lastSaved;
@property (nullable, nonatomic, retain) NSNumber *moves;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *percentage;
@property (nullable, nonatomic, retain) NSNumber *pieceNumber;
@property (nullable, nonatomic, retain) NSNumber *rotations;
@property (nullable, nonatomic, retain) NSNumber *score;
@property (nullable, nonatomic, retain) Image *image;
@property (nullable, nonatomic, retain) Piece *pieces;

@end

NS_ASSUME_NONNULL_END
