//
//  LHCPIDetailViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 9/3/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHCPIDetailViewController.h"

@interface LHCPIDetailViewController ()
- (IBAction)purchase:(id)sender;

@end

@implementation LHCPIDetailViewController

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

- (IBAction)purchase:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"purchased"];
    [defaults synchronize];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"returnArtist" sender:self];
}
@end
