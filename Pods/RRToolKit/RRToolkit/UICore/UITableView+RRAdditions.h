//
//  UITableView+RRAdditions.h
//  RRToolkit
//
//  Created by Ryan on 14-6-12.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (RRAdditions)

// Quickly create a tableView.
+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                        dataSource:(id<UITableViewDataSource>)dataSource
                          delegate:(id<UITableViewDelegate>)delegate;

@end
