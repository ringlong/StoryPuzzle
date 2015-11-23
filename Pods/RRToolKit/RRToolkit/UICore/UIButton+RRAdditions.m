//
//  UIButton+RRAdditions.m
//  RRToolkit
//
//  Created by Ryan on 14-6-12.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "UIButton+RRAdditions.h"

@implementation UIButton (RRAdditions)

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
               forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *button = [[self class] buttonWithType:type];
    button.frame = frame;
    if (title) {
        [button setTitle:title forState:state];
    }
    if (titleColor) {
        [button setTitleColor:titleColor forState:state];
    }
    if (font) {
        button.titleLabel.font = font;
    }
    if (image) {
        [button setImage:image forState:state];
    }
    if (backgroundImage) {
        [button setBackgroundImage:backgroundImage forState:state];
    }
    [button addTarget:target action:action forControlEvents:controlEvents];
    return button;
}

- (void)addTitle:(NSString *)title
      titleColor:(UIColor *)titleColor
           image:(UIImage *)image
 backgroundImage:(UIImage *)backgroundImage
        forState:(UIControlState)state
{
    if (title) {
        [self setTitle:title forState:state];
    }
    if (titleColor) {
        [self setTitleColor:titleColor forState:state];
    }
    if (image) {
        [self setImage:image forState:state];
    }
    if (backgroundImage) {
        [self setBackgroundImage:backgroundImage forState:state];
    }
}

@end
