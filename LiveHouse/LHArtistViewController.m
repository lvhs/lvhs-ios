//
//  LHArtistViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 9/1/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHArtistViewController.h"
#import "UIActionSheet+Blocks.h"

@interface LHArtistViewController ()
- (IBAction)back:(id)sender;
- (IBAction)goOfficial:(id)sender;
- (IBAction)playMusic:(id)sender;
- (IBAction)playMovie:(id)sender;

@end

@implementation LHArtistViewController

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

- (IBAction)goOfficial:(id)sender {
//    [[UIApplication sharedApplication] openURL:request.URL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://myfirststory.net"]];
}

- (IBAction)playMusic:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"purchased"]) {
        [defaults setBool:NO forKey:@"purchased"];
        [defaults synchronize];
        [self performSegueWithIdentifier:@"goPlayer" sender:self];
    } else {
        [UIActionSheet showInView:self.view
                        withTitle:@"CPI"
                cancelButtonTitle:@"キャンセル"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"アプリDLでGET", @"課金でGET"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             NSLog(@"Chose %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
                             [self performSegueWithIdentifier:@"goCPI" sender:self];
                         }];
    }
}

- (IBAction)playMovie:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"purchased"]) {
        [defaults setBool:NO forKey:@"purchased"];
        [defaults synchronize];
        [self performSegueWithIdentifier:@"goMovie" sender:self];
    } else {
        [UIActionSheet showInView:self.view
                        withTitle:@"CPI"
                cancelButtonTitle:@"キャンセル"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"アプリDLでGET", @"課金でGET"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             NSLog(@"Chose %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
                             [self performSegueWithIdentifier:@"goCPI" sender:self];
                         }];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [[UIApplication sharedApplication] openURL:request.URL];
    return NO;
}


@end
