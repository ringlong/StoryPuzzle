//
//  NSDictionary+RRAdditions.m
//  RRToolkit
//
//  Created by Ryan on 4/8/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import "NSDictionary+RRAdditions.h"
#import "RRPreprocessorMacros.h"

RR_FIX_CATEGORY_BUG(NSDictionaryEYAdditions)

@implementation NSDictionary (RRAdditions)


@end

@implementation NSMutableDictionary (RRAdditions)

+ (NSMutableDictionary *)dictionaryWithNonRetaining {
    return (__bridge_transfer NSMutableDictionary *)CFDictionaryCreateMutable(nil, 0, nil, nil);
}

@end
