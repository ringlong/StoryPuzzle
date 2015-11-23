//
//  UIWindow+RRAdditions.m
//  RRToolkit
//
//  Created by Ryan on 3/29/13.
//  Copyright (c) 2013 Ryan. All rights reserved.
//

#import "UIWindow+RRAdditions.h"
#import "RRPreprocessorMacros.h"

RR_FIX_CATEGORY_BUG(UIWindowEYAdditions)

@implementation UIWindow (RRAdditions)

+ (BOOL)isKeyboardVisible {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    return !![window findFirstResponder];
}

- (UIView *)findFirstResponder {
    return [self findFirstResponderInView:self];
}

- (UIView *)findFirstResponderInView:(UIView *)topView {
    if ([topView isFirstResponder]) {
        return topView;
    }
    
    for (UIView* subView in topView.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
        
        UIView* firstResponderCheck = [self findFirstResponderInView:subView];
        if (nil != firstResponderCheck) {
            return firstResponderCheck;
        }
    }
    return nil;
}

@end
