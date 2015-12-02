//
//  NewGameController.m
//  StoryPuzzle
//
//  Created by Ryan on 15/12/2.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

#import "NewGameController.h"

@interface NewGameController ()

@property (weak, nonatomic) IBOutlet UILabel *piecesNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *typeOfImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIButton *tapToSelectButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NewGameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)numberSelected:(UISlider *)sender {
}

- (IBAction)gameStarted:(UIButton *)sender {
}

- (IBAction)back:(id)sender {
}

- (IBAction)tapToSelectImage:(id)sender {
}

- (IBAction)selectImageFromLibrary:(UIButton *)sender {
}

@end