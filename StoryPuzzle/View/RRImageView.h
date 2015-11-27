//
//  RRImageView.h
//  StoryPuzzle
//
//  Created by Ryan on 15/11/20.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

@import UIKit;

@protocol RRImageViewDelegate <NSObject>

- (void)moveAction:(UIImageView *)imageView;

@end

@class RRImage;

@interface RRImageView : UIImageView

@property (nonatomic, strong) RRImage *rrImage;
@property (nonatomic, weak) id<RRImageViewDelegate> delegate;

@end
