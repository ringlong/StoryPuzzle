//
//  UIButton+RRAdditions.h
//  RRToolkit
//
//  Created by Ryan on 14-6-12.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (RRAdditions)

// Quickly create a button.
+ (instancetype)buttonWithFrame:(CGRect)frame
                           type:(UIButtonType)type
                          title:(NSString *)title
                     titleColor:(UIColor *)titleColor
                      titleFont:(UIFont *)font
                          image:(UIImage *)image
                backgroundImage:(UIImage *)backgroundImage
                       forState:(UIControlState)state
                         target:(id)target
                         action:(SEL)action
               forControlEvents:(UIControlEvents)controlEvents;

// Add some attributes for a button.
- (void)addTitle:(NSString *)title
      titleColor:(UIColor *)titleColor
           image:(UIImage *)image
 backgroundImage:(UIImage *)backgroundImage
        forState:(UIControlState)state;

@end
