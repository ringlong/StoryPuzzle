//
//  NSString+RRAdditions.h
//  RRToolkit
//
//  Created by Ryan on 3/12/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RRAdditions)
@property (nonatomic, readonly) NSString *md5; // Calculate the md5 hash of this string using CC_MD5.
@property (nonatomic, readonly) NSString *sha1; // Calculate the SHA1 hash of this string using CommonCrypto CC_SHA1.
@property (nonatomic, readonly) NSString *base64; // Returns a string representation of the receiver Base64 encoded.

+ (NSString *)stringWithBase64String:(NSString *)base64String; // Returns a new string contained in the Base64 encoded string.
+ (NSString *)stringWithUUID; // Returns a new string containing a Universally Unique Identifier.

/**
 * Compare two version
 * For examples:
 * [@"10.4" compareToVersionString:@"10.3"]; // NSOrderedDescending
 * [@"10.5" compareToVersionString:@"10.5.0"]; // NSOrderedSame
 * [@"10.4 Build 8L127" compareToVersionString:@"10.4 Build 8P135"]; // NSOrderedAscending
 */
- (NSComparisonResult)compareToVersionString:(NSString *)version;

- (NSString *)stringByURLEncoding; // Returns a URL Encoded String
- (NSString *)stringByURLDecoding; // Returns a URL Decoded String
- (NSString *)stringByURLParameterEncoding; // Returns a URL parameter Encoded String
- (NSString *)stringByTrim; // Returns a new string with not whitespace and newlines.
- (BOOL)isEmpty; // Determines if the string's lenght is 0.
- (BOOL)isNotEmpty; // Determines if the string's lenght is not 0.
- (BOOL)isContainsString:(NSString *)string; // Determines if the receiver contains the given `string`
- (BOOL)isWhitespaceAndNewline; // Determines if the string contains only whitespace and newlines.

- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding; // Parses a URL query string into a dictionary where the values are arrays.
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query; // Parses a URL, adds query parameters to its query, and re-encodes it as a new URL.
/**
 * Parses a URL, adds stringByURLEncoding query parameters to its query, and re-encodes it as a new URL.
 * @throw NSInvalidArgumentException If any value or key does not respond to urlEncoded.
 */
- (NSString*)stringByAddingURLEncodedQueryDictionary:(NSDictionary*)query;

@end
