//
//  UIApplication+RRAdditions.h
//  RRToolkit
//
//  Created by Ryan on 4/7/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (RRAdditions)
@property (nonatomic, readonly) UIInterfaceOrientation interfaceOrientation; // Get current interface orientation.
@property (nonatomic, readonly) BOOL isLandscape; // Determines if current interface is in landscape state.
@property (nonatomic, readonly) BOOL isPortrait; // Determines if current interface is in portrait state.
@property (nonatomic, readonly) NSString *orientationString; // Get current interface orientation string.

+ (BOOL)appStoreWithAppId:(NSString *)appId; // Open app store with appId.
+ (BOOL)appStoreGiftWithAppId:(NSString *)appId; // Open app store gift with appId.
+ (BOOL)appStoreReviewWithAppId:(NSString *)appId; // Open app store review with appId.

+ (BOOL)phoneWithNumber:(NSString *)phoneNumber; // Make a phone call with the given number.
+ (BOOL)smsWithNumber:(NSString *)phoneNumber; // Start texting the given number.
+ (BOOL)mailWithRecipient:(NSString *)recipient // Open mail with recipient, cc, bcc, subject, body.
                   withCC:(NSString *)cc
                  withBCC:(NSString *)bcc
              withSubject:(NSString *)subject
                 withBody:(NSString *)body;

@end
