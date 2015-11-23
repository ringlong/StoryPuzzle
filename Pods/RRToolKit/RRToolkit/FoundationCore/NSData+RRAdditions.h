//
//  NSData+RRAdditions.h
//  RRToolkit
//
//  Created by Ryan on 3/15/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (RRAdditions)
@property (nonatomic, readonly) NSString *md5; // Calculate the md5 hash of this string using CC_MD5.
@property (nonatomic, readonly) NSString *sha1; // Calculate the SHA1 hash of this string using CommonCrypto CC_SHA1.
@property (nonatomic, readonly) NSString *base64; // Returns a string representation of the receiver Base64 encoded.

+ (NSData *)dataWithBase64String:(NSString *)base64String; // Returns a new data contained in the Base64 encoded string.

@end
