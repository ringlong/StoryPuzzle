//
//  UILabel+RRAdditions.m
//  RRToolkit
//
//  Created by Ryan on 14-6-12.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "UILabel+RRAdditions.h"

@implementation UILabel (RRAdditions)

+ (instancetype)labelWithFrame:(CGRect)frame
                          text:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
               backgroundColor:(UIColor *)backgroundColor
                 textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[[self class] alloc] initWithFrame:frame];
    if (text) {
        label.text = text;
    }
    if (font) {
        label.font = font;
    }
    if (textColor) {
        label.textColor = textColor;
    }
    if (backgroundColor) {
        label.backgroundColor = backgroundColor;
    }
    label.textAlignment = textAlignment;
    return label;
}

@end
