//
//  UILabel+RRAdditions.h
//  RRToolkit
//
//  Created by Ryan on 14-6-12.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (RRAdditions)

// Quickly create a label.
+ (instancetype)labelWithFrame:(CGRect)frame
                          text:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
               backgroundColor:(UIColor *)backgroundColor
                 textAlignment:(NSTextAlignment)textAlignment;

@end
