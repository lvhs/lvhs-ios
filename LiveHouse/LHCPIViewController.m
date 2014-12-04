//
//  LHCPIViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 9/3/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHCPIViewController.h"
#import <CAR/CARMedia.h>

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
    CARMediaViewController *vc = [[CARMediaViewController alloc] initWithTitle:@"タイトル" buttonTitle:@"戻る" tintColor:nil];
    vc.publicAppKey = @"ncIdX3la";
    vc.apiKey = @"26254487d9a595ee";
    vc.mId = @"5006";
    vc.userId = @"00001";
    vc.fromId = @"test";
    NSString *url = [NSString stringWithFormat:@"http://car.mobadme.jp/spg/spnew/%@/%@/index.php", @"807", vc.mId];
    [vc loadURLString:url];
    [self presentViewController:vc animated:YES completion:nil];
//    [self performSegueWithIdentifier:@"goCPIDetail" sender:self];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
