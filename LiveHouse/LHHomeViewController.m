//
//  LHHomeViewController.m
//  LiveHouse
//
//  Created by Masayuki Uehara on 10/6/14.
//  Copyright (c) 2014 LIVEHOUSE inc. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <AFNetworking/AFNetworking.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FontAwesomeKit/FAKFontAwesome.h>
#import <YTVimeoExtractor/YTVimeoExtractor.h>
#import <CAR/CARMedia.h>
#import "UIAlertView+Blocks/UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks/UIActionSheet+Blocks.h"
#import "UIAlertController+Blocks/UIAlertController+Blocks.h"
#import "NSString+Util.h"

#import "LHAppDelegate.h"
#import "LHConfig.h"
#import "LHHomeViewController.h"
#import "LHURLRequest.h"
#import "UIApplication+UIID.h"


@interface LHHomeViewController () <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate,
SKPaymentTransactionObserver> {
    UIBarButtonItem *backBtn;
    UIBarButtonItem *reloadBtn;
    UIBarButtonItem *prevBtn;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnItem;
@property (weak, nonatomic) IBOutlet UIImageView *overlay;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSString* urlQueue;
@property (nonatomic) NSArray* menuRows;
@property (strong, nonatomic) SKProductsRequest *productsRequest;

- (IBAction)goHome:(id)sender;
- (IBAction)toggleMenu:(id)sender;
@property MPMoviePlayerViewController *playerViewController;

@end

@implementation LHHomeViewController

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkPushNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMenu];
    [self checkPushNotification];
    [self initWebView];
    [self initHeaderIcons];
    
    // menu
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationWithUrl:) name:@"receiveNotificationWithUrl" object:nil];
    
    [self checkInAppPurchaseIsAvailable];
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

#pragma mark - WebView

- (void) checkPushNotification {
    LHAppDelegate* appDelegate = [LHAppDelegate sharedInstance];
    if (appDelegate.launchingRomoteNotificationOptions) {
        //プッシュ通知タップからのアプリ起動
        [self processPushNotification:appDelegate.launchingRomoteNotificationOptions];
        appDelegate.launchingRomoteNotificationOptions = nil;
    }
}

- (void) processPushNotification:(NSDictionary*)userInfo {
    NSString* type = userInfo[@"type"];
    if ([type isEqual:@"url"]) {
        self.urlQueue = userInfo[@"url"];
    }
}

- (void) loadWebViewWithUrl:(NSString *)url {
    NSURL *urlObj = [NSURL URLWithString:url];
    LHURLRequest *req = [LHURLRequest requestWithURL:urlObj];
    [_webView loadRequest:req];
}

- (void) receiveNotificationWithUrl:(NSNotification *) notification {
    NSDictionary* userInfo = [notification userInfo];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:userInfo[@"aps"][@"alert"]
                                                 message:@""
                                                delegate:self
                                       cancelButtonTitle:nil
                                       otherButtonTitles:@"OK", nil];
    
    av.alertViewStyle = UIAlertViewStyleDefault;
    av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        [self loadWebViewWithUrl:userInfo[@"url"]];
    };
    [av show];
}

- (void) processUrlQueue {
    if (self.urlQueue) {
        [self loadWebViewWithUrl:self.urlQueue];
        self.urlQueue = nil;
    }
}

