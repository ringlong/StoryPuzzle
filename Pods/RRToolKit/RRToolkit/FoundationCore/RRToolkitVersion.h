//
//  RRToolkitVersion.h
//  RRToolkit
//
//  Created by Ryan on 3/12/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRToolkitVersion : NSObject

/**
 * MAJOR.MINOR.BUGFIX
 * For example, 1.3.5 is:
 *  - `1`:the first major release
 *  - `3`:with no minor updates
 *  - `5`:with 5 bugfix patches
 */
+ (NSString*)version;

/**
 * Major release number.
 */
+ (NSInteger)majorVersion;

/**
 * Minor release number.
 */
+ (NSInteger)minorVersion;

/**
 * Bugfix release number.
 */
+ (NSInteger)bugfixVersion;

@end
