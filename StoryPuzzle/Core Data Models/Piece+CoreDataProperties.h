//
//  Piece+CoreDataProperties.h
//  StoryPuzzle
//
//  Created by Vanessa on 15/12/2.
//  Copyright © 2015年 BitAuto. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Piece.h"

NS_ASSUME_NONNULL_BEGIN

@interface Piece (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *angle;
@property (nullable, nonatomic, retain) NSNumber *edge0;
@property (nullable, nonatomic, retain) NSNumber *edge1;
@property (nullable, nonatomic, retain) NSNumber *edge2;
@property (nullable, nonatomic, retain) NSNumber *edge3;
@property (nullable, nonatomic, retain) NSNumber *isFree;
@property (nullable, nonatomic, retain) NSNumber *moves;
@property (nullable, nonatomic, retain) NSNumber *number;
@property (nullable, nonatomic, retain) NSNumber *position;
@property (nullable, nonatomic, retain) NSNumber *rotations;
@property (nullable, nonatomic, retain) NSManagedObject *image;
@property (nullable, nonatomic, retain) NSManagedObject *puzzle;

@end

NS_ASSUME_NONNULL_END
