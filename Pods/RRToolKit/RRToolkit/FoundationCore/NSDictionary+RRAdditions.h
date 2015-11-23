//
//  NSDictionary+RRAdditions.h
//  RRToolkit
//
//  Created by Ryan on 4/8/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RRAdditions)



@end

@interface NSMutableDictionary (RRAdditions)

/**
 * Creates a mutable dictionary which does not retain references to the values it contains.
 *
 * Typically used with dictionaries of delegates.
 */
+ (NSMutableDictionary *)dictionaryWithNonRetaining; // Copied and pasted from Three20 http://three20.info/

@end
