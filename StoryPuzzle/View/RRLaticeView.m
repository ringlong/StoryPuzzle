//
//  RRLaticeView.m
//  StoryPuzzle
//
//  Created by Ryan on 15/12/3.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

#import "RRLaticeView.h"

@implementation RRLaticeView

- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count {
    if (self = [super initWithFrame:frame]) {
        _count = count;
        _scale = 1;
        
        CGFloat width = frame.size.width / (count * 3);
        CGFloat padding = 2.0;
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:count^2];
        
        for (int i = 0; i < 3 * count; i++) {
            for (int j = 0; j < 3 * count; j++) {
                CGRect rect = CGRectMake(i * width - padding, j * width - padding, width - 2 * padding, width - 2 * padding);
                UIView *view = [[UIView alloc] initWithFrame:rect];
                
                view.backgroundColor = [UIColor whiteColor];
                
                if (i >= count && i < 2 * count && j >= count && j < 2 * count) {
                    view.alpha = .5;
                } else {
                    view.alpha = .1;
                }
                
                [tempArray addObject:view];
                [self addSubview:view];
            }
        }
        _pieces = [NSArray arrayWithArray:tempArray];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.minimumNumberOfTouches = 1;
        pan.maximumNumberOfTouches = 2;
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (UIView *)objectAtIndex:(NSUInteger)index {
    if (index > (_count^2) * 9 - 1) {
        return nil;
    }
    return _pieces[index];
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    if ([_delegate respondsToSelector:@selector(latticeView:movedWithGestureRecognizer:)]) {
        [_delegate latticeView:self movedWithGestureRecognizer:gesture];
    }
}

@end
