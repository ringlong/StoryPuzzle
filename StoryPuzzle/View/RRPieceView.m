//
//  RRPieceView.m
//  StoryPuzzle
//
//  Created by Vanessa on 15/11/30.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

#import "RRPieceView.h"
#import "RRToolkit.h"
#import "Piece.h"

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

- (instancetype)initWithFrame:(CGRect)frame piece:(Piece *)piece {
    if (self = [self initWithFrame:frame]) {
        _isFree = piece.isFree.boolValue;
        _position = piece.position.integerValue;
        _angle = piece.angle.floatValue;
        _moves = piece.moves.integerValue;
        _edges = @[piece.edge0, piece.edge1, piece.edge2, piece.edge3];
        self.transform = CGAffineTransformMakeRotation(piece.angle.floatValue);
    }
    return self;
}

- (void)awakeFromNib {
    [self configure];
}

#pragma mark - Pubulic Methods

- (CGPoint)realCenter {
    return CGPointMake(self.left + self.width / 2, self.top + self.height / 2);
}

- (NSInteger)edgeNumber:(NSInteger)number {
    return _edges[number].integerValue;
}

- (void)setNeighborNumber:(NSInteger)neighborNumber forEdge:(NSInteger)edge {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i = 0; i < 4; i++) {
        if (i == edge) {
            [tempArray addObject:@(neighborNumber)];
        } else {
            [tempArray addObject:_neighbors[i]];
        }
    }
    _neighbors = [NSArray arrayWithArray:tempArray];
    _hasNeighbors = YES;
}

- (BOOL)isCompleted {
    for (NSNumber *number in self.neighbors) {
        if (number.integerValue == [_dataSource numberOfSquare]) {
            return NO;
        }
    }
    return YES;
}

- (NSArray *)allTheNeighborsButExcluded:(NSMutableArray *)excluded {
    if (!excluded) {
        excluded = [NSMutableArray array];
    }
    [excluded addObject:self];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[_dataSource numberOfSquare] - 1];
    
    [_neighbors enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.integerValue < [_dataSource numberOfSquare]) {
            RRPieceView *otherPieceView = [_dataSource pieceViewWithNumber:obj.integerValue];
            
            BOOL present = NO;
            
            for (RRPieceView *pieceView in excluded) {
                if (otherPieceView.number == pieceView.number) {
                    present = YES;
                }
            }
            
            if (!present) {
                [tempArray addObject:otherPieceView];
            }
        }
    }];
    [excluded addObjectsFromArray:tempArray];
    
    for (RRPieceView *p in tempArray.mutableCopy) {
        [tempArray addObjectsFromArray:[p allTheNeighborsButExcluded:excluded]];
    }
    
    return [NSArray arrayWithArray:tempArray];
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
#define CO_PADDING 0

- (void)drawRect:(CGRect)rect {
    //TODO: delegate
    _padding = self.width * 0.15;
    CGFloat lineWidth = self.width * 0.005;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0.2);
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, self.padding, self.padding);
    
    [_edges enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self drawEdgeNumber:idx + 1 ofEdge:obj.integerValue inContext:ctx];
    }];
    
    CGContextClip(ctx);
    [_image drawInRect:self.bounds];
    
    CGContextBeginPath(ctx);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //TODO: delegate
}

