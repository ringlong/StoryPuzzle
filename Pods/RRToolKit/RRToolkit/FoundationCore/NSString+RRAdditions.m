//
//  NSString+RRAdditions.m
//  RRToolkit
//
//  Created by Ryan on 3/12/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import "NSString+RRAdditions.h"
#import "NSData+RRAdditions.h"
#import "RRPreprocessorMacros.h"

RR_FIX_CATEGORY_BUG(NSStringEYAdditions)

@implementation NSString (RRAdditions)
@dynamic md5, sha1, base64;

#pragma mark - Create String
+ (NSString *)stringWithBase64String:(NSString *)base64String {
    return [[NSString alloc] initWithData:[NSData dataWithBase64String:base64String] encoding:NSUTF8StringEncoding];
}

+ (NSString *)stringWithUUID {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);
    NSString *returnString = [NSString stringWithString:(__bridge NSString *)string];
    CFRelease(string);
	return returnString;
}

#pragma mark - Getter
- (NSString *)md5 {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5];
}

- (NSString *)sha1 {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1];
}

- (NSString *)base64 {
	return [[self dataUsingEncoding:NSUTF8StringEncoding] base64];
}

#pragma mark - Compare Methods
// Adapted from http://snipplr.com/view/2771/compare-two-version-strings
- (NSComparisonResult)compareToVersionString:(NSString *)version {
    // Break version into fields (separated by '.')
	NSMutableArray *leftFields  = [[NSMutableArray alloc] initWithArray:[self  componentsSeparatedByString:@"."]];
	NSMutableArray *rightFields = [[NSMutableArray alloc] initWithArray:[version componentsSeparatedByString:@"."]];
	
	// Implict ".0" in case version doesn't have the same number of '.'
	if ([leftFields count] < [rightFields count]) {
		while ([leftFields count] != [rightFields count]) {
			[leftFields addObject:@"0"];
		}
	} else if ([leftFields count] > [rightFields count]) {
		while ([leftFields count] != [rightFields count]) {
			[rightFields addObject:@"0"];
		}
	}
	
	// Do a numeric comparison on each field
	for (NSUInteger i = 0; i < [leftFields count]; i++) {
		NSComparisonResult result = [[leftFields objectAtIndex:i] compare:[rightFields objectAtIndex:i] options:NSNumericSearch];
		if (result != NSOrderedSame) {
			return result;
		}
	}
	
	return NSOrderedSame;
}

#pragma mark - Get String Methods
- (NSString *)stringByURLEncoding {
    static CFStringRef toEscape = CFSTR(":/=,!$&'()*+;[]@#?%");
    CFStringRef string = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               toEscape,
                                                               kCFStringEncodingUTF8);
    NSString *returnString = [NSString stringWithString:(__bridge NSString *)string];
    CFRelease(string);
	return returnString;
}

- (NSString *)stringByURLDecoding {
    CFStringRef string = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                               (CFStringRef)self,
                                                                               CFSTR(""),
                                                                               kCFStringEncodingUTF8);
    NSString *returnString = [NSString stringWithString:(__bridge NSString *)string];
    CFRelease(string);
	return returnString;
}

- (NSString *)stringByURLParameterEncoding {
    static CFStringRef toEscape = CFSTR(":/=,!$&'()*+;[]@#?");
    CFStringRef string = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                 (CFStringRef)self,
                                                                 NULL,
                                                                 toEscape,
                                                                 kCFStringEncodingUTF8);
    NSString *returnString = [NSString stringWithString:(__bridge NSString *)string];
    CFRelease(string);
	return returnString;
}

- (NSString *)stringByTrim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - Boolean
- (BOOL)isEmpty {
	return [self length] > 0 ? NO : YES;
}

- (BOOL)isNotEmpty {
	return [self length] > 0 ? YES : NO;
}

- (BOOL)isContainsString:(NSString *)string {
    return !NSEqualRanges([self rangeOfString:string], NSMakeRange(NSNotFound, 0));
}

- (BOOL)isWhitespaceAndNewline {
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![whitespace characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - URL About
// Copied and pasted from Three20 http://three20.info/
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 1 || kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSMutableArray* values = [pairs objectForKey:key];
            if (nil == values) {
                values = [NSMutableArray array];
                [pairs setObject:values forKey:key];
            }
            if (kvPair.count == 1) {
                [values addObject:[NSNull null]];
                
            } else if (kvPair.count == 2) {
                NSString* value = [[kvPair objectAtIndex:1]
                                   stringByReplacingPercentEscapesUsingEncoding:encoding];
                [values addObject:value];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}

// Copied and pasted from Three20 http://three20.info/
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [query keyEnumerator]) {
        NSString* value = [query objectForKey:key];
        value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
        [pairs addObject:pair];
    }
    
    NSString* params = [pairs componentsJoinedByString:@"&"];
    if ([self rangeOfString:@"?"].location == NSNotFound) {
        return [self stringByAppendingFormat:@"?%@", params];
        
    } else {
        return [self stringByAppendingFormat:@"&%@", params];
    }
}

// Copied and pasted from Three20 http://three20.info/
- (NSString*)stringByAddingURLEncodedQueryDictionary:(NSDictionary*)query {
    NSMutableDictionary* encodedQuery = [NSMutableDictionary dictionaryWithCapacity:[query count]];
    
    for (NSString __strong * key in [query keyEnumerator]) {
        NSParameterAssert([key respondsToSelector:@selector(stringByURLEncoding)]);
        NSString* value = [query objectForKey:key];
        NSParameterAssert([value respondsToSelector:@selector(stringByURLEncoding)]);
        value = [value stringByURLEncoding];
        key = [key stringByURLEncoding];
        [encodedQuery setValue:value forKey:key];
    }
    
    return [self stringByAddingQueryDictionary:encodedQuery];
}

@end
