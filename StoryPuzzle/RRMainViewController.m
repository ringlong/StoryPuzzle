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

static const CGFloat RRImageViewMagin = 5;

static const NSInteger RRImageViewTag = 100;
static const NSInteger RRImageViewRowCount = 3;
static const NSInteger RRImageViewColumnCount = 3;

@interface RRMainViewController ()<RRImageViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) UIImageView *templeImage;
@property (nonatomic, strong) RRImageView *imageView;

- (void)upchange:(UIImageView *)image;
- (void)leftchange:(UIImageView *)image;
- (void)rightchange:(UIImageView *)image;
- (void)downchange:(UIImageView *)image;

@end

@implementation RRMainViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray<UIImage *> *imageList = [RRImageKit separateImage:[UIImage imageNamed:@"Sweat"] byRows:RRImageViewRowCount columns:RRImageViewColumnCount cacheQuality:1];
    [imageList enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        RRImageView *itemImage = [[RRImageView alloc] initWithImage:image];
        itemImage.tag = RRImageViewTag + idx;
        
        NSInteger row = idx / RRImageViewColumnCount;
        NSInteger column = idx % RRImageViewRowCount;
        
        CGFloat width = (self.containerView.width - (RRImageViewColumnCount - 1) * RRImageViewMagin) / RRImageViewColumnCount;
        CGFloat height = (self.containerView.height - (RRImageViewRowCount - 1) * RRImageViewMagin) / RRImageViewRowCount;
        
        itemImage.frame = CGRectMake(row * (width + RRImageViewMagin), column * (height + RRImageViewMagin), width, height);
        
        [self.containerView addSubview:itemImage];
    }];
}

#pragma mark - Private Methods

- (void)upchange:(UIImageView *)image {
    
}

- (void)leftchange:(UIImageView *)image {
    
}

- (void)rightchange:(UIImageView *)image {
    
}

- (void)downchange:(UIImageView *)image {
    
}

#pragma mark - RRImageViewDelegate

- (void)moveAction:(UIImageView *)imageView {
    
}

@end
