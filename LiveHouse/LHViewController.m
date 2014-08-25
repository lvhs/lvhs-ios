//
//  LHViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 8/25/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHViewController.h"

@interface LHViewController ()

- (void)showAgreementView;

@end

@implementation LHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 初回起動時
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"agreement"]) {
        
    }
    
    // set background image
    UIImage* image = [UIImage imageNamed:@"background.png"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imageView];
    [self.tableView setBackgroundView:imageView];
    
    FAKFontAwesome *menuIcon = [FAKFontAwesome barsIconWithSize:16];
    [menuIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithImage:[menuIcon imageWithSize:CGSizeMake(15, 15)] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = menuBtn;
    
    // set logo image
    UIImage* logo = [UIImage imageNamed:@"Logo"];
    UIImageView* logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = logoView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.backgroundColor = [UIColor clearColor];
}

- (void) showAgreementView {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:YES forKey:@"agreement"];
}

@end
