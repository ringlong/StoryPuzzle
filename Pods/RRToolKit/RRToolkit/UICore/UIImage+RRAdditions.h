//
//  UIImage+RRAdditions.h
//  RRToolkit
//
//  Created by Ryan on 4/1/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RRAdditions)

// Create a image with color. Size is {1, 1}.
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 * Creates and returns a new cropped image object.
 * @param rect A rectangle whose coordinates specify the area to create an image from in points.
 * @return A new cropped image object.
 */
- (UIImage *)imageCroppedToRect:(CGRect)rect;

// The following Copied and pasted from Three20 http://three20.info/
- (UIImage*)imageWithTransformWidth:(CGFloat)width height:(CGFloat)height rotate:(BOOL)rotate; // Resizes an image. Optionally rotates the image based on imageOrientation.
- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode; // Returns a CGRect positioned within rect given the contentMode.
- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode; // Draws the image using content mode rules.
// Draws the image as a rounded rectangle.
- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius;
- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode;

@end
