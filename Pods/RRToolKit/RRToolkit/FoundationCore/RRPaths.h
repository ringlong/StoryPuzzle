//
//  RRPaths.h
//  RRToolkit
//
//  Created by Ryan on 3/13/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Application path, don't save any thing.
 * e.g. "/var/mobile/Applications/54464CDB-E1D0-495B-84B7-2521CDCDDA4C/Applications"
 */
NSString* RRPathForApp();

/**
 * Document path, user use this path to save file.
 * e.g. "/var/mobile/Applications/54464CDB-E1D0-495B-84B7-2521CDCDDA4C/Documents"
 */
NSString* RRPathForDocument();

/**
 * Preferences path, this path to save configuration files.
 * e.g. "/var/mobile/Applications/54464CDB-E1D0-495B-84B7-2521CDCDDA4C/Library/Preferences"
 */
NSString* RRPathForLibPreferences();

/**
 * Cache path, OS don't clear files in this path, but iTunes can do.
 * e.g. "/var/mobile/Applications/54464CDB-E1D0-495B-84B7-2521CDCDDA4C/Library/Caches"
 */
NSString* RRPathForLibCache();

/**
 * Temp path, OS maybe clear files in this path when application exit.
 * e.g. "/var/mobile/Applications/54464CDB-E1D0-495B-84B7-2521CDCDDA4C/Library/tmp"
 */
NSString* RRPathForTmp();
