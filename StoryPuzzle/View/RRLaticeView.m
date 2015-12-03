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
        
        CGFloat width = frame.size.width / count;
        CGFloat padding = 2.0;
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:count^2];
        
        for (int i = 0; i < 3 * count; i++) {
            for (int j = 0; j < 3 * count; j++) {
                CGRect rect = CGRectMake(i * width - padding, j * width - padding, width - 2 * padding, width - 2 * padding);
                UIView *view = [[UIView alloc] initWithFrame:rect];
                
                view.backgroundColor = [UIColor blackColor];
                
                if (i >= count && i < 2 * count && j >= count && j < 2 * count) {
                    view.alpha = .2;
                } else {
                    view.alpha = .05;
                }
                
                [tempArray addObject:view];
                [self addSubview:view];
            }
        }
        _pieces = [NSArray arrayWithArray:tempArray];
    }
    return self;
}

- (UIView *)objectAtIndex:(NSUInteger)index {
    if (index > (_count^2) * 9 - 1) {
        return nil;
    }
    return _pieces[index];
}
@end
