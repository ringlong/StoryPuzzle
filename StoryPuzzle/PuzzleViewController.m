//
//  PuzzleViewController.m
//  StoryPuzzle
//
//  Created by Vanessa on 15/12/2.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

#import "PuzzleViewController.h"
#import "UIImage+CWAdditions.h"
#import "RRLaticeView.h"
#import "RRPieceView.h"
#import "RRGroupView.h"
#import "Puzzle.h"
#import "Piece.h"
#import "ReactiveCocoa.H"
#import "RRToolkit.h"

@import QuartzCore;
@import AVFoundation;
@import MediaPlayer;

static const NSInteger PieceSize = 75;
static const CGFloat Padding = PieceSize * 0.15;
static const CGFloat DrawerSize = PieceSize + 1.8 * Padding - 10;

@interface PuzzleViewController ()<RRPieceViewDelegate, RRPieceViewDataSource, RRLaticeViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *drawerView;


@property (strong, nonatomic) RRLaticeView *latticeView;
@property (strong, nonatomic) RRPieceView *movingPiece;

@property (assign, nonatomic) BOOL loadingGame;
@property (assign, nonatomic) BOOL creatingGame;
@property (assign, nonatomic) BOOL puzzleCompete;
@property (assign, nonatomic) BOOL duringGame;

@property (assign, nonatomic) NSInteger numberOfPiecesInDrawer;
@property (assign, nonatomic) CGFloat drawerMargin;
@property (assign, nonatomic) CGPoint drawerFirstPoint;

@property (assign, nonatomic) NSInteger pieceNumber;
@property (assign, nonatomic) NSInteger numberOfSquare;
@property (assign, nonatomic) NSInteger firstPiecePlace;
@property (assign, nonatomic) NSInteger missedPieces;
@property (assign, nonatomic) NSInteger loadedPieces;

@property (assign, nonatomic) NSTimeInterval elapsedTime;
@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSInteger moves;
@property (assign, nonatomic) NSInteger rotations;
@property (strong, nonatomic) Puzzle *puzzle;
@property (strong, nonatomic) NSArray<NSNumber *> *directions_numbers;
@property (strong, nonatomic) NSArray<NSNumber *> *directions_positions;
@property (strong, nonatomic) NSMutableArray<RRPieceView *> *pieces;
@property (strong, nonatomic) NSMutableArray<RRGroupView *> *groups;

- (void)prepareForNewPuzzle;
- (void)computerPieceSize;
- (void)creatLattice;
- (void)createPuzzleFromSavedGame;
- (void)startNewGame;
- (void)createPuzzleFromImage:(UIImage *)image;
- (void)createPieces;
- (void)addPiecesToView;
- (NSArray<UIImage *> *)splitImage:(UIImage *)image partSize:(CGFloat)partSize;
- (Piece *)pieceOfCurrentPuzzle:(NSInteger)index;
- (void)resetLatticePositionAndSizeWithDuration:(CGFloat)duration;
- (void)resizeLatticeToScale:(CGFloat)newScale;
- (void)refreshPositions;

@end

@implementation PuzzleViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wood"]];
    self.pieceNumber = 4;
    [self startNewGame];
    [RACObserve(self, score) subscribeNext:^(NSNumber *x) {
        self.scoreLabel.text = x.stringValue;
    }];
}