- (void)drawEdgeNumber:(NSInteger)number ofEdge:(NSInteger)edge inContext:(CGContextRef)ctx {
    BOOL vertical = NO;
    int sign = 1;
    
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
    
    if (edge < 0) {
        sign *= -1;
    }
    
    CGFloat l = vertical ? self.height : self.width;
    CGFloat l3 = (l - 2 * self.padding) / 3;
    
    CGPoint point = [self pointA:a plusPointB:b firstWeight:2.0 / 3.0];
    CGContextAddLineToPoint(ctx, point.x, point.y);
    
    NSInteger absEdge = ABS(edge);
    if (absEdge == 1) {
        // Triangle
        CGPoint p2 = [self pointA:a plusPointB:b firstWeight:1.0 / 2.0];
    
        if (vertical) {
            p2 = [self pointA:p2 plusPointB:CGPointMake(0, sign * (_padding - CO_PADDING))];
        } else {
            p2 = [self pointA:p2 plusPointB:CGPointMake(sign * (_padding - CO_PADDING), 0)];
        }
        CGContextAddLineToPoint(ctx, p2.x, p2.y);
        
        CGPoint p3 = [self pointA:a plusPointB:b firstWeight:1.0 / 3.0];
        CGContextAddLineToPoint(ctx, p3.x, p3.y);
    } else if (absEdge == 2) {
        CGPoint p2 = [self pointA:a plusPointB:b firstWeight:1.0 / 2.0];
        CGFloat radius = (l - 2 * _padding) / 6;
        switch (number) {
            case 1:
                CGContextAddArc(ctx, p2.x, p2.y, radius, M_PI, 0, sign + 1);
                break;
            case 2:
                CGContextAddArc(ctx, p2.x, p2.y, radius, M_PI_2 * 3, M_PI_2, sign - 1);
                break;
            case 3:
                CGContextAddArc(ctx, p2.x, p2.y, radius, 0, M_PI, sign - 1);
                break;
            case 4:
                CGContextAddArc(ctx, p2.x, p2.y, radius, M_PI_2, M_PI_2 * 3, sign + 1);
                break;
            default:
                break;
        }
    } else if (absEdge == 3) {
        CGPoint p2 = point;
        CGPoint p3 = point;
        CGPoint p4 = point;
        
        switch (number) {
            case 1:
                p2 = [self pointA:p2 plusPointB:CGPointMake(0, sign * (_padding - CO_PADDING))];
                p3 = [self pointA:p2 plusPointB:CGPointMake(l3, 0)];
                p4 = [self pointA:point plusPointB:CGPointMake(l3, 0)];
                break;
            case 2:
                p2 = [self pointA:p2 plusPointB:CGPointMake(sign * (_padding - CO_PADDING), 0)];
                p3 = [self pointA:p2 plusPointB:CGPointMake(0, l3)];
                p4 = [self pointA:point plusPointB:CGPointMake(0, l3)];
                break;
            case 3:
                p2 = [self pointA:p2 plusPointB:CGPointMake(0, sign * (_padding - CO_PADDING))];
                p3 = [self pointA:p2 plusPointB:CGPointMake(-l3, 0)];
                p3 = [self pointA:point plusPointB:CGPointMake(-l3, 0)];
                break;
            case 4:
                p2 = [self pointA:p2 plusPointB:CGPointMake(sign * (_padding - CO_PADDING), 0)];
                p3 = [self pointA:p2 plusPointB:CGPointMake(0, -l3)];
                p4 = [self pointA:point plusPointB:CGPointMake(0, -l3)];
                break;
            default:
                break;
        }
        
        CGContextAddLineToPoint(ctx, p2.x, p2.y);
        CGContextAddLineToPoint(ctx, p3.x, p3.y);
        CGContextAddLineToPoint(ctx, p4.x, p4.y);
    } else {
        point = [self pointA:a plusPointB:b firstWeight:1.0 / 3.0];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
    
    CGContextAddLineToPoint(ctx, b.x, b.y);
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

- (void)moveNeighborhoodExcludingPieces:(NSMutableArray *)excluded withVector:(CGPoint)traslation {
    [_neighbors enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.integerValue < [_dataSource numberOfSquare]) {
            RRPieceView *pieceView = [_dataSource pieceViewWithNumber:obj.integerValue];
            BOOL present = NO;
            
            for (RRPieceView *piece in excluded) {
                if (piece == pieceView) {
                    present = YES;
                }
            }
            
            if (!present) {
                [pieceView translateWithVector:traslation];
                [excluded addObject:pieceView];
                [pieceView moveNeighborhoodExcludingPieces:excluded withVector:traslation];
                if ([_delegate respondsToSelector:@selector(pieceViewMoved:)] &&
                    CGPointEqualToPoint(traslation, CGPointZero)) {
                    [_delegate pieceViewMoved:pieceView];
                }
            }
        }
    }];
}

- (void)moveNeighborhoodExcludingPieces:(NSMutableArray *)excluded {
    [self moveNeighborhoodExcludingPieces:excluded withVector:CGPointZero];
}

- (BOOL)areTherePiecesBeingRotated {
    for (RRPieceView *pieceView in [_dataSource pieces]) {
        if (pieceView.isRotating && !pieceView.isFree) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Gesture Method

- (void)move:(UIPanGestureRecognizer *)gesture {
    if (!self.userInteractionEnabled) {
        return;
    }
    if ([_dataSource imageView].alpha == 1) {
//        [_delegate toggleImageWithDuration:0.5];
    }
//    CGPoint traslation = [gesture translationInView:self.superview];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.superview bringSubviewToFront:self];
        _oldPosition = [self realCenter];
        _tr = 0;
        //TODO:drawerStopped
    }
    
    if (_isFree || _isLifted) {
//        NSMutableArray *excluded = @[self].mutableCopy;
        //TODO: group
        
        [gesture setTranslation:CGPointZero inView:self.superview];
        
        if (gesture.state == UIGestureRecognizerStateEnded) {
            //TODO:group
        }
    } else {
        // Inside the Drawer
        
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
