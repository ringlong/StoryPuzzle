//
//  PuzzleViewController.h
//  StoryPuzzle
//
//  Created by Vanessa on 15/12/2.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

@import UIKit;
@class Puzzle;

@interface PuzzleViewController : UIViewController

@property (strong, nonatomic) UIImage *image;

- (void)loadPuzzle:(Puzzle *)puzzle;

@end
