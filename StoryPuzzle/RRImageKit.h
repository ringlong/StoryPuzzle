//
//  RRImageKit.h
//  StoryPuzzle
//
//  Created by Vanessa on 15/11/23.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface RRImageKit : NSObject

+ (NSArray<UIImage *> *)separateImage:(UIImage *)image
                               byRows:(NSInteger)rows
                              columns:(NSInteger)columns
                         cacheQuality:(CGFloat)quality;

@end
