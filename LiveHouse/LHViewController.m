//
//  LHViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 8/25/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHViewController.h"

@interface LHViewController ()

@end

@implementation LHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIImage* image = [UIImage imageNamed:@"background.png"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imageView];
    [self.tableView setBackgroundView:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.backgroundColor = [UIColor clearColor];
}

@end
