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
    
//    // 初回起動時
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if (![defaults boolForKey:@"agreement"]) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"規約" message:@"あとでやる" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//        [alertView show];
//        [defaults setBool:YES forKey:@"agreement"];
//    }
//    
//    // set background image
//    UIImage* image = [UIImage imageNamed:@"background.png"];
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
//    [self.view addSubview:imageView];
//    [self.tableView setBackgroundView:imageView];
//    
//    FAKFontAwesome *menuIcon = [FAKFontAwesome barsIconWithSize:16];
//    [menuIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
//    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithImage:[menuIcon imageWithSize:CGSizeMake(15, 15)] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
//    self.navigationItem.leftBarButtonItem = menuBtn;
//    
//    // set logo image
//    UIImage* logo = [UIImage imageNamed:@"Logo"];
//    UIImageView* logoView = [[UIImageView alloc] initWithImage:logo];
//    logoView.contentMode = UIViewContentModeScaleAspectFit;
//    self.navigationItem.titleView = logoView;
//    
//    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menu_view"];
//    self.menuViewController.delegate = self;
//    UIView* menuView = self.menuViewController.view;
//    menuView.frame = self.view.bounds;
//    [self.view addSubview:menuView];
////    [self.view bringSubviewToFront:menuView];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Artist";
    } else {
        return @"LiveInfo";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSLog(@"%ld", [indexPath section]);
    if ([indexPath section] == 0) {
        cell.textLabel.text = @"Artist...";
    } else {
        cell.textLabel.text = @"News...";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.backgroundColor = [UIColor clearColor];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"showArtist" sender:self];
    } else {
        [self performSegueWithIdentifier:@"showInfo" sender:self];
    }
}

- (void) showAgreementView {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:YES forKey:@"agreement"];
}

- (void)didSelectSetting
{
    
}

- (void) didSettingViewClosed
{
    
}

- (void) didMenuToggledVisible:(BOOL)visible
{
    
}

- (void) showMenu {
    if (self.menuViewController.view.hidden) {
        self.menuViewController.view.hidden = NO;
    } else {
        self.menuViewController.view.hidden = YES;
    }
}

@end
