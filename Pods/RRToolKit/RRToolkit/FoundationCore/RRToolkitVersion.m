//
//  RRToolkitVersion.m
//  RRToolkit
//
//  Created by Ryan on 3/12/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import "RRToolkitVersion.h"

static NSString* const RRToolkitVersionString = @"1.0.0";

@implementation RRToolkitVersion

+ (NSString *)version {
    return RRToolkitVersionString;
}

+ (NSInteger)majorVersion {
    return [[[RRToolkitVersionString componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
}

+ (NSInteger)minorVersion {
    return [[[RRToolkitVersionString componentsSeparatedByString:@"."] objectAtIndex:1] intValue];
}

+ (NSInteger)bugfixVersion {
    return [[[RRToolkitVersionString componentsSeparatedByString:@"."] objectAtIndex:2] intValue];
}

@end