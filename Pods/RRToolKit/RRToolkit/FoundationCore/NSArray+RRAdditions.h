//
//  NSArray+RRAdditions.h
//  RRToolkit
//
//  Created by Ryan on 4/8/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RRAdditions)

@end

@interface NSMutableArray (RRAdditions)

/**
 * Creates a mutable array which does not retain references to the objects it contains.
 *
 * Typically used with arrays of delegates.
 */
+ (NSMutableArray *)arrayWithNonRetaining; // Copied and pasted from Three20 http://three20.info/

@end
