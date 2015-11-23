//
//  UIScreen+Additions.h
//  RRToolkit
//
//  Created by Ryan on 15/5/27.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (Additions)

extern CGFloat OnePixel();

+ (CGFloat)screenWidth;

+ (CGFloat)screenHeight;

+ (CGFloat)scale;

/**
 *  屏幕缩放比例，以iPhone6为标准
 */
+ (CGFloat)screenScaleRatio;

@end
