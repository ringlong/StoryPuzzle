//
//  UITableView+RRAdditions.m
//  RRToolkit
//
//  Created by Ryan on 14-6-12.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "UITableView+RRAdditions.h"

@implementation UITableView (RRAdditions)

+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                        dataSource:(id<UITableViewDataSource>)dataSource
                          delegate:(id<UITableViewDelegate>)delegate
{
    UITableView *tableView = [[[self class] alloc] initWithFrame:frame style:style];
    tableView.dataSource = dataSource;
    tableView.delegate = delegate;
    return tableView;
}

@end