- (void) initWebView {
    // initialize webview
    UIWebView *wv = _webView;
    wv.delegate = self;
    wv.scalesPageToFit = YES;
    LHConfig *config = [LHConfig sharedInstance];
    NSURL *url = [NSURL URLWithString:[config objectForKey:LH_CONFIG_KEY_WEB_BASE_URL]];
    LHURLRequest *req = [LHURLRequest requestWithURL:url];
    [wv loadRequest:req];
}

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
        
        NSDictionary *params = [self parseUrlParams:request.URL.query];
        NSString *itemId    = [params valueForKey:@"iid"];
        NSString *vimeoId   = [params valueForKey:@"vid"];
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:itemId forKey:@"itemId"];
        
        NSString *vimeoUrl = [NSString stringWithFormat:@"https://vimeo.com/%@", vimeoId];
        [YTVimeoExtractor fetchVideoURLFromURL:vimeoUrl
                                       quality:YTVimeoVideoQualityMedium
                                       referer:@"http://lvhs.jp"
                             completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
                                 if (error) {
                                     // handle error
                                     NSLog(@"Video URL: %@", [videoURL absoluteString]);
                                 } else {
                                     // run player
                                     self.playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
                                     [self.playerViewController.moviePlayer prepareToPlay];
                                     [self presentViewController:self.playerViewController animated:YES completion:nil];
                                 }
                             }];
        
        return NO;
    }
    else if ([request.URL.scheme isEqualToString:@"purchase"]) {
        NSDictionary *params = [self parseUrlParams:request.URL.query];
        
        NSString *productId  = [params valueForKey:@"pid"];
        NSString *itemId     = [params valueForKey:@"iid"];
        NSString *title      = [params valueForKey:@"title"];
        NSString *btitle      = [params valueForKey:@"btitle"];
        NSString *rtitle      = [params valueForKey:@"rtitle"];
        NSString *rewardFlag = [params valueForKey:@"rwd"];
        NSMutableArray *buttons = [NSMutableArray arrayWithArray:@[btitle != nil ? [btitle decodeString] : @"購入する"]];
        
        if (title == nil) {
            title = @"この動画を購入しますか？";
        } else {
            title = [title decodeString];
        }
        
        if (rewardFlag != nil) {
            if (rtitle != nil) {
                [buttons addObject:[rtitle decodeString]];
            } else {
                [buttons addObject:@"アプリをDLしてGET"];
            }
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:itemId forKey:@"itemId"];
        [defaults setValue:productId forKey:@"productId"];
        
        void(^handlePurchaseBlock)(NSInteger, NSInteger) = ^(NSInteger buttonIndex, NSInteger firstIndex){
            if (buttonIndex == firstIndex) {
                [self getInAppPurchaseItems:productId];
            }
            else if (buttonIndex == (firstIndex + 1) && rewardFlag != nil) {
                LHConfig *config = [LHConfig sharedInstance];
                NSString* urlStr = [config objectForKey:LH_CONFIG_KEY_WEB_BASE_URL];
                urlStr = [urlStr stringByAppendingString:@"/car/list"];
                NSURL *url = [NSURL URLWithString:urlStr];
                LHURLRequest *req = [LHURLRequest requestWithURL:url];
                [_webView loadRequest:req];
            }
        };
        
        if ([UIAlertController class]) {
            [UIAlertController showAlertInViewController:self
                                               withTitle:title
                                                 message:nil
                                       cancelButtonTitle:@"キャンセル"
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:buttons
                                                tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                                                    handlePurchaseBlock(buttonIndex, 2);
                                                }];
        } else {
            [UIAlertView showWithTitle:title
                               message:nil
                     cancelButtonTitle:@"キャンセル"
                     otherButtonTitles:buttons
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex){
                                  handlePurchaseBlock(buttonIndex, 1);
                              }];
        }
        return NO;
    }
    else if ([request.URL.host rangeOfString:@"lvhs.jp"].location == NSNotFound) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView*)webView{
    // ページ読込完了時にインジケータを非表示にする
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateBackButton];
    [self processUrlQueue];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] != NSURLErrorCancelled) {
        NSLog(@"Network Error : %@", error);
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"通信エラーが発生しました。\nもう一度電波の良い所で試して下さい。"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
        
        av.alertViewStyle = UIAlertViewStyleDefault;
        [av show];
    }
}

- (void)updateBackButton {
    if ([self.webView canGoBack]) {
        //        if (!self.navigationItem.leftBarButtonItem) {
        //            [self.navigationItem setHidesBackButton:YES animated:YES];
        //            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
        //                                                                          style:UIBarButtonItemStylePlain
        //                                                                         target:self
        //                                                                         action:@selector(backWasClicked:)];
        //            [self.navigationItem setLeftBarButtonItem:backItem animated:YES];
        //        }
        
        _navigationBar.topItem.leftBarButtonItems = @[backBtn, _btnItem];
    } else {
        _navigationBar.topItem.leftBarButtonItems = @[ _btnItem];
    }
    if ([self.webView canGoForward]) {
        _navigationBar.topItem.rightBarButtonItems = @[prevBtn, reloadBtn];
    }
    else {
        _navigationBar.topItem.rightBarButtonItems = @[reloadBtn];
        //        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        //        [self.navigationItem setHidesBackButton:NO animated:YES];
    }
}

