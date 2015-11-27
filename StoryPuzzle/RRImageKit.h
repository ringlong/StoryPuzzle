//
//  RRImageKit.h
//  StoryPuzzle
//
//  Created by Vanessa on 15/11/23.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

@import Foundation;
@import UIKit;

struct RRPosition {
    NSInteger xPosition;
    NSInteger yPosition;
};
typedef struct RRPosition RRPosition;

CG_INLINE RRPosition
RRPositionMake(NSInteger x, NSInteger y) {
    RRPosition position;
    position.xPosition = x;
    position.yPosition = y;
    return position;
}

CG_EXTERN bool RRPositionEqualToPositon(RRPosition position1, RRPosition position2);


@interface RRImage : UIImage

@property (nonatomic, assign) RRPosition position;

+ (RRImage *)imageWithImage:(UIImage *)image position:(RRPosition)position;

+ (RRImage *)imageWithCGImage:(CGImageRef)cgImage position:(RRPosition)position;

@end

@class RRImageView;

@interface RRImageKit : NSObject

+ (NSArray<RRImage *> *)separateImage:(UIImage *)image
                               byRows:(NSInteger)rows
                              columns:(NSInteger)columns
                         cacheQuality:(CGFloat)quality;

+ (NSArray<RRImage *> *)radomImageListWithOriginalImageList:(NSArray<RRImage *> *)originalImageList;

+ (BOOL)isInOrderImageList:(NSArray<RRImageView *> *)imageList
              withOriginal:(NSArray<RRImage *> *)original;

@end


