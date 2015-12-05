//
//  RRLaticeView.h
//  StoryPuzzle
//
//  Created by Ryan on 15/12/3.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

@import UIKit;

@class RRLaticeView;
@protocol RRLaticeViewDelegate <NSObject>

- (void)latticeView:(RRLaticeView *)latticeView movedWithGestureRecognizer:(UIPanGestureRecognizer *)gesure;

@end

@interface RRLaticeView : UIView

@property (nonatomic, weak) id<RRLaticeViewDelegate> delegate;
@property (nonatomic, strong) NSArray<UIView *> *pieces;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) NSInteger count;

- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count;
- (UIView *)objectAtIndex:(NSUInteger)index;

@end
