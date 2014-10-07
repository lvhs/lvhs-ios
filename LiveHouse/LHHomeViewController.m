//
//  LHHomeViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 10/6/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import "LHHomeViewController.h"

@interface LHHomeViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)goHome:(id)sender;

@end

@implementation LHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goHome:)];
    UIWebView *wv = _webView;
    [wv addGestureRecognizer:tapGesture];
    wv.delegate = self;
//    wv.frame = self.view.frame;
    wv.scalesPageToFit = YES;
    [self.view addSubview:wv];
    NSURL *url = [NSURL URLWithString:@"http://app.lvhs.jp/app"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [wv loadRequest:req];

}

// ページ読込開始時にインジケータをくるくるさせる
-(void)webViewDidStartLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goHome:(id)sender {
    [self performSegueWithIdentifier:@"goHome" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
