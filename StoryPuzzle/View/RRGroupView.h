//
//  RRGroupView.h
//  StoryPuzzle
//
//  Created by Ryan on 15/12/2.
//  Copyright © 2015年 BitAuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRPieceView.h"

@interface RRGroupView : RRPieceView

@property (nonatomic, strong) RRPieceView *boss;
@property (nonatomic, strong) NSMutableArray<RRPieceView *> *pieces;

@property (nonatomic) BOOL isPostioned;

@end
