//
//  UIColor+RRAdditions.h
//  RRToolkit
//
//  Created by Ryan on 3/21/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN void RGBtoHSV(CGFloat r, CGFloat g, CGFloat b, CGFloat* h, CGFloat* s, CGFloat* v);
UIKIT_EXTERN void HSVtoRGB(CGFloat *r, CGFloat *g, CGFloat *b, CGFloat h, CGFloat s, CGFloat v);

@interface UIColor (RRAdditions)
@property (nonatomic, readonly) CGFloat red; // Get red of the color.
@property (nonatomic, readonly) CGFloat green; // Get green of the color.
@property (nonatomic, readonly) CGFloat blue; // Get blue of the color.
@property (nonatomic, readonly) CGFloat alpha; // Get alpha of the color.
@property (nonatomic, readonly) UInt32 RGBHex; // Get rgb hex value of the color.
@property (nonatomic, readonly) UInt32 ARGBHex; // Get argb hex value of the color.

+ (UIColor *)randomColor; // Generate a random color.
+ (UIColor *)colorWithRGBHex:(UInt32)hex; // Generate a color with RGH hex.
+ (UIColor *)colorWithARGBHex:(UInt32)hex; // Generate a color with ARGH hex.
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert; // Generate a color with string of RGB hex.

- (NSString *)stringFromColor; // Return a string contained ARGB.
- (NSString *)hexStringFromColor; // Return a hex string contained ARGB.

- (UIColor *)highlightedColor; // Return a highlighted color.
- (UIColor *)shadowColor; // Return a shadow color.

@end
