//
//  RRGeometry.h
//  RRToolkit
//
//  Created by Ryan on 3/13/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * @return CGRectMake(origin.x, origin.y, size.width, size.height)
 */
CG_INLINE CGRect RRRectMakeWithOriginAndSize(CGPoint origin, CGSize size);
CG_INLINE CGRect RRRectMakeWithOriginAndSize(CGPoint origin, CGSize size) {
    CGRect rect;
    rect.origin = origin;
    rect.size = size;
    return rect;
}

/**
 * @return CGRectMake(origin.x, origin.y, width, height)
 */
CG_INLINE CGRect RRRectMakeWithOrigin(CGPoint origin, CGFloat width, CGFloat height);
CG_INLINE CGRect RRRectMakeWithOrigin(CGPoint origin, CGFloat width, CGFloat height) {
    CGRect rect;
    rect.origin = origin;
    rect.size.width = width; rect.size.height = height;
    return rect;
}

/**
 * @return CGRectMake(x, y, size.width, size.height)
 */
CG_INLINE CGRect RRRectMakeWithSize(CGFloat x, CGFloat y, CGSize size);
CG_INLINE CGRect RRRectMakeWithSize(CGFloat x, CGFloat y, CGSize size) {
    CGRect rect;
    rect.origin.x = x; rect.origin.y = y;
    rect.size = size;
    return rect;
}

/**
 * @return CGRectMake(x, y, w - dx, h - dy)
 */
CG_EXTERN CGRect RRRectContract(CGRect rect, CGFloat dx, CGFloat dy);

/**
 * @return CGRectMake(x, y, w + dx, h + dy)
 */
CG_EXTERN CGRect RRRectExpand(CGRect rect, CGFloat dx, CGFloat dy);

/**
 * @return CGRectMake(x + dx, y + dy, w - dx, h - dy)
 */
CG_EXTERN CGRect RRRectShift(CGRect rect, CGFloat dx, CGFloat dy);

/**
 * @return CGRectMake(x + left, y + top, w - (left + right), h - (top + bottom))
 */
CG_EXTERN CGRect RRRectInset(CGRect rect, UIEdgeInsets insets);
