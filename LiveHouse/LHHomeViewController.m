//
//  LHHomeViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 10/6/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHConfig.h"
#import "LHHomeViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <CAR/CARMedia.h>
#import "LHURLRequest.h"

@interface LHHomeViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *wv = _webView;
    wv.delegate = self;
    wv.scalesPageToFit = YES;
    [self.view addSubview:wv];
    LHConfig *config = [LHConfig sharedInstance];
//    NSURL *url = [NSURL URLWithString:[config objectForKey:LH_CONFIG_KEY_WEB_BASE_URL]];
    NSURL *url = [NSURL URLWithString:@"http://dev.lvhs.jp/app"];
    LHURLRequest *req = [LHURLRequest requestWithURL:url];
    [wv loadRequest:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loginWithFacebook {
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.center = self.view.center;
    [self.view addSubview:loginView];
}

#pragma mark - WebView

-(void)webViewDidStartLoad:(UIWebView*)webView{
    // ページ読込開始時にインジケータをくるくるさせる
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateBackButton];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // リンクがクリックされたとき
    if (navigationType == UIWebViewNavigationTypeLinkClicked ||
        navigationType == UIWebViewNavigationTypeOther) {
        [self updateBackButton];
    }
    if ([request.URL.scheme isEqualToString:@"turbolinks"]) {
        [self updateBackButton];
        return NO;
    }
    
    
//    if (request)
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView*)webView{
    // ページ読込完了時にインジケータを非表示にする
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateBackButton];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Network Error : %@", error);
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"ネットワークにつながりません"
                                                 message:@""
                                                delegate:self
                                       cancelButtonTitle:nil
                                       otherButtonTitles:@"OK", nil];
    
    av.alertViewStyle = UIAlertViewStyleDefault;
    [av show];
}

- (void)updateBackButton {
    if ([self.webView canGoBack]) {
        if (!_navigationBar.backItem.leftBarButtonItem) {
            [_navigationBar.backItem setHidesBackButton:YES animated:YES];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backWasClicked:)];
            [_navigationBar.backItem setLeftBarButtonItem:backItem animated:YES];
        }
    }
    else {
        [_navigationBar.backItem setLeftBarButtonItem:nil animated:YES];
        [_navigationBar.backItem setHidesBackButton:NO animated:YES];
    }
}

- (void)backWasClicked:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

@end
