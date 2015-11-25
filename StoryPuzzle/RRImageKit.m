//
//  RRImageKit.m
//  StoryPuzzle
//
//  Created by Vanessa on 15/11/23.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

#import "RRImageKit.h"

@implementation RRImageKit

+ (NSArray<UIImage *> *)separateImage:(UIImage *)image byRows:(NSInteger)rows columns:(NSInteger)columns cacheQuality:(CGFloat)quality {
    NSAssert(rows >= 1, @"illegal row!");
    NSAssert(columns >= 1, @"illegal column");
    NSAssert([image isKindOfClass:[UIImage class]], @"illegal image format!");
    
    CGFloat xStep = image.size.width / columns;
    CGFloat yStep = image.size.height / rows;
    
    NSString *prefixName = @"win";
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:rows * columns];
    
    for (NSInteger i = 0; i < rows; i++) {
        for (NSInteger j = 0; j < columns; j++) {
            CGRect rect = CGRectMake(xStep * j, yStep * i, xStep, yStep);
            CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
            
            UIImage *elementImage = [UIImage imageWithCGImage:imageRef];
            
            NSString *imageKey = [NSString stringWithFormat:@"%@_%@_%@.png", prefixName, @(i), @(j)];
            CFRelease(imageRef);
            
            if (quality <= 0) {
                continue;
            }
            quality = (quality > 1) ? 1 : quality;
            
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *imagePath = [path stringByAppendingPathComponent:imageKey];
            NSData *imageData = UIImageJPEGRepresentation(elementImage, quality);
            [imageData writeToFile:imagePath atomically:YES];
            
            [mutableArray addObject:elementImage];
        }
    }
    
    NSArray *array = [NSArray arrayWithArray:mutableArray];
    return array;
}

@end