- (void)setPieceNumber:(NSInteger)pieceNumber {
    _pieceNumber = pieceNumber;
    _numberOfSquare = pieceNumber^2;
    _firstPiecePlace = 3 * _numberOfSquare + _pieceNumber;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private Method

- (void)prepareForNewPuzzle {
    [self.view bringSubviewToFront:_latticeView];
    
    _missedPieces = 0;
    _loadedPieces = 0;
    
    if (!_loadingGame) {
        _elapsedTime = 0.0;
        _score = 0;
    }
    _directions_numbers = [self directions_numbers];
    _directions_positions = [self directions_positions];
    [self computerPieceSize];
    [self creatLattice];
    _drawerFirstPoint = CGPointMake(-4, 5);
}

- (void)computerPieceSize {
    _numberOfPiecesInDrawer = [UIScreen screenWidth] / (PieceSize + 1);
    CGFloat unusedSpace = [UIScreen screenWidth] - _numberOfPiecesInDrawer * PieceSize;
    _drawerMargin = unusedSpace / (_numberOfPiecesInDrawer + 1);
}

- (void)creatLattice {
    [_latticeView removeFromSuperview];
    
    CGFloat singleWidth = (PieceSize - 2 * Padding);
    CGFloat cubeWith = singleWidth * _pieceNumber;
    CGFloat latticeWidth = cubeWith * 3;
    CGRect latticeFrame = CGRectMake((self.view.width - cubeWith) / 2 - cubeWith, (self.view.height - cubeWith) / 2 + DrawerSize / 2 - cubeWith, latticeWidth, latticeWidth);
    
    _latticeView = [[RRLaticeView alloc] initWithFrame:latticeFrame count:_pieceNumber];
    _latticeView.delegate = self;
    _latticeView.scale = 1;
    [self.view addSubview:_latticeView];
    _latticeView.center = self.view.center;
//    [self resetLatticePositionAndSizeWithDuration:0];
}

- (NSArray *)directionsUpdated_numbers {
    // up = 0, right = 1, down = 2, left = 3
    return @[@(-1), @(_pieceNumber), @1, @(-_pieceNumber)];
}

- (NSArray*)directionsUpdated_positions {
    return @[@(-1), @(3 * _pieceNumber), @1, @(-3 * _pieceNumber)];
}

- (Piece *)pieceOfCurrentPuzzle:(NSInteger)index {
    for (Piece *piece in _puzzle.pieces) {
        if (piece.number.integerValue == index) {
            return piece;
        }
    }
    
    _missedPieces++;
    return nil;
}

- (void)removeOldPieces {
    for (RRPieceView *piece in _pieces) {
        [piece removeFromSuperview];
    }
    for (RRGroupView *group in _groups) {
        [group removeFromSuperview];
    }
}

- (void)startNewGame {
    _puzzleCompete = NO;
    [self removeOldPieces];
    
    self.groups = [NSMutableArray arrayWithCapacity:self.numberOfSquare];
    self.pieces = [NSMutableArray arrayWithCapacity:self.numberOfSquare];
    
    [self createPuzzleFromImage:_image];
    
//    [UIView animateWithDuration:0.2 animations:^{
//        CGFloat width = (PieceSize - 2 * Padding) * _pieceNumber;
//        _latticeView.frame = CGRectMake((self.view.width - width) / 2, (self.view.height - width) / 2 + DrawerSize / 2, width, width);
//    }];
    
}

- (void)createPuzzleFromImage:(UIImage *)image {
    _loadingGame = NO;
    _creatingGame = YES;
    _moves = 0;
    _rotations = 0;
    [self prepareForNewPuzzle];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createPieces];
        [self addPiecesToView];
    });
}

- (void)createPieces {
    CGFloat imageSizeBound = 3 * PieceSize;
    CGFloat shapeQuality = 1;
    
    NSMutableArray<RRPieceView *> *arrayPieces = [NSMutableArray arrayWithCapacity:_numberOfSquare];
    NSMutableArray *array = [NSMutableArray array];
    if (!self.image) {
        return;
    }
    
    if (!_loadingGame) {
        CGFloat partSize = _image.size.width / (_pieceNumber * 0.7);
        partSize = (partSize <= imageSizeBound) ? : imageSizeBound;
        
        CGFloat f = (_pieceNumber * partSize * 0.7);
        self.image = [self.image imageCroppedToSquareWithSide:f];
        array = [NSMutableArray arrayWithArray:[self splitImage:self.image partSize:partSize]];
    }
    
    for (int i = 0; i < _pieceNumber; i++) {
        for (int j = 0; j < _pieceNumber; j++) {
            CGRect rect = CGRectMake(0, 0, shapeQuality * PieceSize, shapeQuality * PieceSize);
            
            if (_loadingGame) {
                Piece *piece = [self pieceOfCurrentPuzzle:j + _pieceNumber * i];
                if (piece) {
                    RRPieceView *pieceView = [[RRPieceView alloc] initWithFrame:rect piece:piece];
                    pieceView.delegate = self;
                    pieceView.dataSource = self;
                    pieceView.number = j + _pieceNumber * i;
                    pieceView.size = PieceSize;
                    pieceView.image = [UIImage imageWithData:piece.image.data];
                    pieceView.neighbors = @[@(_numberOfSquare), @(_numberOfSquare), @(_numberOfSquare), @(_numberOfSquare)];
                    [arrayPieces addObject:pieceView];
                }
            } else {
                RRPieceView *pieceView = [[RRPieceView alloc] initWithFrame:rect];
                pieceView.delegate = self;
                pieceView.dataSource = self;
                pieceView.image = array[j + _pieceNumber * i];
                pieceView.number = j + _pieceNumber * i;
                pieceView.size = PieceSize;
                pieceView.position = -1;
                pieceView.neighbors = @[@(_numberOfSquare), @(_numberOfSquare), @(_numberOfSquare), @(_numberOfSquare)];
                
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:4];
                
                for (int k = 0; k < 4; k++) {
                    int e = arc4random_uniform(3) + 1;
                    
                    if (arc4random_uniform(2) > 0) {
                        e *= -1;
                    }
                    [temp addObject:@(e)];
                }
                
                if (i > 0) {
                    NSInteger l = arrayPieces.count - _pieceNumber;
                    NSInteger e = arrayPieces[l].edges[1].integerValue;
                    [temp replaceObjectAtIndex:3 withObject:@(-e)];
                }
                
                if (j > 0) {
                    NSInteger e = arrayPieces.lastObject.edges[2].integerValue;
                    [temp replaceObjectAtIndex:0 withObject:@(-e)];
                }
                
                if (i == 0) {
                    [temp replaceObjectAtIndex:3 withObject:@0];
                }
                
                if (i == _pieceNumber - 1) {
                    [temp replaceObjectAtIndex:1 withObject:@0];
                }
                
                if (j == 0) {
                    [temp replaceObjectAtIndex:0 withObject:@0];
                }
                
                if (j == _pieceNumber - 1) {
                    [temp replaceObjectAtIndex:2 withObject:@0];
                }
                
                pieceView.edges = [NSArray arrayWithArray:temp];
                [arrayPieces addObject:pieceView];
            }
            
        }
    }
    
    _pieces = [NSMutableArray arrayWithArray:arrayPieces];
    _drawerView.contentSize = CGSizeMake((15 + PieceSize) * _pieces.count, 0);
    _loadedPieces = 0;
}

