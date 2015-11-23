//
//  UIView+RRAdditions.h
//  RRToolkit
//
//  Created by Ryan on 4/1/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RRAdditions)

- (UIViewController *)viewController; // The view controller whose view contains this view.
/**
 * Returns a snapshot of the view.
 *
 * This method takes into account the offset of scrollable views and captures whatever is currently
 * in the frame of the view.
 *
 * @param transparent Return a snapshot of the view with transparency if transparent is YES.
 */
- (UIImage *)snapshotWithTransparent:(BOOL)transparent;

// The following copied and pasted from Three20 http://three20.info/
@property (nonatomic) CGFloat left; // Sets frame.origin.x = left
@property (nonatomic) CGFloat top; // Sets frame.origin.y = top
@property (nonatomic) CGFloat right; // Sets frame.origin.x = right - frame.size.width
@property (nonatomic) CGFloat bottom; // Sets frame.origin.y = bottom - frame.size.height
@property (nonatomic) CGFloat width; // Sets frame.size.width = width
@property (nonatomic) CGFloat height; // Sets frame.size.height = height
@property (nonatomic) CGFloat centerX; // Sets center.x = centerX
@property (nonatomic) CGFloat centerY; // Sets center.y = centerY
@property (nonatomic, readonly) CGFloat screenX; // Return the x coordinate on the screen, taking into account scroll views.
@property (nonatomic, readonly) CGFloat screenY; // Return the y coordinate on the screen, taking into account scroll views.
@property (nonatomic, readonly) CGRect screenFrame; // Return the view frame on the screen, taking into account scroll views.
@property (nonatomic) CGPoint origin; // Sets frame.origin = origin
@property (nonatomic) CGSize size; // Sets frame.size = size
@property (nonatomic, readonly) CGFloat orientationWidth; // Return the width in portrait or the height in landscape.
@property (nonatomic, readonly) CGFloat orientationHeight; // Return the height in portrait or the width in landscape.

+ (instancetype)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color; // Quickly create a view.

- (UIView *)descendantOrSelfWithClass:(Class)cls; // Finds the first descendant view (including this view) that is a member of a particular class.
- (UIView *)ancestorOrSelfWithClass:(Class)cls; // Finds the first ancestor view (including this view) that is a member of a particular class.

- (void)removeAllSubviews; // Removes all subviews.

/**
 * Calculates the origin of this view from another parent view in screen coordinates.
 *
 * parentView should be a parent view of this view.
 */
- (CGPoint)originInView:(UIView *)parentView;

// Layer properties, they can use in xib/storyboard file.
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable float shadowOpacity;
@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowRadius;

@end
