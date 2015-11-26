//
//  ViewController.m
//  StoryPuzzle
//
//  Created by Ryan on 15/11/20.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

#import "RRMainViewController.h"
#import "RRImageView.h"
#import "RRImageKit.h"
#import "RRToolkit.h"

static const CGFloat RRImageViewMagin = 0;

static const NSInteger RRImageViewTag = 100;
static const NSInteger RRImageViewRowCount = 3;
static const NSInteger RRImageViewColumnCount = 3;

@interface RRMainViewController ()<RRImageViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) UIView *plactholder;
@property (nonatomic, strong) RRImageView *imageView;

@property (nonatomic, strong) NSArray<UIView *> *originalImageViewList;
@property (nonatomic, strong) NSMutableArray<UIView *> *currentImageViewList;

- (void)imageView:(UIImageView *)imageView changeWithDirection:(RRMoveDirection)direction;

- (void)changeFrameOfView:(UIView *)view withView:(UIView *)otherView;

@end

@implementation RRMainViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray<UIImage *> *imageList = [RRImageKit separateImage:[UIImage imageNamed:@"Sweat"] byRows:RRImageViewRowCount columns:RRImageViewColumnCount cacheQuality:1];
    _currentImageViewList = [NSMutableArray arrayWithCapacity:imageList.count];
    [imageList enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        RRImageView *itemImage = [[RRImageView alloc] initWithImage:image];
        itemImage.delegate = self;
        itemImage.tag = RRImageViewTag + idx;
        
        NSInteger row = idx / RRImageViewColumnCount;
        NSInteger column = idx % RRImageViewRowCount;
        
        CGFloat width = (self.containerView.width - (RRImageViewColumnCount - 1) * RRImageViewMagin) / RRImageViewColumnCount;
        CGFloat height = (self.containerView.height - (RRImageViewRowCount - 1) * RRImageViewMagin) / RRImageViewRowCount;
        CGRect frame = CGRectMake(column * (width + RRImageViewMagin), row * (height + RRImageViewMagin), width, height);
        if (idx != RRImageViewRowCount * RRImageViewColumnCount - 1) {
            itemImage.frame = frame;
            [self.containerView addSubview:itemImage];
            [_currentImageViewList addObject:itemImage];
        } else {
            self.plactholder = [[UIView alloc] initWithFrame:frame];
            self.plactholder.tag = RRImageViewTag + idx;
            [self.containerView addSubview:self.plactholder];
            [_currentImageViewList addObject:self.plactholder];
        }
    }];
}

#pragma mark - Private Methods

- (void)imageView:(UIImageView *)imageView changeWithDirection:(RRMoveDirection)direction {
    if (direction != RRMoveDirectionNone) {
        [UIView animateWithDuration:0.3 animations:^{
            [self changeFrameOfView:imageView withView:self.plactholder];
        } completion:^(BOOL finished) {
            if (finished) {
                __block BOOL isSuccessed = YES;
                [_currentImageViewList enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx + 1 < _currentImageViewList.count) {
                        UIView *nextObject = _currentImageViewList[idx + 1];
                        if (obj.tag > nextObject.tag) {
                            isSuccessed = NO;
                        }
                    }
                }];
                
                if (isSuccessed) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"老婆" message:@"我爱你=。=" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [alert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            
        }];
    }
}

- (void)changeFrameOfView:(UIView *)view withView:(UIView *)otherView {
    CGRect frame = view.frame;
    view.frame = otherView.frame;
    otherView.frame = frame;
    
    // 交换在数组中的位置
    NSInteger originalIndex = [_currentImageViewList indexOfObject:view];
    NSInteger otherIndex = [_currentImageViewList indexOfObject:otherView];
    
    [_currentImageViewList removeObject:otherView];
    [_currentImageViewList insertObject:otherView atIndex:originalIndex];

    [_currentImageViewList removeObject:view];
    [_currentImageViewList insertObject:view atIndex:otherIndex];
}

#pragma mark - RRImageViewDelegate

- (void)moveAction:(UIImageView *)imageView {
    RRMoveDirection direction = RRMoveDirectionNone;
    
    if (roundf(_plactholder.left) == roundf(imageView.right + RRImageViewMagin) &&
        _plactholder.top == imageView.top) {
        direction = RRMoveDirectionRight;
    }
    
    if (roundf(_plactholder.right) == roundf(imageView.left - RRImageViewMagin) &&
        _plactholder.top == imageView.top) {
        direction = RRMoveDirectionLeft;
    }
    
    if (_plactholder.left == imageView.left &&
        roundf(_plactholder.top) == roundf(imageView.bottom + RRImageViewMagin)) {
        direction = RRMoveDirectionDown;
    }
    
    if (_plactholder.left == imageView.left &&
        roundf(_plactholder.bottom) == roundf(imageView.top - RRImageViewMagin)) {
        direction = RRMoveDirectionUp;
    }
    
    [self imageView:imageView changeWithDirection:direction];
}

@end