- (NSArray<UIImage *> *)splitImage:(UIImage *)image partSize:(CGFloat)partSize {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:_numberOfSquare];
    CGFloat padding = partSize * 0.15;
    CGFloat left = partSize - 2 * padding;
    for (int i = 0; i < _pieceNumber; i ++) {
        for (int j = 0; j < _pieceNumber; j++) {
            CGRect rect = CGRectMake(i * left - padding , j * left - padding, partSize, partSize);
            [tempArray addObject:[image subimageWithRect:rect]];
        }
    }
    return [NSArray arrayWithArray:tempArray];
}

- (void)resetLatticePositionAndSizeWithDuration:(CGFloat)duration {
    CGFloat scale = [UIScreen screenWidth] / (_pieceNumber + 1) / (PieceSize - 2 * Padding);
    [UIView animateWithDuration:duration animations:^{
        [self resizeLatticeToScale:scale];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:duration animations:^{
            CGPoint center = [self.view convertPoint:[_latticeView objectAtIndex:_firstPiecePlace].center fromView:_latticeView];
            _latticeView.centerX = self.view.centerX;
            
            [self refreshPositions];
        }];
        
    }];
}

- (void)resizeLatticeToScale:(CGFloat)newScale {
    CGFloat ratio = newScale / _latticeView.scale;
    
    if (_latticeView.scale * ratio * 3 * _pieceNumber * (PieceSize - 2 * Padding) > [UIScreen screenWidth] &&
        _latticeView.scale * ratio * PieceSize < [UIScreen screenWidth]) {
        
        _latticeView.scale = newScale;
        
        _latticeView.transform = CGAffineTransformScale(_latticeView.transform, ratio, ratio);
        
        for (RRGroupView *g in self.groups) {
            
            g.transform = CGAffineTransformScale(g.transform, ratio, ratio);
        }
        
        [self refreshPositions];
    }
}

- (void)refreshPositions {
    
}

- (void)addPiecesToView {
    [self.pieces enumerateObjectsUsingBlock:^(RRPieceView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.origin = CGPointMake((15 + obj.width) * idx, 0);
        obj.centerY = self.drawerView.height / 2;
        [self.drawerView addSubview:obj];

    }];
    [self.view bringSubviewToFront:self.drawerView];
}

#pragma mark - Public Method

- (void)loadPuzzle:(Puzzle *)puzzle {
    _puzzle = puzzle;
    [self prepareForNewPuzzle];
    [self removeOldPieces];

    if (puzzle) {
        self.pieceNumber = puzzle.pieceNumber.integerValue;
        self.image = [UIImage imageWithData:puzzle.image.data];
        self.groups = [NSMutableArray arrayWithCapacity:_numberOfSquare / 2];
        self.elapsedTime = puzzle.elapsedTime.floatValue;
        self.percentageLabel.text = [NSNumberFormatter localizedStringFromNumber:puzzle.percentage numberStyle:NSNumberFormatterPercentStyle];
        self.moves = puzzle.moves.integerValue;
        self.rotations = puzzle.rotations.integerValue;
        self.score = puzzle.score.integerValue;
        self.scoreLabel.text = @(self.score).stringValue;
        
        if (puzzle.percentage.integerValue == 100) {
            _puzzleCompete = YES;
            return;
        }
        [self createPuzzleFromSavedGame];
    } else {
        //TODO:开始新游戏
        [self startNewGame];
    }
}

#pragma mark - RRLaticeViewDelegate

- (void)latticeView:(RRLaticeView *)latticeView movedWithGestureRecognizer:(UIPanGestureRecognizer *)gesure {
    CGPoint location = [gesure locationInView:self.view];
    if (CGRectContainsPoint(self.drawerView.frame, location)) {
        return;
    }
    if (gesure.state == UIGestureRecognizerStateBegan) {
        _movingPiece = nil;
        //TODO:move piece
    }
    CGPoint translation = [gesure translationInView:self.view];
    
    _latticeView.transform = CGAffineTransformTranslate(_latticeView.transform, translation.x / _latticeView.scale, translation.y / _latticeView.scale);
    [self refreshPositions];
    [gesure setTranslation:CGPointZero inView:self.view];
}

@end