- (void)backWasClicked:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)prevWasClicked:(id)sender {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)reloadWasClicked:(id)sender {
    [self.webView reload];
}

#pragma mark - TableView

- (void) initMenu {
     _menuRows = @[@{
                      @"title": @"シェア",
                      @"type": @"share"
                  },
                  @{
                      @"title": @"お問い合わせ",
                      @"type": @"support"
                  },
                  @{
                      @"title": @"購入履歴の復元",
                      @"type": @"restore"
                  }];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    LHConfig *config = [LHConfig sharedInstance];
    NSString* url = [config objectForKey:LH_CONFIG_KEY_WEB_BASE_URL];
    url = [url stringByAppendingString:@"/menu.json"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            _menuRows = responseObject;
            [_tableView reloadData];
            CGFloat height = _tableView.contentSize.height;
            CGRect frame = _tableView.frame;
            frame.size.height = height;
            _tableView.frame = frame;
        }
        @catch (NSException *e) {
            NSLog(@"error creating menu: %@", e);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuRows.count;
}

-(UITableViewCell *)tableView:
(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"menu_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セルにテキストを設定
    // セルの内容はNSArray型の「items」にセットされているものとする
    cell.textLabel.text = [[_menuRows objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goMenu:)];
    [cell setTag:indexPath.row];
    [cell addGestureRecognizer:tapGesture];
    
    return cell;
}

- (void) adjustMenuHeight {
    
}

- (void)goMenu:(UITapGestureRecognizer *)sender {
    NSInteger idx = sender.view.tag;
    NSDictionary* menu = [_menuRows objectAtIndex:idx];
    NSString* type = [menu objectForKey:@"type"];
    if ([type compare:@"share"] == NSOrderedSame) {
        NSString *sharedText = @"LIVEHOUSEをシェアしよう！";
        NSURL *url = [NSURL URLWithString:@"http://lvhs.jp/"];
        NSArray *activityItems = @[sharedText, url];
        UIActivity *activity = [[UIActivity alloc] init];
        NSArray *appActivities = @[activity];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                 applicationActivities:appActivities];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    else if ([type compare:@"support"] == NSOrderedSame) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self generateSupportMailLink]]];
    }
    else if ([type compare:@"restore"] == NSOrderedSame) {
        [self restoreInAppPurchaseItems];
    }
    else if ([type compare:@"url"] == NSOrderedSame) {
        [self loadWebViewWithUrl:[menu objectForKey:@"data"]];
        [self toggleMenu:nil];
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

- (void)checkInAppPurchaseIsAvailable {
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

- (void)restoreInAppPurchaseItems {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)getInAppPurchaseItems:(NSString*) productId {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    NSSet *set = [NSSet setWithObjects:productId, nil];
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    if (response == nil) return;
    
    // 無効なアイテムがないかチェック
    if ([response.invalidProductIdentifiers count] > 0) {
        for (NSString *identifier in response.invalidProductIdentifiers) {
            NSLog(@"invalid product identifier: %@", identifier);
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"アイテムIDが不正です。"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // 購入処理開始
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
            
            [self updatePaymentInfo:false];
            
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
        } else if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            LHConfig *config = [LHConfig sharedInstance];
            NSString* url = [config objectForKey:LH_CONFIG_KEY_WEB_BASE_URL];
            url = [url stringByAppendingString:@"/products"];
            
            [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSMutableArray *productIDsToRestore = responseObject;
                if ([productIDsToRestore containsObject:transaction.transactionIdentifier]) {
                    [self updatePaymentInfo:transaction.transactionIdentifier restore:true];
                    [queue finishTransaction:transaction];
                } else {
                    [queue finishTransaction:transaction];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // エラーが発生したことをユーザに知らせる
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                                message:[transaction.error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
                [queue finishTransaction:transaction];
            }];
        } else {
            // リストア処理完了
            /*
             * アイテムの再付与を行う
             */
            [self updatePaymentInfo:true];
            [queue finishTransaction:transaction];
        }
    }
    [_webView reload];
}

- (void)updatePaymentInfo:(NSString *) productId restore:(BOOL) restore {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                 @"pid": productId
                                 }];
    if (restore) {
        [parameters setValue:[NSNumber numberWithBool:restore] forKey:@"restore"];
    }
    LHConfig *config = [LHConfig sharedInstance];
    NSString* url = [config objectForKey:LH_CONFIG_KEY_WEB_BASE_URL];
    url = [url stringByAppendingString:@"/purchase"];
    
    NSLog(@"updatePaymentInfo with productId: %@", parameters);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [_webView reload];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)updatePaymentInfo:(BOOL) restore {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                 @"iid": [defaults valueForKey:@"itemId"],
                                 @"pid": [defaults valueForKey:@"productId"]
                                 }];
    if (restore) {
        [parameters setValue:[NSNumber numberWithBool:restore] forKey:@"restore"];
    }
    LHConfig *config = [LHConfig sharedInstance];
    NSString* url = [config objectForKey:LH_CONFIG_KEY_WEB_BASE_URL];
    url = [url stringByAppendingString:@"/purchase"];
    
    NSLog(@"updatePaymentInfo: %@", parameters);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [_webView reload];
        //                [queue finishTransaction:transaction];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    // リストアの失敗
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                    message:@"購入済み動画の復元に失敗しました"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    return;
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"ok finished");
    // 全てのリストア処理が終了
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確認"
                                                    message:@"購入済み動画を復元しました"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    return;
}

