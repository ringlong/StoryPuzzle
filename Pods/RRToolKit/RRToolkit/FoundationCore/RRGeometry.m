//
//  RRGeometry.m
//  RRToolkit
//
//  Created by Ryan on 3/13/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import "RRGeometry.h"

CGRect RRRectContract(CGRect rect, CGFloat dx, CGFloat dy) {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - dx, rect.size.height - dy);
}

CGRect RRRectExpand(CGRect rect, CGFloat dx, CGFloat dy) {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + dx, rect.size.height + dy);
}

CGRect RRRectShift(CGRect rect, CGFloat dx, CGFloat dy) {
    return CGRectOffset(RRRectContract(rect, dx, dy), dx, dy);
}

CGRect RRRectInset(CGRect rect, UIEdgeInsets insets) {
    return CGRectMake(rect.origin.x + insets.left, rect.origin.y + insets.top,
                      rect.size.width - (insets.left + insets.right),
                      rect.size.height - (insets.top + insets.bottom));
}
