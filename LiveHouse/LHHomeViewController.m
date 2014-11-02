//
//  LHHomeViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 10/6/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FontAwesomeKit/FAKFontAwesome.h>
//#import <CAR/CARMedia.h>
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"

#import "LHConfig.h"
#import "LHHomeViewController.h"
#import "LHURLRequest.h"

@interface LHHomeViewController () <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate,
SKPaymentTransactionObserver>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnItem;
@property (weak, nonatomic) IBOutlet UIImageView *overlay;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)goHome:(id)sender;
- (IBAction)toggleMenu:(id)sender;

@end

@implementation LHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *wv = _webView;
    wv.delegate = self;
    wv.scalesPageToFit = YES;
//    [self.view addSubview:wv];
    LHConfig *config = [LHConfig sharedInstance];
//    NSURL *url = [NSURL URLWithString:[config objectForKey:LH_CONFIG_KEY_WEB_BASE_URL]];
    NSURL *url = [NSURL URLWithString:@"http://dev.lvhs.jp/app"];
    LHURLRequest *req = [LHURLRequest requestWithURL:url];
    [wv loadRequest:req];
    
    // メニューアイコン
    FAKFontAwesome *menuIcon = [FAKFontAwesome barsIconWithSize:16];
    [menuIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    _btnItem.image = [menuIcon imageWithSize:CGSizeMake(15, 15)];
    [_btnItem setAction:@selector(toggleMenu:)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self checkInAppPurchaseIsAvaiable];
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
    else if ([request.URL.scheme isEqualToString:@"player"]) {
        if ([request.URL.host isEqualToString:@"music"]) {
            [self performSegueWithIdentifier:@"goPlayer" sender:self];
        } else {
            [self performSegueWithIdentifier:@"goMovie" sender:self];
        }
    }
    else if ([request.URL.scheme isEqualToString:@"purchase"]) {
        [UIActionSheet showInView:self.view
                        withTitle:@"CPI"
                cancelButtonTitle:@"キャンセル"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"アプリDLでGET", @"課金でGET"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex == 0) {
                                 [self performSegueWithIdentifier:@"goCPI" sender:self];
                             } else if (buttonIndex == 1) {
                                 [self getInAppPurchaseItems];
//                                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sign in to my awesome service"
//                                                                              message:@"I promise I won’t steal your password"
//                                                                             delegate:self
//                                                                    cancelButtonTitle:@"Cancel"
//                                                                    otherButtonTitles:@"OK", nil];
//                                 
//                                 av.alertViewStyle = UIAlertViewStyleSecureTextInput;
//                                 
//                                 av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
//                                     if (buttonIndex == alertView.firstOtherButtonIndex) {
//                                         NSLog(@"Password: %@", [[alertView textFieldAtIndex:0] text]);
//                                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                                         [defaults setBool:YES forKey:@"purchased"];
//                                         [defaults synchronize];
//                                     } else if (buttonIndex == alertView.cancelButtonIndex) {
//                                         NSLog(@"Cancelled.");
//                                     }
//                                 };
//                                 
//                                 av.shouldEnableFirstOtherButtonBlock = ^BOOL(UIAlertView *alertView) {
//                                     return ([[[alertView textFieldAtIndex:0] text] length] > 0);
//                                 };
//                                 
//                                 [av show];
                             }

                         }];
        return NO;
    }
    else if (![request.URL.host containsString:@"lvhs.jp"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView*)webView{
    // ページ読込完了時にインジケータを非表示にする
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateBackButton];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    NSLog(@"Network Error : %@", error);
//    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"ネットワークにつながりません"
//                                                 message:@""
//                                                delegate:self
//                                       cancelButtonTitle:nil
//                                       otherButtonTitles:@"OK", nil];
//    
//    av.alertViewStyle = UIAlertViewStyleDefault;
//    [av show];
}

- (void)updateBackButton {
    if ([self.webView canGoBack]) {
        if (!self.navigationItem.leftBarButtonItem) {
            [self.navigationItem setHidesBackButton:YES animated:YES];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(backWasClicked:)];
            [self.navigationItem setLeftBarButtonItem:backItem animated:YES];
        }
    }
    else {
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        [self.navigationItem setHidesBackButton:NO animated:YES];
    }
}

- (void)backWasClicked:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
//    return 3;
    return 2;
}

-(UITableViewCell *)tableView:
(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"menu_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *items = @[
                       @"シェア",
                       @"お問い合わせ",
//                       @"レビュー"
                       ];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セルにテキストを設定
    // セルの内容はNSArray型の「items」にセットされているものとする
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goMenu:)];
    [cell setTag:indexPath.row];
    [cell addGestureRecognizer:tapGesture];
    
    return cell;
}

- (void)goMenu:(UITapGestureRecognizer *)sender {
    if (sender.view.tag == 0) {
        NSString *sharedText = @"LIVEHOUSEをシェアしよう！";
        NSURL *url = [NSURL URLWithString:@"http://app.lvhs.jp/"];
        NSArray *activityItems = @[sharedText, url];
        UIActivity *activity = [[UIActivity alloc] init];
        NSArray *appActivities = @[activity];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                 applicationActivities:appActivities];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    else if (sender.view.tag == 1) {
        [self performSegueWithIdentifier:@"goSetting" sender:self];
    }
    else if (sender.view.tag == 2) {
        [self performSegueWithIdentifier:@"goReview" sender:self];
    }
}

- (IBAction)goHome:(id)sender {
    LHConfig *config = [LHConfig sharedInstance];
    NSURL *url = [NSURL URLWithString:[config objectForKey:LH_CONFIG_KEY_WEB_BASE_URL]];
    LHURLRequest *req = [LHURLRequest requestWithURL:url];
    [_webView loadRequest:req];
}

- (IBAction)toggleMenu:(id)sender {
    _menuView.hidden = !_menuView.hidden;
    _overlay.hidden = !_overlay.hidden;
}

#pragma mark - In App Purchase

- (void)checkInAppPurchaseIsAvaiable {
    if (![SKPaymentQueue canMakePayments]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"アプリ内課金が制限されています。"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
}

- (void)getInAppPurchaseItems {
    NSSet *set = [NSSet setWithObjects:@"jp.lvhs.livehouse.ticket100", nil];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    // 無効なアイテムがないかチェック
    if ([response.invalidProductIdentifiers count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"アイテムIDが不正です。"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // 購入処理開始
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    for (SKProduct *product in response.products) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchasing) {
            // 購入処理中
            /*
             * 基本何もしなくてよい。処理中であることがわかるようにインジケータをだすなど。
             */
        } else if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            // 購入処理成功
            /*
             * ここでレシートの確認やアイテムの付与を行う。
             */
            [queue finishTransaction:transaction];
        } else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
            // 購入処理エラー。ユーザが購入処理をキャンセルした場合もここにくる
            [queue finishTransaction:transaction];
            // エラーが発生したことをユーザに知らせる
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                            message:[transaction.error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
        } else {
            // リストア処理完了
            /*
             * アイテムの再付与を行う
             */
            [queue finishTransaction:transaction];
        }
    }		
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    // リストアの失敗
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    // 全てのリストア処理が終了
}

@end
