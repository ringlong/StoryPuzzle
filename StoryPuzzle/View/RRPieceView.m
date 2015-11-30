//
//  RRPieceView.m
//  StoryPuzzle
//
//  Created by Vanessa on 15/11/30.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

#import "RRPieceView.h"
#import "RRToolkit.h"

@interface RRPieceView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat tr;

- (void)configure;
- (BOOL)isNeighborOf:(RRPieceView *)pieceView;

@end

@implementation RRPieceView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}

- (void)awakeFromNib {
    [self configure];
}

#pragma mark - Private Methods

- (void)configure {
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    _pan.minimumNumberOfTouches = 1;
    _pan.maximumNumberOfTouches = 1;
    _pan.delegate = self;
    _pan.delaysTouchesBegan = YES;
    [self addGestureRecognizer:_pan];
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [self addGestureRecognizer:rotation];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rotateTap:)];
    tap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tap];
    
    self.backgroundColor = [UIColor clearColor];
}

- (BOOL)isNeighborOf:(RRPieceView *)pieceView {
    for (RRPieceView *piece in [self allTheNeighborsButExcluded:nil]) {
        if (piece.number == pieceView.number) {
            return YES;
        }
    }
    return NO;
}

- (void)pulse {
    
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
}

- (void)drawEdgeNumber:(NSInteger)number ofEdge:(NSInteger)edge inContext:(CGContextRef)ctx {
    BOOL vertical = NO;
    NSInteger sign = 1;
    
    CGPoint a = CGPointZero;
    CGPoint b = CGPointZero;
    
    switch (number) {
        case 1:
            a = CGPointMake(_padding, _padding);
            b = CGPointMake(self.width - _padding, _padding);
            vertical = YES;
            sign = -1;
            break;
        case 2:
            a = CGPointMake(self.width - _padding, _padding);
            b = CGPointMake(self.width - _padding, self.height - _padding);
            sign = 1;
            break;
        case 3:
            a = CGPointMake(self.width - _padding, self.height - _padding);
            b = CGPointMake(_padding, self.height - _padding);
            vertical = YES;
            sign = 1;
            break;
        case 4:
            a = CGPointMake(_padding, self.height - _padding);
            b = CGPointMake(_padding, _padding);
            sign = -1;
            break;
        default:
            break;
    }
}

#pragma mark - Gesture Hanlding

- (CGPoint)pointA:(CGPoint)a plusPointB:(CGPoint)b {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

- (CGPoint)pointA:(CGPoint)a plusPointB:(CGPoint)b firstWeight:(CGFloat)wight {
    return CGPointMake(wight * a.x + (1 - wight) * b.x,
                       wight * a.y + (1 - wight) * b.y);
}

- (void)translateWithVector:(CGPoint)traslation {
    self.origin = [self pointA:self.origin plusPointB:traslation];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint new = CGPointMake(view.width * anchorPoint.x, view.height * anchorPoint.y);
    CGPoint old = CGPointMake(view.width * view.layer.anchorPoint.x,
                              view.height * view.layer.anchorPoint.y);
    
    new = CGPointApplyAffineTransform(new, view.transform);
    old = CGPointApplyAffineTransform(old, view.transform);
    
    CGPoint position = view.layer.position;
    position.x -= old.x;
    position.x += new.x;
    
    position.y -= old.y;
    position.y += new.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

+ (CGFloat)computeFloat:(CGFloat)f modulo:(CGFloat)m {
    
    CGFloat result = f - floor(f / m) * m;
    
    if (result > m - 0.2) {
        result = 0;
    }
    
    if (result < 0) {
        result = 0;
    }
    return result;
}

#pragma mark - Gesture Method

- (void)move:(UIPanGestureRecognizer *)gesture {
    if (!self.userInteractionEnabled) {
        return;
    }
}

- (void)rotate:(UIRotationGestureRecognizer *)gesture {
    if (self.hasNeighbors) {
        return;
    }
    CGFloat rotation = gesture.rotation;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            NSInteger t = floorf(ABS(_tempAngle) / M_PI_4);
            t = (t + (t & 1)) / 2;
            rotation = _tempAngle / ABS(_tempAngle) * t * M_PI_2 - _tempAngle;
            _angle += rotation;
            _angle = [RRPieceView computeFloat:_angle modulo:2 * M_PI];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.transform = CGAffineTransformRotate(self.transform, rotation);
            } completion:^(BOOL finished) {
                self.isRotating = NO;
                //TODO:delegate
            }];
            
            _tempAngle = 0;
            
        }
            break;
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            self.isRotating = YES;
            self.transform = CGAffineTransformRotate(self.transform, rotation);
            _tempAngle += rotation;
            _angle += rotation;
            //TODO:delegate
        }
            break;
        default:
            break;
    }
}

- (void)rotateTap:(UITapGestureRecognizer *)gesture {
    if (!self.userInteractionEnabled) {
        return;
    }
    _angle += M_PI_2;
    _angle = [RRPieceView computeFloat:_angle modulo:2 * M_PI];
    
    //TODO:Group View
}

#pragma mark - Touch Method

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(touchesBegan:withEvent:)]) {
        [self.delegate touchesBegan:touches withEvent:event];
    }
}

@end
