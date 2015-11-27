//
//  RRImageKit.m
//  StoryPuzzle
//
//  Created by Vanessa on 15/11/23.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

#import "RRImageKit.h"
#import "RRImageView.h"

bool RRPositionEqualToPositon(RRPosition position1, RRPosition position2) {
    return position1.xPosition == position2.xPosition && position1.yPosition == position2.yPosition;
}


@implementation RRImageKit

+ (NSArray<RRImage *> *)separateImage:(UIImage *)image byRows:(NSInteger)rows columns:(NSInteger)columns cacheQuality:(CGFloat)quality {
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
            
            RRImage *elementImage = [RRImage imageWithCGImage:imageRef position:RRPositionMake(i, j)];
            
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

+ (NSArray<RRImage *> *)radomImageListWithOriginalImageList:(NSArray<RRImage *> *)originalImageList {
    NSMutableArray *tempList = [NSMutableArray arrayWithArray:originalImageList];
    for (NSInteger i = 0; i < originalImageList.count; i++) {
        u_int32_t randomIndex = arc4random_uniform((u_int32_t)originalImageList.count);
        RRImage *randomImage = tempList[randomIndex];
        [tempList removeObjectAtIndex:randomIndex];
        [tempList addObject:randomImage];
    }
    NSArray *radomImageList = [NSArray arrayWithArray:tempList];
    return radomImageList;
}

+ (BOOL)isInOrderImageList:(NSArray<RRImageView *> *)imageList
              withOriginal:(NSArray<RRImage *> *)original {
    if (imageList.count != original.count) {
        return NO;
    }
    for (NSInteger i = 0; i < original.count; i++) {
        if (!RRPositionEqualToPositon(imageList[i].rrImage.position, original[i].position)) {
            return NO;
        }
    }
    return YES;
}

@end


@implementation RRImage

- (instancetype)initWithCGImage:(CGImageRef)cgImage position:(RRPosition)position {
    if (self = [super initWithCGImage:cgImage]) {
        self.position = position;
    }
    return self;
}

+ (RRImage *)imageWithImage:(UIImage *)image position:(RRPosition)position {
    return [[RRImage alloc] initWithCGImage:image.CGImage position:position];
}

+ (RRImage *)imageWithCGImage:(CGImageRef)cgImage position:(RRPosition)position {
    return [[self alloc] initWithCGImage:cgImage position:position];
}

@end
