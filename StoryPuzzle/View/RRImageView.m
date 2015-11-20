//
//  RRImageView.m
//  StoryPuzzle
//
//  Created by Ryan on 15/11/20.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

#import "RRImageView.h"

@implementation RRImageView

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super initWithImage:image]) {
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        self.layer.borderColor = [UIColor lightTextColor].CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(moveAction:)]) {
        [self.delegate moveAction:self];
    }
}

@end
