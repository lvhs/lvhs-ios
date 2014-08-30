//
//  LHSlideViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 8/30/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHSlideViewController.h"

@interface LHSlideViewController () <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation LHSlideViewController

- (void)viewDidLoad
{
    self.view.hidden = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

@end