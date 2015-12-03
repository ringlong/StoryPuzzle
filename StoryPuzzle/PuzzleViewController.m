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
#import "ReactiveCocoa.H"
#import "RRToolkit.h"

@import QuartzCore;
@import AVFoundation;
@import MediaPlayer;

static const NSInteger PieceSize = 75;
static const CGFloat Padding = PieceSize * 0.15;
static const CGFloat DrawerSize = PieceSize + 1.8 * Padding - 10;

@interface PuzzleViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;

@property (strong, nonatomic) RRLaticeView *latticeView;

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

@property (assign, nonatomic) NSTimeInterval elapsedTime;
@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSInteger moves;
@property (assign, nonatomic) NSInteger rotations;
@property (strong, nonatomic) Puzzle *puzzle;
@property (strong, nonatomic) NSArray<NSNumber *> *directions_numbers;
@property (strong, nonatomic) NSArray<NSNumber *> *directions_positions;
@property (strong, nonatomic) NSMutableArray<RRPieceView *> *pieces;
@property (strong, nonatomic) NSMutableArray<RRGroupView *> *groups;
@property (strong, nonatomic) UIImage *image;

- (void)prepareForNewPuzzle;
- (void)computerPieceSize;
- (void)creatLattice;
- (void)createPuzzleFromSavedGame;
- (void)startNewGame;
- (void)createPuzzleFromImage:(UIImage *)image;
- (void)createPieces;
- (void)addAnothePieceToView;
- (NSArray<UIImage *> *)splitImage:(UIImage *)image partSize:(CGFloat)partSize;

@end

@implementation PuzzleViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setPieceNumber:(NSInteger)pieceNumber {
    _pieceNumber = pieceNumber;
    _numberOfSquare = pieceNumber^2;
    _firstPiecePlace = 3 * _numberOfSquare + _pieceNumber;
}

#pragma mark - Private Method

- (void)prepareForNewPuzzle {
    [self.view bringSubviewToFront:_latticeView];
    
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
    
    CGFloat width = (PieceSize - 2 * Padding) * _pieceNumber;
    CGRect latticeFrame = CGRectMake((self.view.width - width) / 2, (self.view.height - width) / 2 + DrawerSize / 2, width, width);
    
    _latticeView = [[RRLaticeView alloc] initWithFrame:latticeFrame count:_pieceNumber];
    _latticeView.scale = 1;
    [self.view addSubview:_latticeView];
}

- (NSArray *)directionsUpdated_numbers {
    // up = 0, right = 1, down = 2, left = 3
    return @[@(-1), @(_pieceNumber), @1, @(-_pieceNumber)];
}

- (NSArray*)directionsUpdated_positions {
    return @[@(-1), @(3 * _pieceNumber), @1, @(-3 * _pieceNumber)];
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
    
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat width = (PieceSize - 2 * Padding) * _pieceNumber;
        _latticeView.frame = CGRectMake((self.view.width - width) / 2, (self.view.height - width) / 2 + DrawerSize / 2, width, width);
    }];
    
}

- (void)createPuzzleFromImage:(UIImage *)image {
    _loadingGame = NO;
    _creatingGame = YES;
    _moves = 0;
    _rotations = 0;
    [self prepareForNewPuzzle];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createPieces];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addAnothePieceToView];
        });
    });
}

- (void)createPieces {
    CGFloat imageSizeBound = 3 * PieceSize;
    CGFloat shapeQuality = 3;
    
    NSMutableArray<RRPieceView *> *arrayPieces = [NSMutableArray arrayWithCapacity:_numberOfSquare];
    NSMutableArray *array = [NSMutableArray array];
    if (!self.image) {
        return;
    }
    
    if (!_loadingGame) {
        CGFloat partSize = _image.size.width / (_pieceNumber * 0.7);
        partSize = partSize <= imageSizeBound ? : imageSizeBound;
        
        CGFloat f = (_pieceNumber * partSize * 0.7);
        self.image = [self.image imageCroppedToSquareWithSide:f];
        array = [NSMutableArray arrayWithArray:[self splitImage:self.image partSize:partSize]];
    }
}

- (NSArray<UIImage *> *)splitImage:(UIImage *)image partSize:(CGFloat)partSize {
    return nil;
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

@end
