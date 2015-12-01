//
//  RRPieceView.h
//  StoryPuzzle
//
//  Created by Vanessa on 15/11/30.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

@import UIKit;

@protocol RRPieceViewDelegate <NSObject>

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end

@interface RRPieceView : UIView<RRPieceViewDelegate>

@property (nonatomic, weak) id<RRPieceViewDelegate> delegate;

@property (nonatomic, strong) NSArray<NSNumber *> *edges;
@property (nonatomic, strong) NSArray *neighbors;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic) CGPoint oldPosition;

@property (nonatomic) BOOL isPositioned;
@property (nonatomic) BOOL isLifted;
@property (nonatomic) BOOL isFree;
@property (nonatomic) BOOL isRotating;
@property (nonatomic) BOOL isBoss;
@property (nonatomic) BOOL hasNeighbors;

@property (nonatomic) NSInteger number;
@property (nonatomic) NSInteger position;
@property (nonatomic) NSInteger positionInDrawer;
@property (nonatomic) NSInteger moves;
@property (nonatomic) NSInteger rotations;

@property (nonatomic) CGFloat angle;
@property (nonatomic) CGFloat size;
@property (nonatomic) CGFloat padding;
@property (nonatomic) CGFloat tempAngle;

- (void)move:(UIPanGestureRecognizer *)gesture;
- (void)rotate:(UIRotationGestureRecognizer *)gesture;
- (void)rotateTap:(UITapGestureRecognizer *)gesture;

- (NSInteger)edgeNumber:(NSInteger)number;
- (void)setNeighborNumber:(NSInteger)neighborNumber forEdge:(NSInteger)edge;
- (NSArray *)allTheNeighborsButExcluded:(NSMutableArray *)excluded;
- (CGPoint)realCenter;
- (void)pulse;
- (BOOL)isCompleted;

+ (CGFloat)computeFloat:(CGFloat)f modulo:(CGFloat)m;
@end
