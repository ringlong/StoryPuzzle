//
//  NSArray+RRAdditions.m
//  RRToolkit
//
//  Created by Ryan on 4/8/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import "NSArray+RRAdditions.h"
#import "RRPreprocessorMacros.h"

RR_FIX_CATEGORY_BUG(NSArrayEYAdditions)

@implementation NSArray (RRAdditions)

@end

@implementation NSMutableArray (RRAdditions)

+ (NSMutableArray *)arrayWithNonRetaining {
    return (__bridge_transfer NSMutableArray *)CFArrayCreateMutable(nil, 0, nil);
}

@end
