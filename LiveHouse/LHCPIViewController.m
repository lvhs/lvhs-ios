//
//  LHCPIViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 9/3/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHCPIViewController.h"

@interface LHCPIViewController ()
- (IBAction)back:(id)sender;
- (IBAction)goCPIDetail:(id)sender;

@end

@implementation LHCPIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goCPIDetail:(id)sender {
    [self performSegueWithIdentifier:@"goCPIDetail" sender:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