#pragma mark - Util

- (NSMutableDictionary *)parseUrlParams:(NSString*)url {
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [url componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [pairComponents objectAtIndex:0];
        NSString *value = [pairComponents objectAtIndex:1];
        
        [queryStringDictionary setObject:value forKey:key];
    }
    return queryStringDictionary;
}

#pragma mark - UI

- (void) initHeaderIcons {
    // メニューアイコン
    FAKFontAwesome *menuIcon = [FAKFontAwesome barsIconWithSize:16];
    [menuIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    _btnItem.image = [menuIcon imageWithSize:CGSizeMake(15, 15)];
    [_btnItem setAction:@selector(toggleMenu:)];
    
    backBtn = [[UIBarButtonItem alloc] init];
    FAKFontAwesome *backIcon = [FAKFontAwesome chevronLeftIconWithSize:16];
    [backIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    backBtn.image = [backIcon imageWithSize:CGSizeMake(15, 15)];
    [backBtn setAction:@selector(backWasClicked:)];
    
    reloadBtn = [[UIBarButtonItem alloc] init];
    FAKFontAwesome *reloadIcon = [FAKFontAwesome repeatIconWithSize:16];
    [reloadIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    reloadBtn.image = [reloadIcon imageWithSize:CGSizeMake(15, 15)];
    [reloadBtn setAction:@selector(reloadWasClicked:)];
    
    prevBtn = [[UIBarButtonItem alloc] init];
    FAKFontAwesome *prevIcon = [FAKFontAwesome chevronRightIconWithSize:16];
    [prevIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    prevBtn.image = [prevIcon imageWithSize:CGSizeMake(15, 15)];
    [prevBtn setAction:@selector(prevWasClicked:)];
    
    _navigationBar.topItem.leftBarButtonItems = @[_btnItem];
    _navigationBar.topItem.rightBarButtonItems = @[reloadBtn];
}

- (NSString* ) generateSupportMailLink {
    NSString* subject = @"[LIVEHOUSE] 問い合わせ";
    NSString* body = [[NSString alloc]
                      initWithFormat:@"\n"
                                      "\n"
                                      "\n"
                                      "\n"
                                      "---\n"
                                      "端末: %@\n"
                                      "OSバージョン: %@\n"
                                      "ID: %@\n",
                      [UIDevice currentDevice].model,
                      [UIDevice currentDevice].systemVersion,
                      [[UIApplication sharedApplication] uniqueInstallationIdentifier]
                      ];
    NSString* encodedSubject = [subject stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString* encodedBody = [body stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    return [[NSString alloc] initWithFormat:@"mailto:support@lvhs.jp?subject=%@&body=%@", encodedSubject, encodedBody];
}

@end
