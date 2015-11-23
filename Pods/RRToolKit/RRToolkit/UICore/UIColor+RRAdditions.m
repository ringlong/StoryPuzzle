//
//  UIColor+RRAdditions.m
//  RRToolkit
//
//  Created by Ryan on 3/21/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import "UIColor+RRAdditions.h"
#import "RRPreprocessorMacros.h"

RR_FIX_CATEGORY_BUG(UIColorEYAdditions)

#define MAX3(a,b,c) (a > b ? (a > c ? a : c) : (b > c ? b : c))
#define MIN3(a,b,c) (a < b ? (a < c ? a : c) : (b < c ? b : c))

// Color algorithms from http://www.cs.rit.edu/~ncs/color/t_convert.html
void RGBtoHSV(CGFloat r, CGFloat g, CGFloat b, CGFloat* h, CGFloat* s, CGFloat* v) {
    CGFloat min, max, delta;
    min = MIN3(r, g, b);
    max = MAX3(r, g, b);
    *v = max;        // v
    delta = max - min;
    if ( max != 0 )
        *s = delta / max;    // s
    else {
        // r = g = b = 0    // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if ( r == max )
        *h = ( g - b ) / delta;    // between yellow & magenta
    else if ( g == max )
        *h = 2 + ( b - r ) / delta;  // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta;  // between magenta & cyan
    *h *= 60;        // degrees
    if ( *h < 0 )
        *h += 360;
}

void HSVtoRGB(CGFloat *r, CGFloat *g, CGFloat *b, CGFloat h, CGFloat s, CGFloat v) {
    int i;
    CGFloat f, p, q, t;
    if ( s == 0 ) {
        // achromatic (grey)
        *r = *g = *b = v;
        return;
    }
    h /= 60;      // sector 0 to 5
    i = floor( h );
    f = h - i;      // factorial part of h
    p = v * ( 1 - s );
    q = v * ( 1 - s * f );
    t = v * ( 1 - s * ( 1 - f ) );
    switch( i ) {
        case 0:
            *r = v;
            *g = t;
            *b = p;
            break;
        case 1:
            *r = q;
            *g = v;
            *b = p;
            break;
        case 2:
            *r = p;
            *g = v;
            *b = t;
            break;
        case 3:
            *r = p;
            *g = q;
            *b = v;
            break;
        case 4:
            *r = t;
            *g = p;
            *b = v;
            break;
        default:    // case 5:
            *r = v;
            *g = p;
            *b = q;
            break;
    }
}

@implementation UIColor (RRAdditions)
@dynamic red, green, blue, alpha, RGBHex, ARGBHex;

#pragma mark - Property
- (CGFloat)red {
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)green {
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[1];
}

- (CGFloat)blue {
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[2];
}

- (CGFloat)alpha {
	return CGColorGetAlpha(self.CGColor);
}

- (UInt32)RGBHex {
	
	CGFloat r,g,b;
	
	r = MIN(MAX(self.red, 0.0f), 1.0f);
	g = MIN(MAX(self.green, 0.0f), 1.0f);
	b = MIN(MAX(self.blue, 0.0f), 1.0f);
	
	return (((int)roundf(r * 255)) << 16)
	| (((int)roundf(g * 255)) << 8)
	| (((int)roundf(b * 255)));
}

- (UInt32)ARGBHex {
	
	CGFloat a,r,g,b;
	
    a = MIN(MAX(self.alpha, 0.0f), 1.0f);
	r = MIN(MAX(self.red, 0.0f), 1.0f);
	g = MIN(MAX(self.green, 0.0f), 1.0f);
	b = MIN(MAX(self.blue, 0.0f), 1.0f);
	
	return (((int)roundf(a * 255)) << 24)
    | (((int)roundf(r * 255)) << 16)
	| (((int)roundf(g * 255)) << 8)
	| (((int)roundf(b * 255)));
}

#pragma mark - Class Methods
+ (UIColor *)randomColor {
	return [UIColor colorWithRed:arc4random() * 1. / UINT32_MAX
						   green:arc4random() * 1. / UINT32_MAX
							blue:arc4random() * 1. / UINT32_MAX
						   alpha:1.0f];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
	
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

+ (UIColor *)colorWithARGBHex:(UInt32)hex
{
    int b = hex & 0x000000FF;
    int g = ((hex & 0x0000FF00) >> 8);
    int r = ((hex & 0x00FF0000) >> 16);
    int a = ((hex & 0xFF000000) >> 24);
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a / 255.f];
}

// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor colorWithRGBHex:]
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
	return [UIColor colorWithRGBHex:hexNum];
}

#pragma mark - Description
- (NSString *)stringFromColor {
	return [NSString stringWithFormat:@"{%0.3f, %0.3f, %0.3f, %0.3f}", self.red, self.green, self.blue, self.alpha];
}

- (NSString *)hexStringFromColor {
	return [NSString stringWithFormat:@"%0.8X", (unsigned int)self.ARGBHex];
}

#pragma mark - Other color
- (UIColor *)highlightedColor {
    return [self multiplyHue:1 saturation:0.4 value:1.2];
}

- (UIColor *)shadowColor {
    return [self multiplyHue:1 saturation:0.6 value:0.6];
}

#pragma mark - Private Methods
- (UIColor*)multiplyHue:(CGFloat)hd saturation:(CGFloat)sd value:(CGFloat)vd {
    const CGFloat* rgba = CGColorGetComponents(self.CGColor);
    CGFloat r = rgba[0];
    CGFloat g = rgba[1];
    CGFloat b = rgba[2];
    CGFloat a = rgba[3];
    
    CGFloat h, s, v;
    RGBtoHSV(r, g, b, &h, &s, &v);
    
    h *= hd;
    v *= vd;
    s *= sd;
    
    HSVtoRGB(&r, &g, &b, h, s, v);
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
